package RyzomAPI::Character;

use v5.014;
use strict;
use warnings;

use RyzomAPI::Character::Scores;
use RyzomAPI::Character::Characteristics;

use Mouse;


has [
	'apikey',
	'shard',
	'modules',
] => (
	is  => 'rw',
	isa => 'Str',
);

has [
	'id',
	'money',
	'pvppoints',
] => (
	is  => 'rw',
	isa => 'Int',
);

has [
	'name',
	'race',
	'cult',
	'gender',
	'civilization',
	'titleid',
] => (
	is  => 'rw',
	isa => 'Str',
);

has 'position' => (
	is  => 'rw',
	isa => 'HashRef[Int]',
);

has [
	'bag',
	'shop',
	'equipment',
	'body',
] => (
	is  => 'rw',
	isa => 'HashRef',
);

has [
	'fame',
	'factionpoints',
] => (
	is  => 'rw',
	isa => 'HashRef[Int]',
);

has [
	'rpjobs',
	'skills',
	'skillpoints',
] => (
	is  => 'rw',
	isa => 'HashRef',
);

has 'characteristics' => (
	is  => 'rw',
	isa => 'RyzomAPI::Character::Characteristics',
);

has 'scores' => (
	is  => 'rw',
	isa => 'RyzomAPI::Character::Scores',
);

has 'room' => (
	is  => 'rw',
	isa => 'ArrayRef[Maybe[RyzomAPI::Item]]',
);

has [
	'created',
	'cached_until',
] => (
	is  => 'rw',
	isa => 'Int',
);


around BUILDARGS => sub {
	my ($orig, $class, $args) = @_;

	if (ref $args->{characteristics} ne 'RyzomAPI::Character::Characteristics') {
		$args->{characteristics} = RyzomAPI::Character::Characteristics->new(
			$args->{characteristics}
		);
	}

	if (ref $args->{scores} ne 'RyzomAPI::Character::Scores') {
		$args->{scores} = RyzomAPI::Character::Scores->new(
			$args->{scores}
		);
	}

	# deal with the item list (convert to RyzomAPI::Item)
	my @items = map  {
		(ref $_ ne 'RyzomAPI::Item') ? RyzomAPI::Item->new($_) : $_;
	} @{ $args->{room}{item} };

	# Put each item into its designated slot (make things easier for people
	# using this module
	$args->{room} = [];
	$args->{room}->[$_->slot] = $_ for (@items);

	return $class->$orig($args);
};


__PACKAGE__->meta->make_immutable();

1;


