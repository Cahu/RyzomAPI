package RyzomAPI;

use 5.014;
use strict;
use warnings;

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


sub ryzom_app_authenticate {
}

sub ryzom_time_api {
}

sub ryzom_character_api {
}

sub ryzom_guild_api {
}

sub ryzom_guildlist_api {
}

1;
