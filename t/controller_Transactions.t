#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Catalyst::Test 'Billy';
use Billy::Controller::Transactions;

ok request('/transactions')->is_success, 'transactions ok';

TODO: {
    local $TODO = 'implement more transaction tests';
}

done_testing();
