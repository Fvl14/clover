package Controller::Authentication;

use Moo;
use MooX::late;
use MooX::Override -class;
use Digest::SHA qw(sha256_hex);
use Mojo::JSON 'encode_json';
use Session::Token;

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

extends 'Controller';

__PACKAGE__->meta->make_immutable;

sub _build_user {
  my $self = shift;
  $self->user(Model::User->new());
}

sub _build_tokens {
  my $self = shift;
  $self->tokens($self->user->getCach('tokens', 'tokens'));
}

sub _validation {
  my $self = shift;
  my $params = shift;
  my $warning = '';
  my $p = {};
  
  foreach ('password', 'email') {
    if (!$params->{$_}) {
      $warning .= "Parameter $_ is required";
    } else {
      $p->{$_} = $params->{$_};
    }
  }

  return ($warning, $p);
}

override 'post' => sub {
  my $self = shift;
  my ($token, $date);

  my ($warn, $params) = $self->_validation($self->body);
  return $self->render({warning => $warn}) if $warn;

  my $password = $self->findPasswordByEmail($params->{email});
  return $self->render({warning => 'wrong email'}) if !$password;

  if ($params->{password} eq $password) {
  	$token = Session::Token->new(entropy => 256)->get;
  	$date = time;
  	$self->storeIntoCach({token => $token, email => $params->{email}, date => $date});
  } else {
  	die 'wrong password';
  }

  return $self->render({token => $token, date => $date});
};

sub findPasswordByEmail {
	my $self = shift;
	my $email = shift;
	my $shaKey = sha256_hex('user' . $email);
	my $data = $self->user->getCach($shaKey);
	if (!$data) {
		$data = $self->user->findByEmail($email, 'password');
	}
	return $data->{password};
}

sub storeIntoCach {
	my ($self, $data) = @_;
	my $t = $self->tokens;
	my $tokens = $t;
	if ($tokens) {
		my $isPresent = 0;
		$tokens = [map {if ($_->{email} eq $data->{email}) {
							$isPresent++;
							$data
						} else {
						 	$_
						} } @$tokens];
		push @{$tokens}, $data if !$isPresent; 
	} else {
		$tokens = [$data];
	}
	$t ? $self->user->reWriteCach('tokens', encode_json $tokens, 'tokens') : $self->user->storeCach('tokens', encode_json $tokens, 'tokens');
}

1;