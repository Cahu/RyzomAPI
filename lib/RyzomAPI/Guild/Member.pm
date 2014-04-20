package RyzomAPI::Guild::Member;

use v5.014;
use strict;
use warnings;

use Mouse;

has 'name' => (
	is  => 'ro',
	isa => 'Str',
);

has 'grade' => (
	is  => 'ro',
	isa => 'Str',
);

has 'joined' => (
	is  => 'rw',
	isa => 'Int',
);

__PACKAGE__->meta->make_immutable();

1;

