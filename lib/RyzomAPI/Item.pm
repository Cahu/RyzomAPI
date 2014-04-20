package RyzomAPI::Item;

use v5.014;
use strict;
use warnings;

use Mouse;


has [
	'id',
	'hp',
	'slot',
	'stack',
	'quality',
	'requiredlevel',
	'locked',
] => (
	is  => 'rw',
	isa => 'Int',
);

has [
	'sheet'
] => (
	is  => 'rw',
	isa => 'Str',
);

has [
	'craftparameters'
] => (
	is  => 'rw',
	isa => 'HashRef',
);


__PACKAGE__->meta->make_immutable();

1;

