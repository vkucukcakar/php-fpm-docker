#!/bin/bash

###
# vkucukcakar/php-fpm
# PHP-FPM Docker image with automatic configuration file creation and export
# Copyright (c) 2017 Volkan Kucukcakar
# 
# This file is part of vkucukcakar/php-fpm.
# 
# vkucukcakar/php-fpm is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
# 
# vkucukcakar/php-fpm is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
# 
# This copyright notice and license must be retained in all files and derivative works.
###

# Create configuration files using environment variables if auto configuration is enabled and configuration files are not found
# Symbolic links are then created from known configuration files at /configurations directory to their original locations
if [ "$AUTO_CONFIGURE" == "enable" ]; then
	echo "AUTO_CONFIGURE enabled, starting auto configuration."	
	# Limit environment variables to substitute
	SHELL_FORMAT='$CONTAINER_NAME,$DOMAIN_NAME,$SSMTP_MAILHUB'
	
	# Check if the required environment variables are set and create configuration files
	if [ "$CONTAINER_NAME" ] && [ "$DOMAIN_NAME" ] && [ "$SSMTP_MAILHUB" ]; then 
		# Check if /configurations/php.ini configuration file already exists/mounted
		if [ ! -f /configurations/php.ini ]; then
			echo "Creating configuration file '/configurations/php.ini' from template."
			# Substitute the values of environment variables to create the real configuration file from template
			envsubst "$SHELL_FORMAT" < /templates/php.ini > /configurations/php.ini
		else
			echo "Configuration file '/configurations/php.ini' already exists, skipping file creation. You can edit the file according to your needs."
		fi
				
		# Check if /configurations/php-fpm-www.conf configuration file already exists/mounted
		if [ ! -f /configurations/php-fpm-www.conf ]; then
			echo "Creating configuration file '/configurations/php-fpm-www.conf' from template."
			# Substitute the values of environment variables to create the real configuration file from template
			envsubst "$SHELL_FORMAT" < /templates/php-fpm-www.conf > /configurations/php-fpm-www.conf
		else
			echo "Configuration file '/configurations/php-fpm-www.conf' already exists, skipping file creation. You can edit the file according to your needs."
		fi
		
		# Check if /configurations/ssmtp.conf configuration file already exists/mounted
		if [ ! -f /configurations/ssmtp.conf ]; then
			echo "Creating configuration file '/configurations/ssmtp.conf' from template." 
			# Substitute the values of environment variables to create the real configuration file from template
			envsubst "$SHELL_FORMAT" < /templates/ssmtp.conf > /configurations/ssmtp.conf
		else
			echo "Configuration file '/configurations/ssmtp.conf' already exists, skipping file creation. You can edit the file according to your needs."
		fi

		# Removed variables
		if [ "$SERVER_INTERNAL_HOSTNAME" ] || [ "$SERVER_INTERNAL_IP" ]; then
			echo "Warning: SERVER_INTERNAL_HOSTNAME and SERVER_INTERNAL_IP variables removed. Please use network aliases for your server container."
		fi	
		
	else
		echo "Error: One or more environment variable required for AUTO_CONFIGURE is not set, please check: CONTAINER_NAME, DOMAIN_NAME, SSMTP_MAILHUB"
		exit 1
	fi	
	
	# Create symbolic links for configuration files
	
	# Create symbolic link for configuration file '/configurations/php.ini' to real location
	if [ ! -f /usr/local/etc/php/conf.d/php.ini ]; then
		echo "Creating symbolic link for configuration file '/configurations/php.ini' to '/usr/local/etc/php/conf.d/php.ini'"
		ln -s /configurations/php.ini /usr/local/etc/php/conf.d/php.ini
	elif [ ! -L /usr/local/etc/php/conf.d/php.ini ]; then
		echo "Warning: The file '/usr/local/etc/php/conf.d/php.ini' is not a symbolic link created by AUTO_CONFIGURE. You can delete the file if you want to create symbolic link on next startup."
	fi

	# Create symbolic link for configuration file '/configurations/php-fpm-www.conf' to real location
	if [ ! -f /usr/local/etc/php-fpm.d/php-fpm-www.conf ]; then
		echo "Creating symbolic link for configuration file '/configurations/php-fpm-www.conf' to '/usr/local/etc/php-fpm.d/php-fpm-www.conf'"
		ln -s /configurations/php-fpm-www.conf /usr/local/etc/php-fpm.d/php-fpm-www.conf
	elif [ ! -L /usr/local/etc/php-fpm.d/php-fpm-www.conf ]; then
		echo "Warning: The file '/usr/local/etc/php-fpm.d/php-fpm-www.conf' is not a symbolic link created by AUTO_CONFIGURE. You can delete the file if you want to create symbolic link on next startup."
	fi

	# Create symbolic link for configuration file '/configurations/ssmtp.conf' to real location
	if [ ! -f /etc/ssmtp/ssmtp.conf ]; then
		echo "Creating symbolic link for configuration file '/configurations/ssmtp.conf' to '/etc/ssmtp/ssmtp.conf'"
		ln -s /configurations/ssmtp.conf /etc/ssmtp/ssmtp.conf
	elif [ ! -L /etc/ssmtp/ssmtp.conf ]; then
		echo "Warning: The file '/etc/ssmtp/ssmtp.conf' is not a symbolic link created by AUTO_CONFIGURE. You can delete the file if you want to create symbolic link on next startup."
	fi	
	echo "AUTO_CONFIGURE completed."
	
    # Change uid of default user www-data. You can make this match your current uid (id -u) on host to easily access mounted volumes for development.
	if [ "$CHANGE_UID" ]; then
		echo "Changing uid of default user www-data to ${CHANGE_UID}"
		usermod -u ${CHANGE_UID} www-data
	fi	

    # Change gid of default group www-data. You can make this match your current gid (id -g) on host for development.
	if [ "$CHANGE_GID" ]; then
		echo "Changing gid of default group www-data to ${CHANGE_GID}"
		groupmod -g ${CHANGE_GID} www-data
	fi	

	# Change owner of /var/www/html and some special directories (/data/opcache, /sessions, /home/www-data) recursively to "www-data:www-data".
	# As the default user is www-data and it is already used in PHP-FPM configuration files, this will solve PHP permission errors for development.
	# This also affects the directories and files at host if you mount volumes. Will also be enabled if CHANGE_UID or CHANGE_GID is set.
	# *** Must be executed after usermod and groupmod since owner and groups do not change automatically after
	#     usermod and groupmod except the files/directories "inside" user's home
	if [ "$CHANGE_UID" ] || [ "$CHANGE_GID" ] || [ "$CHANGE_OWNER"=="enable" ]; then
		# Change owner of /var/www/html
		echo "Changing owner of /var/www/html recursively to www-data:www-data"
		chown -R www-data:www-data /var/www/html
		# Change owner of /data/opcache
		echo "Changing owner of /data/opcache recursively to www-data:www-data"
		chown -R www-data:www-data /data/opcache		
		# Change owner of /sessions
		echo "Changing owner of /sessions recursively to www-data:www-data"
		chown -R www-data:www-data /sessions		
		# Change owner of /home/www-data
		echo "Changing owner of /home/www-data recursively to www-data:www-data"
		chown -R www-data:www-data /home/www-data
	fi
else
	echo "AUTO_CONFIGURE disabled."
fi

# Continue with default entrypoint with default cmd
echo "Executing php default entrypoint with default cmd: docker-php-entrypoint $@"
exec "docker-php-entrypoint" "$@"
