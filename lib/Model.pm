package Model;

use Moo;
use MooX::late;
use TryCatch;
use Mojo::Pg;
use ConfigData qw ($configData);

has 'aerospike' => (
  is => 'rw',
  lazy_build => 1
);

has 'pg' => (
  is => 'rw',
  lazy_build => 1
);

has 'as_set' => (
  is => 'rw',
  isa => 'Str',
  #default => $configData->{config_as_set}
);

__PACKAGE__->meta->make_immutable;

no Moo;

BEGIN {
	unshift @INC, '/home/vasyl/Downloads/citrusleaf_client_swig_2.1.34/swig/perl';
	require Aerospike::Client;
}

sub _build_aerospike {
	my $self = shift;
	$self->aerospike(Aerospike::Client->new(client => Aerospike::Client::CitrusLeaf->new(
						host         => $configData->{config_as_host},
	            		ns           => $configData->{config_as_namespace},
	            		set          => $self->as_set,
	            		conn_timeout => $configData->{config_as_conn_timeout})));
}

sub _build_pg {
	my $self = shift;
	$self->pg(Mojo::Pg->new('postgresql://postgres@/clover'));
}

sub getCach {
	my ($self, $key, $set) = @_;
	return $self->aerospike->getCach($key, $set);
}

sub storeCach {
	my ($self, $key, $data, $set) = @_;
	return $self->aerospike->storeCach($key, $data, $set);
}

sub reWriteCach {
	my ($self, $key, $data, $set) = @_;
	return $self->aerospike->reWriteCach($key, $data, $set);
}

sub removeCach {
	my ($self, $key, $set) = @_;
	return $self->aerospike->removeCach($key, $set);
}

1;