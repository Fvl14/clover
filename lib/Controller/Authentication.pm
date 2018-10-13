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

__PACKAGE__->meta->make_immutable;

sub _build_user {
  my $self = shift;
  $self->exercise(Model::User->new());
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

  my ($warn, $params) = $self->_validation($self->body);
  return $self->render({warning => $warn}) if $warn;

  my $shaKey = sha256_hex('token' . $params->{email});
  my $token = $self->user->getCash($shaKey);
  return $self->render($token) if $token;

  my $password = $self->user->findPasswordByEmail($params->{email});
  return $self->render({warning => 'wrong email'}) if !$password;

  if (sha256_hex($params->{password}) eq $password) {
  	$token = Session::Token->new(entropy => 256)->get;
  	$self->user->storeCash($shaKey, {token => $token});
  } else {
  	die 'wrong password';
  }

  return $self->render({token => $token});
};

sub findPasswordByEmail {
	my $self = shift;
	my $email = shift;
	my $shaKey = sha256_hex('user' . $email);
	my $data = $self->user->getCash($shaKey);
	if (!data) {
		$data = $self->user->findByEmail($email, 'password');
	}
	return $data->{password};
}

1;