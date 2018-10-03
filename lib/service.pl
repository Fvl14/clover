#!/usr/bin/perl
package Main;
use strict;
use warnings;
use Mojo::Pg;
use Mojo::JSON 'encode_json';
use Data::Dumper;
use FindBin;
use lib "$FindBin::Bin/lib";
use Model::Exercise;
use Config;
use CGI;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use Digest::SHA qw(sha256_hex);

BEGIN {
	unshift @INC, '/home/vasyl/Завантаження/citrusleaf_client_swig_2.1.34/swig/perl';
	require Aerospike::Client;
}

my $aerospike = Aerospike::Client->new(client => Aerospike::Client::CitrusLeaf->new(
					host         => $ENV{config_as_host},
            		ns           => $ENV{config_as_namespace},
            		set          => $ENV{config_as_set},
            		conn_timeout => $ENV{config_as_conn_timeout}));
my $pg = Mojo::Pg->new('postgresql://postgres@/clover');
my $exercise = Model::Exercise->new(pg => $pg);
my $cgi = CGI->new();

if ($ENV{REQUEST_METHOD} eq 'GET') {
	if ($ENV{ID}) {
		my $shaKey = sha256_hex('exercise' . ".$ENV{ID}");
		my $data = $aerospike->getCash($shaKey);
		if ($data) {
			printData($data);
		} else {
			$data = $exercise->find($ENV{ID});
			$aerospike->storeCash($shaKey, encode_json $data);
			printData($data);
		}
	} else {
		my $data = $exercise->all;
		printData($data);
	}
}

if ($ENV{REQUEST_METHOD} eq 'POST') {
	validateData();
	if ($ENV{ID}) {	
		my %data = $cgi->Vars;
		my $shaKey = sha256_hex('exercise' . ".$ENV{ID}");
		if ($aerospike->getCash($shaKey)) {
			$exercise->save($ENV{ID},\%data);
			$aerospike->reWriteCash($shaKey, encode_json \%data);
		} else {
			printData($exercise->add(\%data));
		}
	}	
}

if ($ENV{REQUEST_METHOD} eq 'DELETE') {
	if ($ENV{ID}) {
		my $shaKey = sha256_hex('exercise' . ".$ENV{ID}");
		$exercise->remove($ENV{ID});
		$aerospike->removeCash($shaKey);
	}
}

sub validateData {
	foreach ('description', 'name_function', 'input_parameter', 'output_parameter') {
		if (!defined $cgi->param($_)) {
			die "Parameter $_ is required";
		}
	}
}


sub printData {
	my $data = shift;
	print $cgi->header('application/json');
	print encode_json $data;
}


sub showENV {
		print "Content-type:text/html\n\n";
	print <<EndOfHTML;
	<html><head><title>CLOVER</title></head>
	<body>
EndOfHTML
	my $cgi = CGI->new();
	print Dumper $cgi->param('id');
	foreach my $key (sort(keys %ENV)) {
	    print "$key = $ENV{$key}<br>\n";
	}
}


#Main::main();
#Main::showENV();


