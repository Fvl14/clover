package Controller;

use Moo;
use MooX::late;
use TryCatch;
use Mojo::JSON qw (encode_json decode_json);
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
  isa => 'Str'
);

has 'captures' => (
  is => 'rw',
  isa => 'HashRef'
);

has 'params' => (
  is => 'rw',
  isa => 'HashRef'
);

has 'body' => (
  is => 'rw',
  isa => 'HashRef',
  lazy_build => 1
);

__PACKAGE__->meta->make_immutable;

sub BUILD {
	my $self = shift;
	$self->cgi->charset('utf-8');
	my $params = $self->cgi->Vars;
	$self->params($params);
}

sub _build_body {
	my $self = shift;
	$self->body(decode_json $self->params->{POSTDATA});
}

no Moo;

sub processRequest {
	my $self = shift;
	#my $method = $self->dispatcher();
	my $method = lc $self->type();
	$self->$method();
}

# sub dispatcher {
# 	my $self = shift;
# 	return $self->getMethod($self->getFromMapping());
# }

# sub getMethod {
# 	my $self = shift;
# 	my $mapping = shift;
# 	return Router::R3->new($mapping)->match($self->requestUri);
# }

# sub getFromMapping {
# 	my $self = shift;
# 	my $mapping = $self->mapping();
# 	return $mapping->{$self->type} ? $mapping->{$self->type} : {}; 
# }

# sub mapping {
# 	return {}
# }

sub get { die 'The GET method has not been defined' }

sub post { die 'The POST method has not been defined' }

sub put { die 'The PUT method has not been defined' }

sub patch { die 'The PATCH method has not been defined' }

sub delete { die 'The DELETE method has not been defined' }

sub head { die 'The HEAD method has not been defined' }

sub conn { die 'The CONN method has not been defined' }

sub options { die 'The OPTIONS method has not been defined' }

sub any { die 'The ANY method has not been defined' }

sub render {
	my $self = shift;
	my $data = shift;
	print $self->cgi->header('application/json');
	print encode_json $data;
}

1;