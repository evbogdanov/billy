package Billy::Controller::Companies;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

sub index : Path : Args(0) {
    my ($self, $c) = @_;

    my @companies = $c->model('DB::Company')->get_and_sort();

    $c->stash(
        template        => 'companies/index.tt',
        companies_found => scalar(@companies),
        companies       => [@companies]
    );
}

sub form_create : Local : Args(0) {
    my ($self, $c) = @_;
    
    $c->stash(
        template => 'companies/form.tt',
        company  => undef
    );
}

sub form_update : Local : Args(1) {
    my ($self, $c, $id) = @_;

    if (my $company = $c->model('DB::Company')->find($id)) {
        return $c->stash(
            template => 'companies/form.tt',
            company  => $company
        );
    }

    $c->res->body('No company to update');
}

sub create_or_update : Local : Args(0) {
    my ($self, $c) = @_;

    return $c->res->body('Where is my POST?')
        if $c->req->method ne 'POST';

    my $action = $c->req->params->{action};
    return $c->res->body('What do you want -- create or update?')
        if $action ne 'create' and $action ne 'update';

    my $company_data = {
        id         => $c->req->params->{id}         || '',
        account    => $c->req->params->{account}    || '',
        account_my => $c->req->params->{account_my} || '',
        name       => $c->req->params->{name}       || '',
        notes      => $c->req->params->{notes}      || ''
    };

    # Create or update?
    my ($company, $msg);
    if ($action eq 'create') {
        $company = $c->model('DB::Company')->create($company_data);
        $msg     = 'Company created';
    }
    elsif ($action eq 'update') {
        $company = $c->model('DB::Company')->find_and_update($company_data);
        $msg     = 'Company updated';
    }

    $c->res->redirect($c->uri_for(
        '/companies/' . $company->id,
        {mid => $c->set_status_msg($msg)}
    ));
}

sub show : Path : Args(1) {
    my ($self, $c, $id) = @_;

    my $company = $c->model('DB::Company')->find($id);

    $c->stash(
        template => 'companies/show.tt',
        company  => $company
    );
}

sub delete : Local : Args(1) {
    my ($self, $c, $id) = @_;

    return $c->res->body("You shouldn't use a GET method to delete stuff")
        if $c->req->method ne 'POST';

    $c->model('DB::Company')->delete_with_transactions($id);

    $c->res->redirect($c->uri_for(
        '/companies',
        {mid => $c->set_status_msg('Company deleted')}
    ));
}

__PACKAGE__->meta->make_immutable;

1;
