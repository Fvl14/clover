#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib";
use CGI;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);

my $controllers = {
	exercise => 'Controller::Exercise'
};

if ($controllers->{$ENV{CONTROLLER}}) {
	eval "require $controllers->{$ENV{CONTROLLER}}";
	die "Couldn't load controller $controllers->{$ENV{CONTROLLER}} : $@" if $@;
} else {
	die "Bad Request";
}

my $controller = $controllers->{$ENV{CONTROLLER}}->new(cgi => CGI->new(), type => $ENV{REQUEST_METHOD});
$controller->processRequst();