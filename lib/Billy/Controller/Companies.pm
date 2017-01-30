package Billy::Controller::Companies;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

sub index : Path : Args(0) {
    my ($self, $c) = @_;

    my @companies = $c->model('DB::Company')->get_and_sort();

    $c->stash(
        template  => 'companies/index.tt',
        companies => [@companies]
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
    $c->res->status(404);
}

sub create_or_update : Local : Args(0) {
    my ($self, $c) = @_;

    if ($c->req->method ne 'POST') {
        $c->res->status(500);
        return $c->res->body('Where is my POST?');
    }

    my $action = $c->req->params->{action};
    if ($action ne 'create' and $action ne 'update') {
        $c->res->status(500);
        return $c->res->body('What do you want -- create or update?');
    }

    my $company_data = {
        id         => $c->req->params->{id}         || '',
        account    => $c->req->params->{account}    || '',
        account_my => $c->req->params->{account_my} || '',
        name       => $c->req->params->{name}       || '',
        notes      => $c->req->params->{notes}      || ''
    };

    my ($error, $company, $msg);
    if ($action eq 'create') {
        ($error, $company) = $c->model('DB::Company')
                               ->validate_and_create($company_data);
        $msg = 'Company created';
    }
    elsif ($action eq 'update') {
        ($error, $company) = $c->model('DB::Company')
                               ->validate_and_update($company_data);
        $msg = 'Company updated';
    }

    if ($error) {
        $c->res->status(500);
        return $c->res->body("ERROR: $error");
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
    $c->res->status(404) unless $company;
}

sub delete : Local : Args(1) {
    my ($self, $c, $id) = @_;

    if ($c->req->method ne 'POST') {
        $c->res->status(500);
        return $c->res->body('Use POST method to delete company');
    }

    $c->model('DB::Company')->delete_with_transactions($id);

    $c->res->redirect($c->uri_for(
        '/companies',
        {mid => $c->set_status_msg('Company deleted')}
    ));
}

__PACKAGE__->meta->make_immutable;

1;
