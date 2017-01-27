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

# Validate and maybe create
sub validate_and_create {
    my ($self, $company_data) = @_;

    my $company = $self->new($company_data);

    if (my $error = $company->has_error()) {
        return ($error, undef);
    }

    return (undef, $company->insert());
}

# Validate and maybe update
sub validate_and_update {
    my ($self, $company_data) = @_;

    my $company = $self->find($company_data->{id});
    $company->set_columns($company_data);

    if (my $error = $company->has_error()) {
        return ($error, undef);
    }

    return (undef, $company->update());
}

# Search for the company and then delete:
#    - company itself
#    - all company's transactions
sub delete_with_transactions {
    my ($self, $id) = @_;
 
    $self->search({id => $id})->delete_all();
}
 
1;
