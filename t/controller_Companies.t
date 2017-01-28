#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use HTTP::Request::Common;
use Catalyst::Test 'Billy';
use Billy::Controller::Companies;

## CREATE
## -----------------------------------------------------------------------------

ok request('/companies/form_create')->is_success, 'form ok';

is request('/companies/create_or_update')->code, 500, 'no post -- no party';

is request(POST '/companies/create_or_update', [
    action => 'miss',
])->code, 500, 'missing action';

ok request(POST '/companies/create_or_update', [
    action     => 'create',
    id         => '1',
    account    => '11111111111111111111',
    account_my => '123',
    name       => 'gazprom',
    notes      => ''
])->is_error, 'bad id';

is request(POST '/companies/create_or_update', [
    action     => 'create',
    id         => '1111111111',
    account    => '1',
    account_my => '123',
    name       => 'gazprom',
    notes      => ''
])->code, 500, 'bad account';

ok request(POST '/companies/create_or_update', [
    action     => 'create',
    id         => '1111111111',
    account    => '11111111111111111111',
    account_my => '123',
    name       => 'gazprom',
    notes      => ''
])->is_redirect, 'create ok';

## READ
## -----------------------------------------------------------------------------

ok request('/companies')->is_success, 'companies ok';

is request('/companies/0000000000')->code, 404, 'company not found';

is request('/companies/1111111111')->code, 200, 'company found';

like request('/companies/1111111111')->as_string, qr{gazprom}, 'really found';

## UPDATE
## -----------------------------------------------------------------------------

ok request('/companies/form_update/0000000000')->is_error, 'no company -- no form';

ok request('/companies/form_update/1111111111')->is_success, 'form ok';

is request(POST '/companies/create_or_update', [
    action     => 'update',
    id         => '1111111111',
    account    => '2',
    account_my => '456',
    name       => 'gazmyas',
    notes      => ''
])->code, 500, 'failed update';

ok request(POST '/companies/create_or_update', [
    action     => 'update',
    id         => '1111111111',
    account    => '22222222222222222222',
    account_my => '456',
    name       => 'gazmyas',
    notes      => ''
])->is_redirect, 'update ok';

like request('/companies/1111111111')->as_string, qr{gazmyas}, 'really updated';

## DELETE
## -----------------------------------------------------------------------------

ok request(POST '/companies/delete/1111111111', [])->is_redirect, 'delete ok';

ok request('/companies/1111111111')->is_error, 'really deleted';

done_testing();
