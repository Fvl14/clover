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

sub BUILD {
  my $self = shift;
  #$self->init();
}

sub init {
  my $self = shift;
  $ENV{config_as_set} = "exercise";
}

override 'processRequest' => sub {
  my $self = shift;
  my $method = lc $self->type;
  $self->$method();
};

sub _build_exercise {
  my $self = shift;
  $self->exercise(Model::Exercise->new());
}

override 'get' => sub {
  my $self = shift;
  if ($ENV{ID}) {
    my $shaKey = sha256_hex('exercise' . ".$ENV{ID}");
    my $data = $self->exercise->aerospike->getCash($shaKey);
    if ($data) {
      $self->render("cool");
      $self->render($data);
    } else {
      $data = $self->exercise->find($ENV{ID});
      $self->exercise->aerospike->storeCash($shaKey, encode_json $data) if $data;
      $self->render($data);
    }
  } else {
    my $data = $self->exercise->all;
    $self->render($data);
  }
};

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