package Billy::Controller::Companies;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

sub index : Path : Args(0) {
    my ($self, $c) = @_;
    $c->stash(template => 'companies/index.tt');
}

__PACKAGE__->meta->make_immutable;

1;
