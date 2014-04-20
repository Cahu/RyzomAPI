use strict;
use warnings;

use Test::More tests => 2;

BEGIN {
	use_ok('RyzomAPI');
};

can_ok('RyzomAPI', qw(guild guildlist character time));
