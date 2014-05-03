package RyzomAPI::Guild;

use v5.014;
use strict;
use warnings;

use RyzomAPI::Item;
use RyzomAPI::Guild::Member;

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
	'name',
	'race',
	'cult',
	'civilization',
] => (
	is  => 'rw',
	isa => 'Str',
);

has [
	'motd',
	'description',
] => (
	is  => 'rw',
	isa => 'Maybe[Str]',
);

has [
	'gid',
	'icon',
	'building',
	'creation_date',
	'money',
] => (
	is  => 'rw',
	isa => 'Int',
);

has 'fame' => (
	is  => 'rw',
	isa => 'HashRef[Int]',
);

has [
	'created',
	'cached_until',
] => (
	is  => 'rw',
	isa => 'Int',
);

has 'members' => (
	is  => 'rw',
	isa => 'ArrayRef[RyzomAPI::Guild::Member]',
);

has 'room' => (
	is  => 'rw',
	isa => 'ArrayRef[Maybe[RyzomAPI::Item]]',
);


around BUILDARGS => sub {
	my ($orig, $class, $args) = @_;

	# Create guild member objects
	$args->{members} = [
		map {
			(ref $_ ne 'RyzomAPI::Guild::Member')
				? RyzomAPI::Guild::Member->new($_)
				: $_;
		} @{ $args->{members}{member} }
	];

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

