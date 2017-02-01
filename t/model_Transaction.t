#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Scalar::Util 'looks_like_number';
use DateTime;

BEGIN { use_ok 'Billy::Schema' }
BEGIN { use_ok 'Billy::Model::DB' }

## BEGIN
## -----------------------------------------------------------------------------

my $company_id = '1111111111';

my $connect_info = Billy::Model::DB->config->{connect_info};
my $schema       = Billy::Schema->connect($connect_info);

# I cannot test transaction without created company
$schema->resultset('Company')->validate_and_create({
    id         => $company_id,
    account    => '11111111111111111111',
    account_my => '123',
    name       => 'gazprom',
    notes      => ''    
});

## TESTS
## -----------------------------------------------------------------------------

# Validation logic lives in controller :-(
# There's not much to test here

my @txs = $schema->resultset('Transaction')->get_recent();
my $txs_count = scalar @txs;

ok looks_like_number($txs_count), 'counter ok';

my $tx = $schema->resultset('Transaction')->create({
    company_id => $company_id,
    date       => '2017-01-01',
    date_paid  => DateTime->new(year => 2017, month => 1, day => 17),
    amount     => 1234
});

is $tx->date_str, '2017-01-01', 'date -> to string ok';

is $tx->date_paid_str, '2017-01-17', 'DateTime -> date -> to string ok';

is $tx->amount_str, '12.34', 'kopeks to rubles is ok';

my @txs_plus_one = $schema->resultset('Transaction')->get_recent();
my $txs_count_plus_one = scalar @txs_plus_one;

is $txs_count_plus_one, $txs_count + 1, 'counter really ok';

my $tx_recent = $txs_plus_one[0];

is $tx_recent->company_id, $company_id, 'transaction is the most recent';

## END
## -----------------------------------------------------------------------------

# Get rid of the artefacts
$schema->resultset('Company')->delete_with_transactions($company_id);

done_testing();
