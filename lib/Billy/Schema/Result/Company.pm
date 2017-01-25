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

=head2 account

  data_type: 'char'
  is_nullable: 0
  size: 20

=head2 account_my

  data_type: 'varchar'
  is_nullable: 0
  size: 20

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 notes

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 300

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


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
