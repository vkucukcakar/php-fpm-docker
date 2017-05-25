# vkucukcakar/php

PHP-FPM Docker image with automatic configuration file creation and export

* Based on official PHP-FPM Docker image
* Auto create or use configuration files at volume "/configurations" using environment variables

## Supported tags

* alpine, latest
* debian

## Environment variables supported

* AUTO_CONFIGURE=[enable|disable]

* CONTAINER_NAME=[your-container-name]

* DOMAIN_NAME=[example.com]

* SSMTP_MAILHUB=[smtp-container-hostname]