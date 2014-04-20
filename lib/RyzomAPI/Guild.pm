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

has 'motd' => (
	is  => 'rw',
	isa => 'Maybe[Str]',
);

has 'description' => (
	is  => 'rw',
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
	isa => 'ArrayRef[RyzomAPI::Item]',
);


around BUILDARGS => sub {
	my ($orig, $class, $args) = @_;

	$args->{members} = [
		map {
			(ref $_ ne 'RyzomAPI::Guild::Member')
				? RyzomAPI::Guild::Member->new($_)
				: $_;
		} @{ $args->{members}{member} }
	];

	$args->{room} = [
		map {
			(ref $_ ne 'RyzomAPI::Item')
				? RyzomAPI::Item->new($_)
				: $_;
		} @{ $args->{room}{item} }
	];

	return $class->$orig($args);
};


__PACKAGE__->meta->make_immutable();

1;

