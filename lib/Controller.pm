package Controller;

use Moo;
use MooX::late;
use TryCatch;
use Mojo::JSON 'encode_json';
use Router::R3;

has 'cgi' => (
  is => 'rw'
);

has 'type' => (
  is => 'rw',
  isa => 'Str'
);

has 'requestUri' => (
  is => 'rw',
  isa => 'Str',
  coerce => sub {
  				my $str = shift;
  				$str =~ m/^([^?]+)\??/;
  				$1;
  			}
);

__PACKAGE__->meta->make_immutable;

no Moo;

sub processRequest {
	my $self = shift;
	my ($method, $captures) = $self->dispatcher();
	my $params = $self->cgi->Vars;
	$self->$method($params, $captures) if $method;
}

sub dispatcher {
	my $self = shift;
	return $self->getMethod($self->getFromMapping());
}

sub getMethod {
	my $self = shift;
	my $mapping = shift;
	return Router::R3->new($mapping)->match($self->requestUri);
}

sub getFromMapping {
	my $self = shift;
	my $mapping = $self->mapping();
	return $mapping->{$self->type} ? $mapping->{$self->type} : {}; 
}

sub mapping {
	return {}
}

sub get {
	
}

sub post {

}

sub put {

}

sub delete {

}

sub render {
	my $self = shift;
	my $data = shift;
	print $self->cgi->header('application/json');
	print encode_json $data;
}

1;