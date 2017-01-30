package Billy::Schema::ResultSet::Transaction;
 
use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

# Retrieve the most recent transactions
sub get_recent {
    return shift->search(
        {},
        { order_by => {-desc => 'id'} }
    );
}

1;
