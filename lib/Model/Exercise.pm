package Model::Exercise;
use Mojo::Base -base;

has 'pg';

sub add {
  my ($self, $post) = @_;
  return $self->pg->db->insert('exercise', $post, {returning => 'id'})->hash->{id};
}

sub all { shift->pg->db->select('exercise')->hashes->to_array }

sub find {
  my ($self, $id) = @_;
  return $self->pg->db->select('exercise', '*', {id => $id})->hash;
}

sub remove {
  my ($self, $id) = @_;
  $self->pg->db->delete('exercise', {id => $id});
}

sub save {
  my ($self, $id, $post) = @_;
  $self->pg->db->update('exercise', $post, {id => $id});
}

1;