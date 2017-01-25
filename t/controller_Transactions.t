use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Billy';
use Billy::Controller::Transactions;

ok( request('/transactions')->is_success, 'Request should succeed' );
done_testing();
