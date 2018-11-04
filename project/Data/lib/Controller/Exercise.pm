package Controller::Exercise;
use Moo;
with('Role::Authenticate');
use MooX::late;
use MooX::Override -class;
use Digest::SHA qw(sha256_hex);
use Mojo::JSON 'encode_json';

use Model::Exercise;

has 'exercise' => (
  is => 'rw',
  isa => 'Maybe[Model::Exercise]',
  lazy_build => 1
);

extends 'Controller';

__PACKAGE__->meta->make_immutable;

sub _build_exercise {
  my $self = shift;
  $self->exercise(Model::Exercise->new());
}

sub _validation {
  my $self = shift;
  my $params = shift;
  my $warning = '';
  my $p = {};
  
  foreach ('description', 'name_function', 'input_parameter', 'output_parameter') {
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

  my $id = $self->exercise->add($params);
  $self->render({data => {id => $id}});
};

override 'put' => sub {
  my $self = shift;

  my $id = $self->captures->{id};
  if ($id) {
    my ($warn, $params) = $self->_validation($self->body);
    return $self->render({data => {warning => $warn}, code => 400}) if $warn;

    my $data = $self->exercise->save($id, $params);
    $self->exercise->reWriteCach(sha256_hex('exercise' . $id), encode_json $data);
    $self->show($id);
  } else {
     return $self->render({data => {warning => "Parameter 'id' is required"}, code => 400});
  }
};

override 'delete' => sub {
  my $self = shift;

  my $id = $self->captures->{id};
  if ($id) {
    my $shaKey = sha256_hex('exercise' . $id);
    $self->exercise->removeCach($shaKey);
    $self->exercise->remove($id);
    $self->render({data => {$id => 'deleted'}});
  } else {
    return $self->render({data => {error => "Parameter 'id' is required"}, code => 401});
  }
};

sub showAll {
  my $self = shift;
  $self->render({data => $self->exercise->all});
}

sub show {
  my ($self, $id) = @_;
  my $shaKey = sha256_hex('exercise' . $id);
  my $data = $self->exercise->getCach($shaKey);
  if (!$data) {
      $data = $self->exercise->find($id);
      $self->exercise->storeCach($shaKey, encode_json $data) if $data;
  }
  $self->render({data => $data});
}

1;