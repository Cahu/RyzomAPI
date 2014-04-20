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

has 'cache' => (
	is  => 'ro',
	isa => 'HashRef[Int]',
);


my @month_of_cycle = qw(
	Winderly
	Germinally
	Folially
	Floris
	Medis
	Thermis
	Harvestor
	Frutor
	Fallenor
	Pluvia
	Mystia
	Nivia
);

my @season = qw(
	Spring
	Summer
	Autumn
	Winter
);

my @day_of_week = qw(
	Prima
	Dua
	Tria
	Quarta
	Quinteth
	Holeth
);

sub as_str {
	my ($self, $attr) = @_;

	if ($attr eq "month_of_cycle") {
		$month_of_cycle[$self->month_of_cycle];
	}

	elsif ($attr eq "season") {
		$season[$self->season];
	}

	elsif ($attr eq "day_of_week") {
		$day_of_week[$self->day_of_week];
	}

	else {
		die "No such attribute";
	}
}

__PACKAGE__->meta->make_immutable();

1;
