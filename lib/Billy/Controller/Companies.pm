package Billy::Controller::Companies;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

sub index : Path : Args(0) {
    my ($self, $c) = @_;

    my @companies = $c->model('DB::Company')->search(
        {}, # I want all of them
        {order_by => 'name'}
    );

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
        $c->stash(
            template => 'companies/form.tt',
            company  => $company
        );
    }
    else {
        $c->res->body('No company to update');
    }
}

sub create_or_update : Local : Args(0) {
    my ($self, $c) = @_;

    return $c->res->body('Where is my POST?')
        if $c->req->method ne 'POST';

    my $action     = $c->req->params->{action}     || '';
    my $id         = $c->req->params->{id}         || '';
    my $account    = $c->req->params->{account}    || '';
    my $account_my = $c->req->params->{account_my} || '';
    my $name       = $c->req->params->{name}       || '';
    my $notes      = $c->req->params->{notes}      || '';

    return $c->res->body('What do you want -- create or update?')
        if $action ne 'create' and $action ne 'update';

    my ($company, $msg);
    # Create a brand new company
    if ($action eq 'create') {
        $company= $c->model('DB::Company')->create({
            id         => $id,
            account    => $account,
            account_my => $account_my,
            name       => $name,
            notes      => $notes
        });
        $msg = 'Company created';
    } 
    # Update existing company
    elsif ($action eq 'update') {
        $company = $c->model('DB::Company')->find($id)->update({
            account    => $account,
            account_my => $account_my,
            name       => $name,
            notes      => $notes
        });
        $msg = 'Company updated';
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

    # Search for the company and then delete:
    # - company itself
    # - all company's transactions
    $c->model('DB::Company')->search({id => $id})->delete_all();

    $c->res->redirect($c->uri_for(
        '/companies',
        {mid => $c->set_status_msg('Company deleted')}
    ));
}

__PACKAGE__->meta->make_immutable;

1;
