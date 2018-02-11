# Changelog

## v1.0.4
- Upgraded parent image to official PHP 7.2.2 current stable image
- Removed mcrypt extension which is declared abandonware, deprecated in PHP 7.1 and removed from PHP 7.2 core
- Fixed other build issues as Alpine image upgraded to 3.6, Debian image upgraded to Stretch
- Removed opcache.fast_shutdown from fpm configuration as it is removed from PHP 7.2.0
- Fixed image size reduction
- Created Dockerfile-alpine-extras with extra php and pecl extensions installed/enabled (bcmath, bz2, imap, soap, sockets, shmop, xmlrpc, apcu, imagick, redis)

## v1.0.3
- Upgraded parent image to PHP 7.1.8
- Minor fixes
- Reversed changelog

## v1.0.2

- Added functionality to fix permission related problems for some conditions
- Added CHANGE_OWNER, CHANGE_UID, CHANGE_GID environment variables (See README.md)
- Minor fixes

## v1.0.1

- Upgraded parent image to PHP 7.1.7
- Fixed some directory owners/permissions
- Minor fixes

## v1.0.0

- Initial release
