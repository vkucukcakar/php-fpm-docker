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

# Try to resolve SERVER_INTERNAL_HOSTNAME and write the /etc/hosts entry
while :
do
	_RESOLVE_IP=$(getent hosts $1 | awk '{ print $1 }')
	if [ "$_RESOLVE_IP" ]; then
		echo -e "\n${_RESOLVE_IP} $2" >>/etc/hosts
		break
	fi
	sleep 1
done

echo "Notice: Deferred procedure done. Resolved SERVER_INTERNAL_HOSTNAME ($1) and added the /etc/hosts entry for $2"
