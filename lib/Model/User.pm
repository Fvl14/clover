package Model::User;

use Moo;
use MooX::late;
use MooX::Override -class;
use Mojo::JSON qw(decode_json);

extends 'Model';

__PACKAGE__->meta->make_immutable;

sub BUILD {
  my $self = shift;
  $self->init();
}

sub init {
  my $self = shift;
  $self->as_set('user');
}

override 'getCash' => sub {
  my $self = shift;
  my $key = shift;
  my $data = super($key);
  return $data? decode_json $data->[0]->{data} : $data;
};

sub add {
  my ($self, $post) = @_;
  return $self->pg->db->insert('user', $post, {returning => 'id'})->hash->{id};
}

sub all { shift->pg->db->select('user')->hashes->to_array }

sub find {
  my ($self, $id) = @_;
  return $self->pg->db->select('user', '*', {id => $id})->hash;
}

sub remove {
  my ($self, $id) = @_;
  $self->pg->db->delete('user', {id => $id});
}

sub save {
  my ($self, $id, $post) = @_;
  $self->pg->db->update('user', $post, {id => $id});
}

sub findByEmail {
  my ($self, $email, $param) = @_;
  return $self->pg->db->select('user', $param, {email => $email})->hash;
}

1;