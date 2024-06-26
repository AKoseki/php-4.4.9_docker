﻿# php-4.4.9_docker

This is a Docker Image with PHP 4.4.9, running with Debian 11 and compiled with OpenSSL 3.2.

This was made in a project to support people and companies that still has legacy code that runs only on php 4.

There are a lot of broken resources on PHP4 online, most are outdated and don't work well.
I've spent some time trying to make this project run properly on a more recent system.

This Docker Image will run out of the box as is without any modification needed.

<br/>
<br/>

To run it, just run
> docker-compose up --build

I also like to run these before, if I make any modifications to the image.
> docker-compose stop
> docker-compose rm -f

<br/>
<br/>

Key features:
- PHP 4.4.9 CGI
- OpenSSL 3.2.0
- Apache 2.4
- Docker
- Debian 11

<br/>
<br/>

![PHP](https://github.com/AKoseki/Projects/blob/main/host/php4-docker/img/main.png?raw=true)
![PHP](https://github.com/AKoseki/Projects/blob/main/host/php4-docker/img/curl-openssl.png?raw=true)

<br/>
Huge thanks to Robert McDowell who made PHP4 to work with a more recent openssl and security patches.
