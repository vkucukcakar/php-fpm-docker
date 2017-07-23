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
else
	echo "AUTO_CONFIGURE disabled."
fi

# Continue with default entrypoint with default cmd
echo "Executing php default entrypoint with default cmd: docker-php-entrypoint $@"
exec "docker-php-entrypoint" "$@"
