use utf8;
package Billy::Schema::Result::Transaction;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Billy::Schema::Result::Transaction

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

=head1 TABLE: C<transaction>

=cut

__PACKAGE__->table("transaction");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 company_id

  data_type: 'char'
  is_foreign_key: 1
  is_nullable: 0
  size: 10

=head2 date

  data_type: 'date'
  datetime_undef_if_invalid: 1
  is_nullable: 0

=head2 date_paid

  data_type: 'date'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=head2 amount

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "company_id",
  { data_type => "char", is_foreign_key => 1, is_nullable => 0, size => 10 },
  "date",
  { data_type => "date", datetime_undef_if_invalid => 1, is_nullable => 0 },
  "date_paid",
  { data_type => "date", datetime_undef_if_invalid => 1, is_nullable => 1 },
  "amount",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 company

Type: belongs_to

Related object: L<Billy::Schema::Result::Company>

=cut

__PACKAGE__->belongs_to(
  "company",
  "Billy::Schema::Result::Company",
  { id => "company_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-01-28 00:45:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:q6fwjFvvd7tpOrffbZhaDQ

## MODEL API
## -----------------------------------------------------------------------------

# Format date and date_paid as YYYY-MM-DD

sub date_str      { _format_date(shift->date) }
sub date_paid_str { _format_date(shift->date_paid) }

sub _format_date {
    my $date = shift;

    return sprintf("%d-%02d-%02d", $date->year, $date->month, $date->day);
}

# Kopeks to rubles
sub amount_str {
    my $kop = shift->amount;
    return sprintf("%.2f", $kop / 100);
}

__PACKAGE__->meta->make_immutable;

1;
