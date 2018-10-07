package Aerospike::Client;

use Moo;
use MooX::late;
use TryCatch;
use Data::Dumper;
use Aerospike::Client::CitrusLeaf;

has client => (
  is  => 'rw',
  isa => 'Aerospike::Client::CitrusLeaf',
  # default => Aerospike::Client::CitrusLeaf->new(
		# 			host         => $ENV{config_as_host},
  #           		ns           => $ENV{config_as_namespace},
  #           		set          => $ENV{config_as_set},
  #           		conn_timeout => $ENV{config_as_conn_timeout})
);

# BEGIN {
# 	my $self = shift;
# 	$self->connect();
# }

no Moo;

sub getCash {
	my ($self, $key) = @_;
	my $res;
	try {
		$res = $self->client->read("$key") if $self->connect();
	} catch ($e) {
		print Dumper $e;
		return undef;
	}
	return $res;
}

sub storeCash {
	my ($self, $key, $data) = @_;
	try {
		$self->client->write(
            "$key",
            [
                { name => 'bin', data => $data, type => citrusleaf::CL_STR }
            ]
        ) if $self->connect();
        return 1;
	} catch ($e) {
		print Dumper $e;
		return undef;
	}
}

sub reWriteCash {
	my ($self, $key, $data) = @_;
	my $write_params = undef;
	try {
		$self->client->operate(
            "$key",
            [
                { name => 'bin', data => $data, type => citrusleaf::CL_STR, op => citrusleaf::CL_OP_WRITE }
            ],
            $write_params
        ) if $self->connect();
        return 1;
	} catch ($e) {
		print Dumper $e;
		return undef;
	}
}

sub removeCash {
	my ($self, $key) = @_;
	try {
		$self->delete($key) if $self->connect();
		return 1;
	} catch ($e) {
		print Dumper $e;
		return undef;
	}
}

sub connect {
	my $self = shift;
	$self->client->connect() if $self->client;
}

# sub close {
# 	my $self = shift;
# 	$self->client->close() if $self->client;
# }

# sub DEMOLISH {
#   my ($self, $in_global_destruction) = @_;
#   $self->client->close() if $self->client;
# }

1;