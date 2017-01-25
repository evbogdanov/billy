use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Billy';
use Billy::Controller::Companies;

ok( request('/companies')->is_success, 'Request should succeed' );
done_testing();
