FROM debian

RUN apt-get update && apt-get install -y \
	gettext libz-dev \
	libssl-dev \
	postgresql \
	make \
	gcc \
	libc6-dev \
	swig \
	wget \
	python \
	libgnome2-perl \
	nginx \
	spawn-fcgi \
	fcgiwrap \
	cpanminus \
	postgresql-server-dev-9.6 \
	libpcre3-dev

RUN mkdir clover \
	&& cd clover \
	&& mkdir /usr/share/nginx/html/perl

ADD ./config/nginx/default /etc/nginx/sites-available/default
ADD ./config/nginx/server.crt /etc/ssl/private/server.crt
ADD ./config/nginx/server.key /etc/ssl/private/server.key
ADD ./config/postgresql/clover.sql /clover/clover.sql
ADD ./config/aerospike/ /clover/
ADD ./project/Data/service.pl /usr/share/nginx/html/perl/service.pl
ADD ./project/Data/lib /usr/share/nginx/html/perl/lib

RUN chown  postgres:postgres /clover/clover.sql
RUN sed -i 's/local   all             all                                     peer/local   all             all                                     md5/' /etc/postgresql/9.6/main/pg_hba.conf

ARG PG_USER=userclover
ARG PG_PASS=12345

RUN sed -i 's/fastcgi_param PG_USER      fastcgi_param PG_PASS/fastcgi_param PG_USER '$PG_USER';     fastcgi_param PG_PASS '$PG_PASS';/' /etc/nginx/sites-available/default

USER postgres

RUN service postgresql start \
	&& createuser $PG_USER \
	&& psql -c "alter user $PG_USER with password '$PG_PASS';" \
	&& createdb clover \
	&& psql --username=postgres clover < /clover/clover.sql \
	&& psql -d clover -c "grant SELECT, UPDATE, INSERT, DELETE on all tables in schema public to $PG_USER;"

USER root

RUN chmod a+x /usr/share/nginx/html/perl/service.pl \
	&& chmod 0777 /usr/share/nginx/html/perl/service.pl \
	&& chown  www-data:www-data /usr/share/nginx/html/perl \
	&& chown  www-data:www-data /usr/share/nginx/html/perl/service.pl \
	&& cd clover \
	&& wget -O aerospike.tgz 'https://www.aerospike.com/download/server/latest/artifact/debian9' \
	&& tar -xvf aerospike.tgz \
	&& cd aerospike-server-community-4.3.1.5-debian9/ \
	&& ./asinstall \
	&& cd /clover \
	&& wget -O citrusleaf_client_swig_2.1.34.tgz 'https://www.aerospike.com/download/client/perl/2.1.34/artifact/tgz' \
	&& tar zxf citrusleaf_client_swig_2.1.34.tgz \
	&& cd citrusleaf_client_swig_2.1.34 \
	&& make \
	&& cd swig \
	&& cp /clover/citrusleaf/Makefile /clover/citrusleaf_client_swig_2.1.34/swig/Makefile \
	&& cp /clover/aerospike.conf /etc/aerospike/aerospike.conf \
	&& make LANG=perl \
	&& cd /clover \
	&& cpan install -f CGI DBD::Pg Mojo::Pg TryCatch Moo MooX::late Session::Token Mojo::JSON MooX::Override Router::R3

EXPOSE 80 443

CMD service fcgiwrap start \
	&& service nginx start \
	&& service postgresql start \
	&& /usr/bin/asd --config-file /etc/aerospike/aerospike.conf --foreground

