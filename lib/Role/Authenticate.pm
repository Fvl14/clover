package Role::Authenticate;

use Moo::Role;
use MooX::late;
use Mojo::JSON 'encode_json';

use Model::User;

has 'user' => (
  is => 'rw',
  isa => 'Maybe[Model::User]',
  lazy_build => 1
);

has 'tokens' => (
  is => 'rw',
  lazy_build => 1
);

has 'token' => (
  is => 'rw',
  lazy_build => 1
);

__PACKAGE__->meta->make_immutable;

sub BUILD {
	my $self = shift;
	$self->authenticate();
}

sub _build_user {
  my $self = shift;
  $self->user(Model::User->new());
}

sub _build_tokens {
  my $self = shift;
  $self->tokens($self->user->getCach('tokens', 'tokens'));
}

sub _build_token {
  my $self = shift;
  $ENV{HTTP_AUTHORIZATION} =~ m/Bearer (.+)$/;
  $self->token($1);
}

sub authenticate {
	my $self = shift;

	my $token = $self->token;
	die 'Can\'t get token' if !$token;

	my $tokenCached = $self->checkTokenInCach($token);
	die 'Wrong token' if !$tokenCached;

	my $date = time;
	if ($date - $tokenCached->{date} > 360) {
		$self->removeOldToken($token);
		die 'New token is needed.';
	}
}

sub checkTokenInCach {
	my ($self, $token) = @_;
	my $tokens = $self->tokens;
	return undef if !$tokens;
	my $t = undef;
	foreach my $tokenInfo (@{$tokens}) {
		if ($token eq $tokenInfo->{token}) {
			$t = $tokenInfo;
			last;
		}
	}

	return $t;
}

sub removeOldToken {
	my ($self, $token) = @_;
	my $tokens = $self->tokens;
	if ($tokens) {
		my @tokensNew = grep {$_->{token} ne $token} @{$tokens};
		$self->user->reWriteCach('tokens', encode_json \@tokensNew, 'tokens')
	}
}

1;