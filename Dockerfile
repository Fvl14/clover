FROM debian

RUN apt-get update && apt-get install -y \
	curl \
	libcurl4-gnutls-dev \
	libexpat1-dev \
	gettext libz-dev \
	libssl-dev \
	git \
	sudo \
	postgresql \
	make \
	gcc \
	libc6-dev \
	swig \
	wget \
	python \
	libgnome2-perl \
	systemd \
	nginx \
	nano \
	spawn-fcgi \
	fcgiwrap \
	cpanminus

RUN mkdir clover \
	&& cd clover \
	&& mkdir /var/www/html/perl

ADD ./config/nginx/default /etc/nginx/sites-available/default
ADD ./config/postgresql/clover.sql /clover/clover.sql
ADD ./config/aerospike/ /clover/
ADD ./project/Data/service.pl /var/www/html/perl/service.pl

RUN chown  postgres:postgres /clover/clover.sql

USER postgres

RUN service postgresql start \
	&& createdb clover \
	&& psql --username=postgres clover < /clover/clover.sql

USER root

RUN chmod a+x /var/www/html/perl/service.pl \
	&& chmod 0777 var/www/html/perl/service.pl \
	&& chown  www-data:www-data /var/www/html \
	&& chown  www-data:www-data /var/www/html/perl/service.pl \
	&& cd clover \
	&& wget -O aerospike.tgz 'https://www.aerospike.com/download/server/latest/artifact/debian9' \
	&& tar -xvf aerospike.tgz \
	&& cd aerospike-server-community-4.3.0.7-debian9/ \
	&& ./asinstall \
	&& cd /clover \
	&& wget -O citrusleaf_client_swig_2.1.34.tgz 'https://www.aerospike.com/download/client/perl/2.1.34/artifact/tgz' \
	&& tar zxf citrusleaf_client_swig_2.1.34.tgz \
	&& cd citrusleaf_client_swig_2.1.34 \
	&& make \
	&& cd swig \
	&& cp /clover/citrusleaf/Makefile /clover/citrusleaf_client_swig_2.1.34/swig/Makefile \
	&& make LANG=perl \
	&& cd /clover \
	&& cpan install -f CGI Mojolicious::Lite Mojo::Pg

EXPOSE 80 443

CMD /etc/init.d/fcgiwrap start; nginx -g "daemon off;"; /usr/bin/asd --foreground

