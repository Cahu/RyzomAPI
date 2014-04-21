use strict;
use warnings;

use Test::More;
use Test::LWP::UserAgent;

BEGIN {
	use_ok('RyzomAPI');
};


my $client = RyzomAPI->new();

# swap the user agent
$client->_ua(Test::LWP::UserAgent->new);
$client->_ua->map_response(
	qr/guilds\.php/,
	HTTP::Response->parse(join("", <DATA>))
);


my $guilds = $client->guildlist;
my $guild1 = (grep { $_->gid == 105906177 } @$guilds)[0];

ok(scalar @$guilds == 2);
ok($guild1->name          eq 'Just trying');
ok($guild1->race          eq 'Matis'      );
ok($guild1->creation_date == 127486580    );
ok(not $guild1->description               );

done_testing();

__DATA__
HTTP/1.1 200 OK
Date: Mon, 21 Apr 2014 12:01:26 GMT
Server: Apache
X-Powered-By: PHP/5.3.10-1ubuntu3.9
Expires: Thu, 19 Nov 1981 08:52:00 GMT
Cache-Control: no-store, no-cache, must-revalidate, post-check=0, pre-check=0
Pragma: no-cache
Access-Control-Allow-Origin: *
Set-Cookie: PHPSESSID=u89qq9nhqfpo6lpm45a4seer95; path=/; HttpOnly
Connection: close
Transfer-Encoding: chunked

<?xml version="1.0"?>
<guilds>
<cache created="1398081664" expire="1398085264"/>
<shard>atys</shard>
<guild>
<gid>105906177</gid>
<name>Just trying</name>
<race>Matis</race>
<icon>544929668269603272</icon>
<creation_date>127486580</creation_date>
<description>
</description>
</guild>
<guild>
<gid>105906178</gid>
<name>La Boite Magique</name>
<race>Matis</race>
<icon>576460747016504951</icon>
<creation_date>127239578</creation_date>
<description>la boiboite d'Yrkanis</description>
</guild>
</guilds>
