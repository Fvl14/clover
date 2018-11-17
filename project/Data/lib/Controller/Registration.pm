package Controller::Registration;

use Moo;
use MooX::late;
use MooX::Override -class;
use Digest::SHA qw(sha256_hex);
use Mojo::JSON 'encode_json';

use Model::User;

has 'user' => (
  is => 'rw',
  isa => 'Maybe[Model::User]',
  lazy_build => 1
);

extends 'Controller';

__PACKAGE__->meta->make_immutable;

sub _build_user {
  my $self = shift;
  $self->user(Model::User->new());
}

override '_validation' => sub {
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
};

override 'post' => sub {
	my $self = shift;

	my ($warn, $params) = $self->_validation($self->body);
  	return $self->render({data => {error => $warn}, code => 400}) if $warn;

  	my $id = $self->user->add($params);
  	$self->render({data => {id => $id}});
};

1;