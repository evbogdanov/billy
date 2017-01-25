use strict;
use warnings;

use Billy;

my $app = Billy->apply_default_middlewares(Billy->psgi_app);
$app;

