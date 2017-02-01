#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use HTTP::Request::Common;
use Catalyst::Test 'Billy';
use Billy::Controller::Transactions;

## BEGIN
## -----------------------------------------------------------------------------

# I need company in order to test transactions. Is there a better way?

my $company_id = '1111111111';

my $connect_info = Billy::Model::DB->config->{connect_info};
my $schema       = Billy::Schema->connect($connect_info);

$schema->resultset('Company')->create({
    id         => $company_id,
    account    => '11111111111111111111',
    account_my => '123',
    name       => 'gazprom',
    notes      => ''    
});

## CREATE
## -----------------------------------------------------------------------------

ok request('/transactions/form_create')->is_success, 'form ok';

is request('/transactions/create_or_update')->code, 500, 'create via post';

is request(POST '/transactions/create_or_update', [
    action => 'miss',
])->code, 500, 'missing action';

is request(POST '/transactions/create_or_update', [
    action     => 'create',
    company_id => '123',
    date       => '2017-01-01',
    date_paid  => '2017-01-17',
    amount     => '1234'
])->code, 404, 'need created company to create transaction';

is request(POST '/transactions/create_or_update', [
    action     => 'create',
    company_id => $company_id,
    date       => '20170101',
    date_paid  => '2017-01-17',
    amount     => '1234'
])->code, 500, 'invalid date';

like request(POST '/transactions/create_or_update', [
    action     => 'create',
    company_id => $company_id,
    date       => '2017-01-01',
    date_paid  => '2017-40-40',
    amount     => '1234'
])->as_string, qr{make sure .+ dates are correct}i, 'invalid paid date';

is request(POST '/transactions/create_or_update', [
    action     => 'create',
    company_id => $company_id,
    date       => '2017-01-01',
    date_paid  => '2017-01-17',
    amount     => '12.34'
])->code, 500, 'invalid amount';

like request(POST '/transactions/create_or_update', [
    action     => 'create',
    company_id => $company_id,
    date       => '2017-01-01',
    date_paid  => '2017-01-17',
    amount     => 'abc'
])->as_string, qr{invalid amount}i, 'really invalid amount';

my $res = request(POST '/transactions/create_or_update', [
    action     => 'create',
    company_id => $company_id,
    date       => '2017-01-01',
    date_paid  => '2017-01-17',
    amount     => '1234'
]);

ok $res->is_redirect, 'create ok';

# Fetch transaction id from redirected page
my $redirect_to = $res->header('location');
$redirect_to =~ m{transactions/(\d+)};
my $id = $1;

## READ
## -----------------------------------------------------------------------------

ok request('/transactions')->is_success, 'transactions ok';

is request('/transactions/000')->code, 404, 'no transaction';

is request("/transactions/$id")->code, 200, 'transaction ok';

like request("/transactions/$id")->as_string, qr{12\.34}, 'really can read';

## UPDATE
## -----------------------------------------------------------------------------

ok request("/transactions/form_update/000")->is_error, 'no transaction to update';

ok request("/transactions/form_update/$id")->is_success, 'form ok';

# Create and update controllers are almost twins. No need to validate everything
# one more time. Test only update-specific stuff.

like request(POST '/transactions/create_or_update', [
    action     => 'update',
    id         => '0',
    company_id => $company_id,
    date       => '2017-01-01',
    date_paid  => '2017-01-17',
    amount     => '8910'
])->as_string, qr{no transaction}i, 'where is transaction?';

ok request(POST '/transactions/create_or_update', [
    action     => 'update',
    id         => $id,
    company_id => $company_id,
    date       => '2017-01-01',
    date_paid  => '2017-01-17',
    amount     => '8910'
])->is_redirect, 'update ok';

like request("/transactions/$id")->as_string, qr{89\.10}, 'really updated';

## DELETE
## -----------------------------------------------------------------------------

is request("/transactions/delete/$id")->code, 500, 'use post to delete';

ok request(POST "/transactions/delete/$id", [])->is_redirect, 'delete ok';

is request("/transactions/$id")->code, 404, 'really deleted';

is request(POST "/transactions/delete/$id", [])->code, 500, 'what is dead may never die';

## END
## -----------------------------------------------------------------------------

$schema->resultset('Company')->find($company_id)->delete();

done_testing();
