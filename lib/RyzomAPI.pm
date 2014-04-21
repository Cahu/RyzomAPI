package RyzomAPI;

use 5.014;
use strict;
use warnings;

use LWP::UserAgent;
use XML::Simple qw(:strict);

use RyzomAPI::Time;
use RyzomAPI::Guild;

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

has 'item_icon_base_url' => (
	is      => 'rw',
	isa     => 'Str',
	default => "http://api.ryzom.com/item_icon.php",
);

has '_ua' => (
	is       => 'rw',
	isa      => 'LWP::UserAgent',
	init_arg => undef,
	default  => sub {
		LWP::UserAgent->new(
			timeout   => 10,
			env_proxy => 1,
		);
	},
);

has '_xs' => (
	is       => 'rw',
	isa      => 'XML::Simple',
	init_arg => undef,
	default  => sub {
		XML::Simple->new(
			KeyAttr    => 1,
			ForceArray => 0,
		);
	},
);


sub time {
	my ($self) = @_;

	my $base_url = $self->time_base_url;

	my $time;
	my $resp = $self->_ua->get($base_url . "?format=xml");

	if ($resp->is_success) {
		my $xmlstr = $resp->content;

		$time = RyzomAPI::Time->new($self->_xs->XMLin($xmlstr));
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

	my $info;
	my $resp = $self->_ua->get($base_url . "?apikey=$apikey&format=xml");

	if ($resp->is_success) {
		my $xmlstr = $resp->content;

		my $content = $self->_xs->XMLin($xmlstr);
		$info = RyzomAPI::Guild->new($content->{guild});
	}

	return $info;
}

sub guildlist {
	my ($self) = @_;

	my $base_url = $self->guilds_base_url;

	my $list;
	my $resp = $self->_ua->get($base_url . "?format=xml");

	if ($resp->is_success) {
		my $xmlstr = $resp->content;

		my $content = $self->_xs->XMLin($xmlstr);
		$list = [
			map { RyzomAPI::Guild->new($_) } @{ $content->{guild} }
		];
	}

	return $list;
}

sub item_icon {
	my ($self, $item, %args) = @_;

	my $base_url = $self->item_icon_base_url;

	my $url = $base_url . "?sheetid=";

	if (ref $item eq 'RyzomAPI::Item') {
		$url .= $item->sheet;
		$args{q}      //= $item->quality;
		$args{locked} //= $item->locked;
		# TODO: some params are in 'craftparameters' ~> include them too
	} else {
		$url .= $item;
	}

	if (%args) {
		$url .= "&";
		$url .= join("&", map { "$_=" . $args{$_} } keys %args);
	}

	return $url;
}

sub item_icon_bin {
	my ($self, $item, %args) = @_;

	my $url = $self->item_icon($item, %args);

	my $img;
	my $resp = $self->_ua->get($url);

	if ($resp->is_success) {
		$img = $resp->content;
	}

	return $img;
}


1;
