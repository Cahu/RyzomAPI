use strict;
use warnings;

use Test::More tests => 5;

BEGIN {
	use_ok('RyzomAPI', qw(:all));
};

ok(defined &ryzom_guild_api);
ok(defined &ryzom_guildlist_api);
ok(defined &ryzom_character_api);
ok(defined &ryzom_app_authenticate);
