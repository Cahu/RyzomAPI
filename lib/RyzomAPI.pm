package RyzomAPI;

use 5.014;
use strict;
use warnings;

use LWP::UserAgent;
use XML::Simple qw(:strict);

use RyzomAPI::Time;

use Mouse;


has 'time_base_url' => (
	is      => 'rw',
	isa     => 'Str',
	default => "http://api.ryzom.com/time.php",
);

has 'guild_base_url' => (
	is      => 'rw',
	isa     => 'Str',
	default => "http://api.ryzom.com/guild.php",
);

has 'guilds_base_url' => (
	is      => 'rw',
	isa     => 'Str',
	default => "http://api.ryzom.com/guilds.php",
);

has 'character_base_url' => (
	is      => 'rw',
	isa     => 'Str',
	default => "http://api.ryzom.com/character.php",
);


# defined with 'our' to swap in testing
our $UA = LWP::UserAgent->new(
	timeout   => 10,
	env_proxy => 1,
);

my $XS = XML::Simple->new(
	KeyAttr    => 1,
	ForceArray => 0,
);


sub time {
	my ($self) = @_;

	my $base_url = $self->time_base_url;

	my $time;
	my $resp = $UA->get($base_url . "?format=xml");

	if ($resp->is_success) {
		my $xmlstr = $resp->content;

		$time = RyzomAPI::Time->new($XS->XMLin($xmlstr));
	}

	return $time;
}

sub character {
	my ($self, $apikey) = @_;

	my $base_url = $self->character_base_url;
}

sub guild {
	my ($self, $apikey) = @_;

	my $base_url = $self->guild_base_url;
}

sub guildlist {
	my ($self) = @_;

	my $base_url = $self->guilds_base_url;
}

1;
