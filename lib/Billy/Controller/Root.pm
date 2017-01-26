package Billy::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

__PACKAGE__->config(namespace => '');

sub index : Path : Args(0) {
    my ($self, $c) = @_;
    $c->stash(template => 'index.tt');
}

sub not_found : Path {
    my ($self, $c) = @_;
    $c->res->body('Oh, snap! Page not found.');
    $c->res->status(404);
}

sub end : ActionClass('RenderView') {
    my ($self, $c) = @_;

    # Load status messages
    $c->load_status_msgs();
}

__PACKAGE__->meta->make_immutable;

1;
