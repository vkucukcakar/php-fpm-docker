# Changelog

## v1.6.0

- Fixed ImageMagick
- Added support for GMP extension in Dockerfile-extras
- Removed pdo, mbstring, iconv extensions from builds as they are already included in PHP 7.4
- Slightly improved builds

## v1.5.0

- Removed SERVER_INTERNAL_HOSTNAME and SERVER_INTERNAL_IP (Please use network aliases for your server container)

## v1.4.1

- Fixed main Dockerfile not installing the add hosts script (related to SERVER_INTERNAL_HOSTNAME) correctly

## v1.4.0

- Fixed a configuration directive in template that cause php file changes take effect late (Existing configurations must be re-created or manually fixed by changing php_admin_value[opcache.revalidate_freq] = 2 )
- Fixed php_admin_value[opcache.validate_timestamps], php_admin_value[opcache.revalidate_freq] in configuration template php-fpm-www.conf
- Changed some opcache defaults related with performance and memory consumption in configuration template php-fpm-www.conf

## v1.3.0

- Added support for exif and zip extensions in Dockerfile-extras
- Fixed possible PHP container to web server http connection (remote fopen etc.) problems especially on development environments
- Added support for SERVER_INTERNAL_HOSTNAME and SERVER_INTERNAL_IP variables

## v1.2.0

- Dockerfile-alpine and Dockerfile-alpine-extras files renamed as Dockerfile and Dockerfile-extras respectively
- alpine and alpine-extras tags will not be used on Docker Hub, the images are only Alpine based

## v1.1.0
- Upgraded parent images to official PHP 7.4 current stable image
- Moved Debian related files to "legacy" folder for documentary purposes

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
