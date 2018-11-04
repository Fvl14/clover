package Aerospike::Client;

use Moo;
use MooX::late;
use TryCatch;
use Data::Dumper;
use Aerospike::Client::CitrusLeaf;

has client => (
  is  => 'rw',
  isa => 'Aerospike::Client::CitrusLeaf'
);


no Moo;

sub getCach {
	my ($self, $key, $set) = @_;
	my $res;
	try {
		$res = $self->client->read("$key") if $self->connect($set);
	} catch ($e) {
		print STDERR Dumper $e;
		return undef;
	}
	return $res;
}

sub storeCach {
	my ($self, $key, $data, $set) = @_;
	try {
		$self->client->write(
            "$key",
            [
                { name => 'bin', data => $data, type => citrusleaf::CL_STR }
            ]
        ) if $self->connect($set);
        return 1;
	} catch ($e) {
		print STDERR Dumper $e;
		return undef;
	}
}

sub reWriteCach {
	my ($self, $key, $data, $set) = @_;
	my $write_params = undef;
	try {
		$self->client->operate(
            "$key",
            [
                { name => 'bin', data => $data, type => citrusleaf::CL_STR, op => citrusleaf::CL_OP_WRITE }
            ],
            $write_params
        ) if $self->connect($set);
        return 1;
	} catch ($e) {
		print STDERR Dumper $e;
		return undef;
	}
}

sub removeCach {
	my ($self, $key, $set) = @_;
	try {
		$self->client->delete($key) if $self->connect($set);
		return 1;
	} catch ($e) {
		print STDERR Dumper $e;
		return undef;
	}
}

sub connect {
	my ($self, $set) = @_;
	if ($self->client) {
		if ($set) {
			$self->client->set_set($set);
			$self->client->set_connected(0);
			$self->client->connect()
		} else {
			$self->client->connect()
		}
	}
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