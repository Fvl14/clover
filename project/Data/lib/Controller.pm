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
	$self->render({data => {error => 'Body is empty'}, code => 400}) if !$self->params->{$self->type . 'DATA'};
	$self->body(decode_json $self->params->{$self->type . 'DATA'});
}

no Moo;

sub processRequest {
	my $self = shift;
	my $method = lc $self->type();
	$self->$method();
}

sub get { shift->render({data => {error => 'The GET method has not been defined'}, code => 405}) }

sub post { shift->render({data => {error => 'The POST method has not been defined'}, code => 405}) }

sub put { shift->render({data => {error => 'The PUT method has not been defined'}, code => 405}) }

sub patch { shift->render({data => {error => 'The PATCH method has not been defined'}, code => 405}) }

sub delete { shift->render({data => {error => 'The DELETE method has not been defined'}, code => 405}) }

sub head { shift->render({data => {error => 'The HEAD method has not been defined'}, code => 405}) }

sub conn { shift->render({data => {error => 'The CONN method has not been defined'}, code => 405}) }

sub options { shift->render({data => {error => 'The OPTIONS method has not been defined'}, code => 405}) }

sub any { shift->render({data => {error => 'The ANY method has not been defined'}, code => 405}) }

sub _validation {shift->render({code => 502})}

sub render {
	my $self = shift;
	my $data = shift;
	my %data = ((code => 200, data => undef), defined $data && ref $data eq 'HASH' ? %$data : ());
	print $self->cgi->header(
		-type =>'application/json',
		-charset => 'utf-8',
		-status => $data{code});
	print encode_json $data{data};
	exit;
}

1;
