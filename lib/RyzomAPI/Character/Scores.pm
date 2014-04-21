package RyzomAPI::Character::Scores;

use 5.014;
use strict;
use warnings;


use Mouse;

has [
	'hitpoints',
	'stamina',
	'focus',
	'sap',
	'base_hitpoints',
	'base_stamina',
	'base_focus',
	'base_sap',
] => (
	is  => 'rw',
	isa => 'Int',
);


sub hp {
	my ($self, @args) = @_;
	return $self->hitpoints(@args);
}


around BUILDARGS => sub {
	my ($orig, $class, $args) = @_;

	# handle api's hash
	for my $score (qw(stamina hitpoints focus sap)) {
		if (ref $args->{$score}) {
			# this is likely to be a hash holding the base and current stat.
			# let's split them
			$args->{"base_$score"} = $args->{$score}{base};
			$args->{"$score"     } = $args->{$score}{content};
		}
	}

	return $class->$orig($args);
};

__PACKAGE__->meta->make_immutable();

1;

