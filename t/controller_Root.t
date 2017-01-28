#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Catalyst::Test 'Billy';

ok request('/')->is_success, 'home page ok';

ok request('/php')->is_error, 'error!!1 no php';

is request('/perl6')->code, 404, 'perl 6 not found';

done_testing();
