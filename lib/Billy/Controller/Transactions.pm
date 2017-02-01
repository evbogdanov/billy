package Billy::Controller::Transactions;
use Moose;
use namespace::autoclean;
use DateTime;

BEGIN { extends 'Catalyst::Controller'; }

sub index : Path : Args(0) {
    my ($self, $c) = @_;

    my @transactions = $c->model('DB::Transaction')->get_recent();

    $c->stash(
        template     => 'transactions/index.tt',
        transactions => [@transactions]
    );
}

sub form_create : Local : Args(0) {
    my ($self, $c) = @_;

    my @companies = $c->model('DB::Company')->get_and_sort();    
    $c->stash(
        template    => 'transactions/form.tt',
        transaction => undef,
        companies   => [@companies]
    );
}

sub form_update : Local : Args(1) {
    my ($self, $c, $id) = @_;

    if (my $tx = $c->model('DB::Transaction')->find($id)) {
        my @companies = $c->model('DB::Company')->get_and_sort();
        return $c->stash(
            template    => 'transactions/form.tt',
            transaction => $tx,
            companies   => [@companies]
        );
    }

    $c->res->status(404);
    $c->res->body('No transaction to update');
}

sub create_or_update : Local : Args(0) {
    my ($self, $c) = @_;

    if ($c->req->method ne 'POST') {
        $c->res->status(500);
        return $c->res->body('Use POST method to create transaction');
    }

    my $action = $c->req->params->{action};
    if ($action ne 'create' and $action ne 'update') {
        $c->res->status(500);
        return $c->res->body('Hrm, create or update?');
    }

    my $tx_data = {
        company_id => $c->req->params->{company_id} || 0,
        date       => $c->req->params->{date}       || '',
        date_paid  => $c->req->params->{date_paid}  || '',
        amount     => $c->req->params->{amount}     || 0
    };

    unless ($c->model('DB::Company')->find($tx_data->{company_id})) {
        $c->res->status(404);
        return $c->res->body('Company not found');
    }

    my $dates_ok = eval {
        my ($dy, $dm, $dd)    = split /-/, $tx_data->{date};
        my ($dpy, $dpm, $dpd) = split /-/, $tx_data->{date_paid};
        DateTime->new(year => $dy,  month => $dm,  day => $dd);
        DateTime->new(year => $dpy, month => $dpm, day => $dpd);
        1;
    };
    unless ($dates_ok) {
        $c->res->status(500);
        return $c->res->body('Make sure that both dates are correct');
    }

    if ($tx_data->{amount} !~ m/^\d+$/) {
        $c->res->status(500);
        return $c->res->body('Invalid amount');
    }

    if ($action eq 'update') {
        my $id = $c->req->params->{id} || 0;
        unless ($c->model('DB::Transaction')->find($id)) {
            $c->res->status(404);
            return $c->res->body('No transaction to update');            
        }
        $tx_data->{id} = $id;
    }

    my $tx  = $c->model('DB::Transaction')->update_or_create($tx_data);
    my $msg = "Transaction ${action}d";
    $c->res->redirect($c->uri_for(
        '/transactions/' . $tx->id,
        {mid => $c->set_status_msg($msg)}
    ));
}

sub show : Path : Args(1) {
    my ($self, $c, $id) = @_;

    if (my $tx = $c->model('DB::Transaction')->find($id)) {
        return $c->stash(
            template    => 'transactions/show.tt',
            transaction => $tx
        );
    }

    $c->res->status(404);
    $c->res->body('Transaction not found');
}

sub delete : Local : Args(1) {
    my ($self, $c, $id) = @_;

    if ($c->req->method ne 'POST') {
        $c->res->status(500);
        return $c->res->body('Use POST method to delete transaction');
    }

    if (my $tx = $c->model('DB::Transaction')->find($id)) {
        $tx->delete();
        return $c->res->redirect($c->uri_for(
            '/transactions',
            {mid => $c->set_status_msg('Transaction deleted')}
        ));
    }

    $c->res->status(500);
    $c->res->body('No transaction to delete');    
}

__PACKAGE__->meta->make_immutable;

1;
