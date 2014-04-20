package RyzomAPI::Time;

use v5.014;
use strict;
use warnings;

use Mouse;


has [
	'server_tick',
	'jena_year',
	'day_of_jy',
	'month_of_jy',
	'cycle',
	'day_of_cycle',
	'month_of_cycle',
	'day_of_month',
	'day_of_week',
	'season',
	'day_of_season',
	'time_of_day',
] => (
	is  => 'rw',
	isa => 'Int',
);

has [
	'txt_en',
	'txt_fr',
	'txt_de',
] => (
	is  => 'rw',
	isa => 'Str',
);


__PACKAGE__->meta->make_immutable();

1;
