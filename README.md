# vkucukcakar/php-fpm

PHP-FPM Docker image with automatic configuration file creation and export

* Based on official PHP-FPM Docker image
* Automatic configuration creates well-commented configuration files using environment variables or use configuration files at volume "/configurations"
* Installed and enabled some common extensions (gd iconv mbstring mysqli pdo pdo_mysql opcache)
* Installed and enabled some extra extensions in alpine-extras image (bcmath, bz2, imap, soap, sockets, shmop, xmlrpc, apcu, imagick, redis)
* Included ssmtp for mail relay

## Supported tags

* latest (Alpine based)
* latest-extras (Alpine based)
* Some version based tags may be available, please see tags section on Docker Hub

## Environment variables supported

* AUTO_CONFIGURE=[enable|disable]
    Enable automatic configuration file creation
* CONTAINER_NAME=[example-com-php]
	Current container name
* DOMAIN_NAME=[example.com]
	Current domain name
* SSMTP_MAILHUB=[server-mta]
	Smtp container hostname
* SERVER_INTERNAL_HOSTNAME=[server-proxy]
	Web server (or reverse proxy) internal hostname. Specified to fix possible PHP container to web server http connection (remote fopen etc.) problems especially on development environments
* SERVER_INTERNAL_IP=[""]
	Web server (or reverse proxy) internal IP. Do not use if SERVER_INTERNAL_HOSTNAME is used
* CHANGE_OWNER=[enable|disable]
	Change owner of /var/www/html and some special directories (/data/opcache, /sessions, /home/www-data) recursively to "www-data:www-data".
	As the default user is www-data and it is already used in PHP-FPM configuration files, this will solve PHP permission errors for development.
	This also affects the directories and files at host if you mount volumes. Will also be enabled if CHANGE_UID or CHANGE_GID is set.
* CHANGE_UID=[1000]
	Change uid of default user www-data. You can make this match your current uid (id -u) on host to easily access mounted volumes for development.
* CHANGE_GID=[1000]
	Change gid of default group www-data. You can make this match your current gid (id -g) on host for development.

## Caveats

* Automatic configuration, creates configuration files using the supported environment variables 
  unless they already exist at /configurations directory. These are well-commented configuration files
  that you can edit according to your needs and make them persistent by mounting /configurations directory 
  to a location on host. If you need to re-create them using the environment variables, then you must 
  delete the old ones. This is all by design.
  
* Configuration templates for extensions in alpine-extras image are not ready currently. 
  
* There is a working Docker Compose example project which you can see vkucukcakar/php-fpm image in action: [lemp-stack-compose](https://github.com/vkucukcakar/lemp-stack-compose )

## Notice

Support for Debian based image has reached it's end-of-life.
Debian related file(s) were moved to "legacy" folder for documentary purposes.
Sorry, but it's not easy for me to maintain both Alpine and Debian based images.

If you really need the Debian based image, please use previous versions up to v1.0.4.
