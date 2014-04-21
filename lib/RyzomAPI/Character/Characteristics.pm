package RyzomAPI::Character::Characteristics;

use 5.014;
use strict;
use warnings;


use Mouse;

has [
	'constitution',
	'metabolism',
	'intelligence',
	'wisdom',
	'strength',
	'wellbalanced',
	'dexterity',
	'will',
] => (
	is  => 'rw',
	isa => 'Int',
);

__PACKAGE__->meta->make_immutable();

1;
