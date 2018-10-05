package Controller;

use Moo;
use MooX::late;
use TryCatch;
use Mojo::JSON 'encode_json';

has 'cgi' => (
  is => 'rw'
);

has 'type' => (
  is => 'rw',
  isa => 'Str'
);

__PACKAGE__->meta->make_immutable;

no Moo;

sub processRequest {
	
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