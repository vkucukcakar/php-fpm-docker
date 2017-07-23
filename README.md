# vkucukcakar/php

PHP-FPM Docker image with automatic configuration file creation and export

* Based on official PHP-FPM Docker image
* Automatic configuration creates well-commented configuration files using environment variables or use configuration files at volume "/configurations"
* Installed and enabled some common extensions (gd iconv mcrypt mbstring mysqli pdo pdo_mysql opcache)
* Included ssmtp for mail relay

## Supported tags

* alpine, latest
* debian

## Environment variables supported

* AUTO_CONFIGURE=[enable|disable]
	Enable automatic configuration file creation
* CONTAINER_NAME=[example-com-php]
	Current container name
* DOMAIN_NAME=[example.com]
	Current domain name
* SSMTP_MAILHUB=[server-mta]
	Smtp container hostname
	
## Caveats

* Automatic configuration, creates some configuration files using the supported environment variables 
  unless they already exist at /configurations directory. These are well-commented basic configuration files
  that you can edit according to your needs and make them persistent by mounting /configurations directory 
  to a location on host. If you need to re-create them using the environment variables, then you need to 
  delete the old ones. This is all by design.
