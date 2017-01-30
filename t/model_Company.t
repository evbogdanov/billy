#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Scalar::Util 'looks_like_number';

BEGIN { use_ok 'Billy::Schema' }
BEGIN { use_ok 'Billy::Model::DB' }

my $connect_info = Billy::Model::DB->config->{connect_info};
my $schema       = Billy::Schema->connect($connect_info);

## VALIDATOR
## -----------------------------------------------------------------------------

my $c;

$c = $schema->resultset('Company')->new({
    id         => '1',
    account    => '11111111111111111111',
    account_my => '123',
    name       => 'gazprom',
    notes      => ''
});

is $c->has_error, 'Invalid id', '10 chars, please';

$c = $schema->resultset('Company')->new({
    id         => '1111111111',
    account    => '1',
    account_my => '123',
    name       => 'gazprom',
    notes      => ''
});

is $c->has_error, 'Invalid account', '20 chars, please';

$c = $schema->resultset('Company')->new({
    id         => '111111111a',
    account    => '11111111111111111111',
    account_my => '123',
    name       => 'gazprom',
    notes      => ''
});

is $c->has_error, 'Invalid id', 'digits only, please';

$c = $schema->resultset('Company')->new({
    id         => '1111111111',
    account    => '1111111111111111111b',
    account_my => '123',
    name       => 'gazprom',
    notes      => ''
});

is $c->has_error, 'Invalid account', 'digits only, please';

$c = $schema->resultset('Company')->new({
    id         => '1111111111',
    account    => '11111111111111111111',
    account_my => '123',
    name       => 'gazprom',
    notes      => ''
});

ok !$c->has_error, 'company ok';

## READ ALL
## -----------------------------------------------------------------------------

my @all = $schema->resultset('Company')->get_and_sort();

my $count_all = scalar @all;

ok looks_like_number($count_all), 'counter ok';

## CREATE
## -----------------------------------------------------------------------------

my $id = '1111111111';

my ($error, $company) = $schema->resultset('Company')->validate_and_create({
    id         => '1',
    account    => '11111111111111111111',
    account_my => '123',
    name       => 'gazprom',
    notes      => ''    
});

is $error, 'Invalid id', 'create not ok';
is $company, undef, 'company also not ok';

($error, $company) = $schema->resultset('Company')->validate_and_create({
    id         => $id,
    account    => '11111111111111111111',
    account_my => '123',
    name       => 'gazprom',
    notes      => ''    
});

ok !$error, 'create seems ok';

is $company->id, $id, 'company id ok';
is $company->name, 'gazprom', 'company name ok';

my @all_plus_one = $schema->resultset('Company')->get_and_sort();
my $count_all_plus_one = scalar @all_plus_one;
is $count_all_plus_one, $count_all + 1, 'create really ok';

## READ ONE
## -----------------------------------------------------------------------------

is $schema->resultset('Company')->find($id)->account_my, '123', 'read ok';

## UPDATE
## -----------------------------------------------------------------------------

($error, $company) = $schema->resultset('Company')->validate_and_update({
    id         => $id,
    account    => '1',
    account_my => '456',
    name       => 'gazprom',
    notes      => ''    
});

is $error, 'Invalid account', 'update not ok';
is $company, undef, 'company also not ok';

($error, $company) = $schema->resultset('Company')->validate_and_update({
    id         => $id,
    account    => '22222222222222222222',
    account_my => '789',
    name       => 'gazprom',
    notes      => ''    
});

is $schema->resultset('Company')->find($id)->account, '22222222222222222222',
'account updated';

is $schema->resultset('Company')->find($id)->account_my, '789',
'account_my updated';

## DELETE
## -----------------------------------------------------------------------------

$schema->resultset('Company')->delete_with_transactions($id);

my @all_end = $schema->resultset('Company')->get_and_sort();
my $count_all_end = scalar @all_end;
is $count_all_end, $count_all, 'delete ok';

done_testing();
