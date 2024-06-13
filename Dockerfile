FROM debian:11
LABEL maintainer="Alex Koseki <alex.koseki@gmail.com>"

# Get main sources and apache
RUN apt-get update \
	&& apt-get install -y \
	build-essential \
	vim \
	wget \
	apache2 \
	apache2-bin \
	apache2-data \
	apache2-dev \
	apache2-ssl-dev \
	apache2-utils \
	graphicsmagick \
	spawn-fcgi \
	libapache2-mod-fcgid

# Get sources for building php4 and openssl
RUN apt-get install -q -y --no-install-recommends \
	autoconf2.13 \
	autoconf2.64 \
	autoconf \
	bash \
	bison \
	build-essential \
	ca-certificates \
	curl \
	findutils \
	git \
	libbz2-dev \
	libicu-dev \
	libjpeg-dev \
	libmcrypt-dev \
	libonig-dev \
	libpng-dev \
	libreadline-dev \
	libsqlite3-dev \
	libssl-dev \
	libtidy-dev \
	libxml2-dev \
	libxslt1-dev \
	libzip-dev \
	pkg-config \
	re2c \
	zlib1g-dev \
    flex \
    libfreetype6-dev \
    libc-client-dev \
    libkrb5-dev \
    libmhash-dev \
#    libmysqlclient-dev \
	libmariadb-dev-compat \
	libreadline6-dev \
	librecode0 \
	libsnmp-dev \
	libsqlite3-0 \
	libsqlite3-dev \
	re2c \
	uuid-dev \
	libxml2 \
    libpq-dev \
	libexpat-dev \
	libsodium23 \
	psmisc \
	libltdl-dev \
	imagemagick \
	libbsd-dev \
	libgmp-dev \
	libcurl4-openssl-dev \
	pkg-config \
	libldap-dev \
	libldb-dev \
#	libldap2-dev \
	libpspell-dev \
	libpcre3 \
	libpcre3-dev

# Openssl 3.2, Download source
RUN mkdir /tmp/openssl/
WORKDIR /tmp/openssl/
RUN wget http://www.openssl.org/source/openssl-3.2.0.tar.gz \
	&& tar xvfz openssl-3.2.0.tar.gz

# OpenSSL 3.2 configure and build
WORKDIR /tmp/openssl/openssl-3.2.0
RUN ./config -shared -fPIE -fPIC --prefix=/usr/local/openssl-3.2.0 \
	&& make \
	&& make install

# PHP4, Library linking
RUN ln -s /usr/local/openssl-3.2.0/lib64 /usr/local/openssl-3.2.0/lib \
	&& ln -s /usr/include/x86_64-linux-gnu/curl/ /usr/local/include/curl \
	&& ln -s /usr/lib/x86_64-linux-gnu/libjpeg.so /usr/lib/libjpeg.so \
	&& ln -s /usr/lib/x86_64-linux-gnu/libpng.so /usr/lib/libpng.so \
	&& ln -s /usr/lib/x86_64-linux-gnu/libmysqlclient.so /usr/lib/libmysqlclient.so \
	&& ln -s /usr/lib/x86_64-linux-gnu/libexpat.so /usr/lib/libexpat.so \
	&& ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h \
	&& ln -s /usr/lib/x86_64-linux-gnu/libldap.so /usr/lib/libldap.so \
	&& ln -s /usr/lib/x86_64-linux-gnu/liblber.so /usr/lib/liblber.so \
	&& ln -s /usr/local/openssl-3.2.0/lib/libssl.so.3 /usr/lib/libssl.so.3 \
	&& ln -s /usr/local/openssl-3.2.0/lib/libcrypto.so.3 /usr/lib/libcrypto.so.3

# PHP 4, Download source
RUN mkdir /tmp/php4/
WORKDIR /tmp/php4/
RUN wget https://raw.githubusercontent.com/akoseki/php4-5/master/php-fpm-4.4.9_suhosin_openssl-3.x.tar.xz \
	&& tar xf php-fpm-4.4.9_suhosin_openssl-3.x.tar.xz

# PHP 4, Configure
WORKDIR /tmp/php4/php4-fpm_production
RUN	./configure \
	--prefix=/opt/phpfcgi-4.4.9 \
#	--with-apxs2=/usr/bin/apxs \
	--enable-fpm \
	--enable-opcache \
	--enable-intl \
	--enable-pcntl \
	--with-snmp \
	--enable-exif \
	--with-suhosin \
	--enable-gd-native-ttf \
	--with-freetype-dir=/usr \
	--enable-sysvmsg \
	--enable-sysvsem \
	--enable-sysvshm \
	--enable-shmop \
	--with-pdo-pgsql \
	--enable-pdo \
	--with-xsl \
	--with-pdo-sqlite \
	--with-pdo-mysql=mysqlnd \
	--with-zlib-dir \
	--with-readline \
	--with-libedit \
	--with-gmp \
	--with-pspell \
	--with-tidy \
	--with-enchant \
	--with-freetype-dir \
	--enable-mbstring \
	--with-libxml-dir=/usr \
	--with-readline \
	--enable-soap \
	--enable-calendar \
	--with-curl \
	--with-mcrypt \
	--with-zlib \
	--with-gd \
	--with-xmlrpc \
	--enable-bcmath \
	--with-pgsql \
	--disable-rpath \
	--enable-inline-optimization \
	--with-bz2 \
	--enable-sockets \
	--enable-sysvsem \
	--enable-sysvshm \
	--enable-pcntl \
	--enable-mbregex \
	--with-mhash \
	--enable-zip \
	--with-pcre-regex \
	--with-mysql=/usr \
	--with-mysql-sock=/run/mysqld/mysqld.sock \
	--with-jpeg-dir=/usr \
	--with-png-dir=/usr \
	--enable-gd-native-ttf \
	--with-openssl=/usr/local/openssl-3.2.0 \
	--with-openssl-dir=/usr/local/openssl-3.2.0 \
	--enable-ftp \
	--with-kerberos \
	--with-gettext \
	--with-expat-dir=/usr \
	--with-expat-dir=/usr \
	--enable-fastcgi
#	--with-imap \
#	--with-imap-ssl \
#	--with-ldap \
#	--with-ldap-sasl \

# PHP4, Patches to allow compilation
RUN sed -i "s/EXTRA_LDFLAGS_PROGRAM \= -L\/usr\/lib\/x86_64-linux-gnu\/mit-krb5 -L\/usr\/local\/openssl-3.2.0\/lib -L\/usr\/local\/lib -L\/usr\/lib\/x86_64-linux-gnu/EXTRA_LDFLAGS_PROGRAM \= -L\/usr\/lib\/x86_64-linux-gnu\/mit-krb5 -L\/usr\/local\/openssl-3.2.0\/lib -L\/usr\/local\/lib -L\/usr\/lib\/x86_64-linux-gnu -pthread -no-pie -lbsd -lpcre/g" "Makefile" \
	&& sed -i "s/__GMP_BITS_PER_MP_LIMB/GMP_LIMB_BITS/g" "ext/gmp/gmp.c"

# PHP4, Make and install
RUN	make clean \
	&& make \
	&& make install

# APC Module, Dowmnload
WORKDIR /tmp
RUN wget http://pecl.php.net/get/APC-3.0.19.tgz \
	&& tar xvfz APC-3.0.19.tgz

# APC Module, Build and install
WORKDIR /tmp/APC-3.0.19
RUN /opt/phpfcgi-4.4.9/bin/phpize \
	&& ./configure --enable-apc --enable-apc-mmap --with-php-config=/opt/phpfcgi-4.4.9/bin/php-config \
	&& make \
	&& make install

# Apache Environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

# Add PHP4 Handlers to Apache
RUN echo "FcgidInitialEnv PHPRC \"/opt/phpfcgi-4.4.9\"\n" >> /etc/apache2/apache2.conf \
	&& echo "AddHandler fcgid-script .php\n" >> /etc/apache2/apache2.conf \
	&& echo "FcgidWrapper \"/opt/phpfcgi-4.4.9/bin/php-cgi\" .php\n" >> /etc/apache2/apache2.conf \
	&& echo "<Directory \"/var/www\">\n    Options FollowSymLinks Includes ExecCGI\n    AllowOverride All\n    Order allow,deny\n    Allow from all\n</Directory>" | cat - /etc/apache2/sites-enabled/000-default.conf > temp && mv temp /etc/apache2/sites-enabled/000-default.conf

# Expose Apache to port and run
EXPOSE 80
CMD /usr/sbin/apache2ctl -D FOREGROUND