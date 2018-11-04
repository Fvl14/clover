package ManagerController;

use Moo;
use MooX::late;
use TryCatch;
use ConfigData qw($router);
use CGI;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use Router::R3;

sub getController {
	my ($self, $type, $requestUri) = @_;
  $requestUri =~ m/^([^?]+)\??/;
	my ($controller, $captures) = Router::R3->new($router)->match($1);
	die "Can't find controller" if !$controller;
	eval "require $controller";
	die "Couldn't load controller $controller : $@" if $@;
	return $controller->new(cgi => CGI->new(), type => $type, requestUri => $1, captures => $captures);
}

1;