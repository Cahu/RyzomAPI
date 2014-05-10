package RyzomAPI;

use 5.014;
use strict;
use warnings;

use LWP::UserAgent;
use XML::Simple qw(:strict);

use RyzomAPI::Time;
use RyzomAPI::Guild;
use RyzomAPI::Character;

use Mouse;


our $VERSION = 0.4.1;


=head1 NAME

RyzomAPI - Module to fetch information from the Ryzom game's API

=head1 SYNOPSIS

blabla

=cut


=head1 ATTRIBUTES

=over

=item time_base_url

=item guild_base_url

=item guilds_base_url

=item character_base_url

=back

=cut

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

has '_cache' => (
	is       => 'ro',
	isa      => 'HashRef',
	default  => sub { {} },
	init_arg => undef,
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
			KeyAttr       => 1,
			ForceArray    => 0,
			SuppressEmpty => 1,
		);
	},
);


=head1 METHODS

=over

=cut

=item time

Get the in-game time. If called in list context, the first value returned is the
'cache' field returned by the API (expirity and creation date).

=cut

sub time {
	my ($self) = @_;

	my $base_url = $self->time_base_url;

	my $time;
	my $content;

	my $resp = $self->_ua->get($base_url . "?format=xml");

	if ($resp->is_success) {
		my $xmlstr = $resp->content;

		$content = $self->_xs->XMLin($xmlstr);
		$time    = RyzomAPI::Time->new($content);

		return ($content->{cache}, $time);
	}
}


=item character($apikey [, $forcefetch])

Fetch information for the character described by $apikey from the server. If an
entry was already cached and has not expired, this entry is returned instead
unless $forcefetch is set to a true value. In list context, the first argument
is the error returned by the API if any, the second is the RyzomAPI::Character
object and the third will evaluate to true if the entry has been updated during
the call.

  my $char = $client->character;
  my ($error, $char, $updated) = $client->character;

=cut

sub character {
	my ($self, $apikey, $forcefetch) = @_;

	unless ($forcefetch || $self->cache_expired($apikey)) {
		my $entry = $self->_cache->{$apikey};
		return (undef, $entry->{data}, 0);
	}

	my $base_url = $self->character_base_url;

	my $info;
	my $resp = $self->_ua->get($base_url . "?apikey=$apikey");

	if ($resp->is_success) {
		my $xmlstr = $resp->content;

		my $content = $self->_xs->XMLin($xmlstr);
		my $error   = $content->{character}{error};

		if (! $error) {
			$info = RyzomAPI::Character->new($content->{character});
			$self->_cache->{$apikey} = {
				data   => $info,
				expire => $content->{character}{cached_until},
			};
		}

		else {
			delete $self->_cache->{$apikey};
		}

		if (wantarray) {
			return ($error, $info, 1);
		} else {
			return $info;
		}
	}
}


=item guild($apikey [, $forcefetch])

Fetch information for the guild described by $apikey from the server. If an
entry was already cached and has not expired, this entry is returned instead
unless $forcefetch is set to a true value. In list context, the first argument
is the error returned by the API if any, the second is the RyzomAPI::Guild
object and the third will evaluate to true if the entry has been updated during
the call.

  my $guild = $client->guild;
  my ($error, $guild, $updated) = $client->guild;

=cut

sub guild {
	my ($self, $apikey, $forcefetch) = @_;

	unless ($forcefetch || $self->cache_expired($apikey)) {
		my $entry = $self->_cache->{$apikey};
		return (undef, $entry->{data}, 0);
	}

	my $base_url = $self->guild_base_url;

	my $info;
	my $resp = $self->_ua->get($base_url . "?apikey=$apikey&format=xml");

	if ($resp->is_success) {
		my $xmlstr = $resp->content;

		my $content = $self->_xs->XMLin($xmlstr);
		my $error   = $content->{guild}{error};

		if (! $error) {
			$info = RyzomAPI::Guild->new($content->{guild});
			$self->_cache->{$apikey} = {
				data   => $info,
				expire => $content->{guild}{cached_until},
			};
		}

		else {
			delete $self->_cache->{$apikey};
		}

		if (wantarray) {
			return ($error, $info, 1);
		} else {
			return $info;
		}
	}
}


=item guildlist

Get a list of guilds and their members from the server.

=cut

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

		if (wantarray) {
			return ($list, $content->{cache});
		} else {
			return $list;
		}
	}
}


=item item_icon($item [, %args])

Forge the url that can be used to retrieve the icon of an item from the server.
$item may be either a RyzomAPI::Item object or a sheet name. %args may be used to add or override attributes for the icon (locked, stack size, etc).

=cut

sub item_icon {
	my ($self, $item, %args) = @_;

	my $base_url = $self->item_icon_base_url;

	my $url = $base_url . "?sheetid=";

	if (ref $item eq 'RyzomAPI::Item') {
		$url .= $item->sheet;
		$args{s}      //= $item->stack;
		$args{q}      //= $item->quality;
		$args{locked} //= $item->locked;
		if ($item->craftparameters) {
			$args{c} //= $item->craftparameters->{color} // 0;
		}
	} else {
		$url .= $item;
	}

	if (%args) {
		$url .= "&";
		$url .= join("&", map { "$_=" . $args{$_} } sort keys %args);
	}

	return $url;
}


=item item_icon_bin($item [, %args])

Same as item_icon but returns raw image data for the icon instead of the url.

=cut

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


=item cache_expired($apikey)

Returns a positive value if the cache entry for $apikey has expired, 0 if it has
not, a negative value if it wasn't found in the cache.

=cut

sub cache_expired {
	# The cache for the time command is refreshed every minute or so. We use
	# it to get the approximate time on the server's clock.
	my ($self, $apikey) = @_;

	my $t;

	if (my $entry = $self->_cache->{$apikey}) {
		my ($cacheinfo, $time) = $self->time;
		$t = $entry->{expire};
		$t = $cacheinfo->{created};
		return ($entry->{expire} <= $cacheinfo->{created}) ? 1 : 0;
	}

	return -1;
}


=back

=cut


__PACKAGE__->meta->make_immutable();

1;
