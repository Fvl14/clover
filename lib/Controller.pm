package Controller;

use Moo;
use MooX::late;
use TryCatch;
use Mojo::Pg;
use Mojo::JSON 'encode_json';

has 'cgi' => (
  is => 'rw'
);

has 'type' => (
  is => 'rw',
  isa => 'Str'
);

has 'aerospike' => (
  is => 'rw',
  lazy_build => 1
);

has 'pg' => (
  is => 'rw',
  lazy_build => 1
);

__PACKAGE__->meta->make_immutable;

no Moo;

BEGIN {
	unshift @INC, '/home/vasyl/Downloads/citrusleaf_client_swig_2.1.34/swig/perl';
	require Aerospike::Client;
}

sub processRequst {
	
}

sub _build_aerospike {
	my $self = shift;
	$self->aerospike(Aerospike::Client->new(client => Aerospike::Client::CitrusLeaf->new(
						host         => $ENV{config_as_host},
	            		ns           => $ENV{config_as_namespace},
	            		set          => $ENV{config_as_set},
	            		conn_timeout => $ENV{config_as_conn_timeout})));
}

sub _build_pg {
	my $self = shift;
	$self->pg(Mojo::Pg->new('postgresql://postgres@/clover'));
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