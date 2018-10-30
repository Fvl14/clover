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

ManagerController->new()->getController($ENV{REQUEST_METHOD}, $ENV{REQUEST_URI})->processRequest();