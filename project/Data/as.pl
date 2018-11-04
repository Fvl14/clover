#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib";
use CGI;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use TryCatch;
use Data::Dumper;

BEGIN {
	unshift @INC, '/home/vasyl/Завантаження/citrusleaf_client_swig_2.1.34/swig/perl';
	require Aerospike::Client;
}

my $a = Aerospike::Client->new(client => Aerospike::Client::CitrusLeaf->new(
	    host         => '127.0.0.1',
	    ns           => 'test',
	    set          => 'tokens',
	    conn_timeout => 10
	));
print "aaa=", $a->client->connect(), "\n";
print Data::Dumper->Dump( [ $a->client->read("tokens") ] );
#print "bbb=", $a->client->close(), "\n";
exit