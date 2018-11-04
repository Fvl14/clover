#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib";
use ManagerController;

if (!$ENV{REQUEST_METHOD}) {
	$ENV{REQUEST_METHOD} = shift;
	$ENV{REQUEST_URI} = shift;
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

#showENV();

ManagerController->new()->getController($ENV{REQUEST_METHOD}, $ENV{REQUEST_URI})->processRequest();