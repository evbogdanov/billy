use utf8;
package Billy::Schema::Result::Company;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Billy::Schema::Result::Company

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<company>

=cut

__PACKAGE__->table("company");

=head1 ACCESSORS

=head2 id

  data_type: 'char'
  is_nullable: 0
  size: 10
  description_ru: 'ИНН'

=head2 account

  data_type: 'char'
  is_nullable: 0
  size: 20
  description_ru: 'Расчётный счёт'

=head2 account_my

  data_type: 'varchar'
  is_nullable: 0
  size: 20
  description_ru: 'Лицевой счёт'

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 100
  description_ru: 'Название'

=head2 notes

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 300
  description_ru: 'Заметки'

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "char", is_nullable => 0, size => 10 },
  "account",
  { data_type => "char", is_nullable => 0, size => 20 },
  "account_my",
  { data_type => "varchar", is_nullable => 0, size => 20 },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "notes",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 300 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 transactions

Type: has_many

Related object: L<Billy::Schema::Result::Transaction>

=cut

__PACKAGE__->has_many(
  "transactions",
  "Billy::Schema::Result::Transaction",
  { "foreign.company_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-01-26 00:26:52
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:tvsfVUT+XErp/SLdo92ocw

## MODEL API
## -----------------------------------------------------------------------------

# Validate company model. If everything looks good, then return perlish
# false value. Otherwise return string with the first encountered error.
sub has_error {
    my $self = shift;

    return 'Invalid id'
        if $self->id !~ m/^[0-9]{10}$/;

    return 'Invalid account'
        if $self->account !~ m/^[0-9]{20}$/;

    return undef;
}

__PACKAGE__->meta->make_immutable;

1;
