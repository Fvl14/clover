package Aerospike::Client;

use Moo;
use MooX::late;
use TryCatch;
use Config;
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
# 	$self->client(Aerospike::Client::CitrusLeaf->new(
# 					host         => $ENV{config_as_host},
#             		ns           => $ENV{config_as_namespace},
#             		set          => $ENV{config_as_set},
#             		conn_timeout => $ENV{config_as_conn_timeout}));
# }

no Moo;

sub getCash {
	my ($self, $key) = @_;
	my $res;
	try {
		$res = $self->client->read("$key");
	} catch ($e) {
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
        );
        return 1;
	} catch ($e) {
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
        );
        return 1;
	} catch ($e) {
		return undef;
	}
}

sub removeCash {
	my ($self, $key) = @_;
	try {
		$a->delete($key);
		return 1;
	} catch ($e) {
		return undef;
	}
}

1;