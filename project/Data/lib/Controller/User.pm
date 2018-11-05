package Controller::User;

use Moo;
with('Role::Authenticate');
use MooX::late;
use MooX::Override -class;
use Digest::SHA qw(sha256_hex);
use Mojo::JSON 'encode_json';

use Model::User;

extends 'Controller';

__PACKAGE__->meta->make_immutable;

sub _validation {
  my $self = shift;
  my $params = shift;
  my $warning = '';
  my $p = {};
  
  foreach ('password', 'email', 'role') {
    if (!$params->{$_}) {
      $warning .= "Parameter $_ is required";
    } else {
      $p->{$_} = $params->{$_};
    }
  }

  return ($warning, $p);
}

override 'get' => sub {
  my $self = shift;

  my $id = $self->captures->{id};
  if ($id) {
    $self->show($id);
  } else {
    $self->showAll();
  }

};

override 'post' => sub {
  my $self = shift;

  my ($warn, $params) = $self->_validation($self->body);
  return $self->render({data => {warning => $warn}, code => 400}) if $warn;

  my $id = $self->user->add($params);
  $self->render({data => {id => $id}});
};

override 'put' => sub {
  my $self = shift;

  my $id = $self->captures->{id};
  if ($id) {
    my ($warn, $params) = $self->_validation($self->body);
    return $self->render({data => {warning => $warn}, code => 400}) if $warn;

    my $data = $self->user->save($id, $params);
    $self->user->reWriteCach(sha256_hex('user' . $id), encode_json $data);
    $self->show($id);
  } else {
     return $self->render({data => {warning => "Parameter 'id' is required"}, code => 400});
  }
};

override 'delete' => sub {
  my $self = shift;

  my $id = $self->captures->{id};
  if ($id) {
    my $shaKey = sha256_hex('user' . $id);
    $self->user->removeCach($shaKey);
    $self->user->remove($id);
    $self->render({data => {$id => 'deleted'}});
  } else {
    return $self->render({data => {error => "Parameter 'id' is required"}, code => 401});
  }
};

sub showAll {
  my $self = shift;
  $self->render({data => $self->user->all});
}

sub show {
  my ($self, $id) = @_;
  my $shaKey = sha256_hex('user' . $id);
  my $data = $self->user->getCach($shaKey);
  if (!$data) {
      $data = $self->user->find($id);
      $self->user->storeCach($shaKey, encode_json $data) if $data;
  }
  $self->render({data => $data});
}

1;