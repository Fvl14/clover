package Controller::Logout;

use Moo;
with('Role::Authenticate');
use MooX::late;
use MooX::Override -class;

extends 'Controller';

__PACKAGE__->meta->make_immutable;


override 'post' => sub {
  my $self = shift;

  $self->removeOldToken($self->token);

  return $self->render({data => {info => 'User logged out'}});
};

1;