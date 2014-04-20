package RyzomAPI;

use 5.014;
use strict;
use warnings;

use LWP::UserAgent;
use XML::Simple qw(:strict);


use Exporter qw(import);

our $VERSION = 0.1;

our %EXPORT_TAGS = (
	auth      => [qw(ryzom_app_authenticate)],
	time      => [qw(ryzom_time_api)],
	guild     => [qw(ryzom_guildlist_api ryzom_guild_api)],
	character => [qw(ryzom_character_api)],
);


{	# add all exported tags to :all

	my %seen;

	push @{ $EXPORT_TAGS{all} }, 
		grep { not $seen{$_}++ } @{ $EXPORT_TAGS{$_} }
			for (keys %EXPORT_TAGS);

	Exporter::export_ok_tags('all');
}


use constant {
	TIME_BASE_URL      => "http://api.ryzom.com/time.php",
	GUILD_BASE_URL     => "http://api.ryzom.com/guild.php",
	GUILDS_BASE_URL    => "http://api.ryzom.com/guilds.php",
	CHARACTER_BASE_URL => "http://api.ryzom.com/character.php",
};


my $UA = LWP::UserAgent->new(
	timeout   => 10,
	env_proxy => 1,
);

my $XS = XML::Simple->new(
	KeyAttr    => 1,
	ForceArray => 0,
);


sub ryzom_app_authenticate {
}

sub ryzom_time_api {
	my ($base_url) = @_;

	$base_url ||= TIME_BASE_URL;
}

sub ryzom_character_api {
	my ($base_url) = @_;

	$base_url ||= CHARACTER_BASE_URL;
}

sub ryzom_guild_api {
	my ($base_url) = @_;

	$base_url ||= GUILD_BASE_URL;
}

sub ryzom_guildlist_api {
	my ($base_url) = @_;

	$base_url ||= GUILDS_BASE_URL;
}

1;
