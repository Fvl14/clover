package Controller::Exercise;
use Moo;
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

override 'mapping' => sub {
  return {
    'GET' => {
              '/aaa/exercise' => 'showAll',
              '/aaa/exercise/{id:\d+}' => 'show'
            },
    'POST' => {
              '/aaa/exercise' => 'store'
    },
    'PUT' => {
              '/aaa/exercise/{id:\d+}' => 'update'
    },
    'DELETE' => {
              '/aaa/exercise/{id:\d+}' => 'remove'
    }
  }
};

sub _build_exercise {
  my $self = shift;
  $self->exercise(Model::Exercise->new());
}

sub _validation {
  my $self = shift;
  my $params = shift;
  my $warning = '';

  foreach ('description', 'name_function', 'input_parameter', 'output_parameter') {
    if (!$params->param($_)) {
      $warning .= "Parameter $_ is required";
    }
  }

  return $warning;
}

sub showAll {
  my $self = shift;
  $self->render($self->exercise->all);
}

sub show {
  my ($self, $params, $captures) = @_;
  my $shaKey = sha256_hex('exercise' . ".$captures->{id}");
  my $data = $self->exercise->getCash($shaKey);
  if ($data) {
      $self->render($data);
  } else {
      $data = $self->exercise->find($captures->{id});
      $self->exercise->storeCash($shaKey, encode_json $data) if $data;
      $self->render($data);
  }
}

sub store {
  my ($self, $params, $captures) = @_;

  my $warn = $self->_validation($params);
  return $self->render({warning => $warn}) if $warn;

  my $id = $self->exercise->add($params);
  $self->show($params, $captures);
}

sub update {
  my ($self, $params, $captures) = @_;

  my $warn = $self->_validation($params);
  return $self->render({warning => $warn}) if $warn;

  my $id = $captures->{id};
  my $data = $self->exercise->save($id, $params);
  $self->exercise->reWriteCash(sha256_hex('exercise' . ".$captures->{id}"), encode_json $data);
  $self->show($params, $captures);
}

sub remove {
  my ($self, $params, $captures) = @_;
  my $shaKey = sha256_hex('exercise' . ".$captures->{id}");
  $self->exercise->removeCash($shaKey);
  $self->exercise->remove($captures->{id});
  $self->show($params, $captures);
}

# use Mojo::Base 'Mojolicious::Controller';

# sub create { shift->render(exercise => {}) }

# sub edit {
#   my $self = shift;
#   $self->render(exercise => $self->exercise->find($self->param('id')));
# }

# sub index {
#   my $self = shift;
#   $self->render(exercise => $self->exercise->all);
# }

# sub remove {
#   my $self = shift;
#   $self->exercise->remove($self->param('id'));
#   $self->redirect_to('exercise');
# }

# sub show {
#   my $self = shift;
#   $self->render(exercise => $self->exercise->find($self->param('id')));
# }

# sub store {
#   my $self = shift;

#   my $v = $self->_validation;
#   return $self->render(action => 'create', exercise => {}) if $v->has_error;

#   my $id = $self->exercise->add($v->output);
#   $self->redirect_to('show_exercise', id => $id);
# }

# sub update {
#   my $self = shift;

#   my $v = $self->_validation;
#   return $self->render(action => 'edit', exercise => {}) if $v->has_error;

#   my $id = $self->param('id');
#   $self->exercise->save($id, $v->output);
#   $self->redirect_to('show_exercise', id => $id);
# }

# sub _validation {
#   my $self = shift;

#   my $v = $self->validation;
#   $v->required('description');
#   $v->required('name_function');
#   $v->required('input_parameter');
#   $v->required('output_parameter');

#   return $v;
# }

1;