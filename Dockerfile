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
	&& git clone https://github.com/Fvl14/clover.git \
	&& cp /clover/clover/default /etc/nginx/sites-available/default \
	&& cp /clover/clover/service.pl /usr/share/nginx/html/ \
	&& chmod a+x /usr/share/nginx/html/service.pl \
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
	&& cp /clover/clover/citrusleaf/Makefile /clover/citrusleaf_client_swig_2.1.34/swig/Makefile \
	&& make LANG=perl \
	&& cd /clover \
	&& cpan install -f CGI Mojolicious::Lite Mojo::Pg

USER postgres

RUN service postgresql start \
	&& createdb clover \
	&& psql --username=postgres clover < /clover/clover/clover.sql

EXPOSE 80 443

CMD ["/etc/init.d/fcgiwrap start && nginx && service postgresql start && /usr/bin/asd --foreground"]

