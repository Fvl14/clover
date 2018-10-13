#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib";
use ManagerController;
# use CGI;
# use CGI::Carp qw(warningsToBrowser fatalsToBrowser);

# my $controllers = {
# 	exercise => 'Controller::Exercise'
# };

if (!$ENV{REQUEST_METHOD}) {
	$ENV{REQUEST_METHOD} = shift;
	$ENV{REQUEST_URI} = shift;
	#$ENV{CONTROLLER} = shift;
	
	#$ENV{ID} = shift;
}

# if ($controllers->{$ENV{CONTROLLER}}) {
# 	eval "require $controllers->{$ENV{CONTROLLER}}";
# 	die "Couldn't load controller $controllers->{$ENV{CONTROLLER}} : $@" if $@;
# } else {
# 	die "Bad Request";
# }
ManagerController->new()->getController($ENV{REQUEST_METHOD}, $ENV{REQUEST_URI})->processRequest();

#my $controller = $controllers->{$ENV{CONTROLLER}}->new(cgi => CGI->new(), type => $ENV{REQUEST_METHOD}, requestUri => $ENV{REQUEST_URI});
#$controller->processRequest();