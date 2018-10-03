package Service;
use Mojo::Base 'Mojolicious';

use Service::Model::Exercise;
use Mojo::Pg;

sub startup {
  my $self = shift;

  # Configuration
  $self->plugin('Config');
  $self->secrets($self->config('secrets'));

  # Model
  $self->helper(pg => sub { state $pg = Mojo::Pg->new(shift->config('pg')) });
  $self->helper(
    exercise => sub { state $exercise = Blog::Model::Exersice->new(pg => shift->pg) });

  # Migrate to latest version if necessary
  #my $path = $self->home->child('migrations', 'clover.sql');
  #$self->pg->auto_migrate(1)->migrations->name('clover')->from_file($path);

  # Controller
  my $r = $self->routes;
  $r->get('/' => sub { shift->redirect_to('exercise') });
  $r->get('/exercise')->to('exercise#index');
  $r->get('/exercise/create')->to('exercise#create')->name('create_exercise');
  $r->post('/exercise')->to('exercise#store')->name('store_exercise');
  $r->get('/exercise/:id')->to('exercise#show')->name('show_exercise');
  $r->get('/exercise/:id/exercise')->to('exercise#edit')->name('edit_exercise');
  $r->put('/exercise/:id')->to('exercise#update')->name('update_exercise');
  $r->delete('/exercise/:id')->to('exercise#remove')->name('remove_exercise');
}

1;