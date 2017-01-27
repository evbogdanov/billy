package Billy::Schema::ResultSet::Company;
 
use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

# Get all companies ordered by name
sub get_and_sort {
    return shift->search(
        {}, # I want all of them
        {order_by => 'name'}
    );
}

# Update existing company and return it
sub find_and_update {
    my ($self, $company_data) = @_;

    return $self->find($company_data->{id})
                ->update($company_data);
}

# Search for the company and then delete:
#    - company itself
#    - all company's transactions
sub delete_with_transactions {
    my ($self, $id) = @_;
 
    $self->search({id => $id})->delete_all();
}
 
1;
