package Billy::Controller::Companies;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

sub index : Path : Args(0) {
    my ($self, $c) = @_;

    my @companies = $c->model('DB::Company')->search(
        {}, # I want all of them
        {order_by => 'name'},
    );

    $c->stash(
        template        => 'companies/index.tt',
        companies_found => scalar(@companies),
        companies       => [@companies],
    );
}

sub create : Local : Args(0) {
    my ($self, $c) = @_;

    $c->res->body('Create a brand new company');
}

sub show : Path : Args(1) {
    my ($self, $c, $id) = @_;

    my $company = $c->model('DB::Company')->find($id);

    $c->stash(
        template => 'companies/show.tt',
        company  => $company,
    );
}

__PACKAGE__->meta->make_immutable;

1;
