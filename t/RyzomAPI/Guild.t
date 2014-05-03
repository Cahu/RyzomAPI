use strict;
use warnings;

use Test::More;
use Test::LWP::UserAgent;

BEGIN {
	use_ok('RyzomAPI');
};


my $client = RyzomAPI->new();

my $data = join("", <DATA>);

my $never_expire = <<XML;
HTTP/1.1 200 OK
Content-Type: application/xml; charset=UTF-8

<?xml version="1.0"?>
<shard_time>
<cache created="1" expire="9999999999"/>
</shard_time>
XML

my $always_expire = <<XML;
HTTP/1.1 200 OK
Content-Type: application/xml; charset=UTF-8

<?xml version="1.0"?>
<shard_time>
<cache created="9999999999" expire="9999999999"/>
</shard_time>
XML


# swap the user agent


{
	init_useragent($client, "");

	my ($error, $guild, $updated) = $client->guild("dummykey");

	ok($updated);
	recurent_tests($guild);
}

{	# make sure the cache is used and the content hasn't changed by loading from
	# cache

	init_useragent($client, $never_expire);

	my ($error, $guild, $updated) = $client->guild("dummykey");

	ok(!$error);
	ok(not $updated);
	recurent_tests($guild);
}

{	# make sure the entry in the cache expires and proper reloading is performed

	init_useragent($client, $always_expire);

	my ($error, $guild, $updated) = $client->guild("dummykey");

	ok(!$error);
	ok($updated);
	recurent_tests($guild);
}

{	# make sure the cache is ignored when $forcefetch is non-zero

	init_useragent($client, $never_expire);

	my ($error, $guild, $updated) = $client->guild("dummykey", "force");

	ok(!$error);
	ok($updated);
	recurent_tests($guild);
}


done_testing();


sub init_useragent {
	my ($client, $timeresp) = @_;

	$client->_ua(Test::LWP::UserAgent->new);

	$client->_ua->map_response(
		qr/guild\.php\?apikey=.*$/,
		HTTP::Response->parse($data)
	);

	$client->_ua->map_response(
		qr/time\.php.*$/,
		HTTP::Response->parse($timeresp)
	);
}

sub recurent_tests {
	my $guild = shift;

	ok($guild->gid           == 105906460              );
	ok($guild->creation_date == 167933662              );
	ok($guild->name          eq 'The Castle In The Sky');
	ok($guild->description   eq 'some desc'            );
	ok($guild->race          eq 'Zorai'                );
	ok($guild->cult          eq 'kami'                 );
	ok($guild->civilization  eq 'neutral'              );

	ok(scalar grep { defined } @{ $guild->room } == 2);
	ok(scalar @{ $guild->members } == 2);
}


__DATA__
HTTP/1.1 200 OK
Content-Type: application/xml; charset=UTF-8

<?xml version="1.0"?>
<ryzomapi>
<guild apikey="censored" created="1398084724" modules="G01:G02:G03:G04:P01" cached_until="1398085059">
<gid>105906460</gid>
<name>The Castle In The Sky</name>
<description>some desc</description>
<icon>671296194</icon>
<shard>atys</shard>
<race>Zorai</race>
<cult>kami</cult>
<civilization>neutral</civilization>
<creation_date>167933662</creation_date>
<building>183500868</building>
<motd>welcome to guild!</motd>
<money>6010105</money>
<room>
<item id="7279247017164468538" slot="0">
<stack>6</stack>
<sheet>m0128dxapf01.sitem</sheet>
<quality>249</quality>
<requiredlevel>0</requiredlevel>
<locked>0</locked>
<hp>0</hp>
</item>
<item id="7332690854302467593" slot="1">
<stack>27</stack>
<sheet>m0572ccjfd01.sitem</sheet>
<quality>160</quality>
<requiredlevel>0</requiredlevel>
<locked>0</locked>
<hp>0</hp>
</item>
</room>
<members>
<member>
<name>Hitternl</name>
<grade>Member</grade>
<joined>585643378</joined>
</member>
<member>
<name>Tabou</name>
<grade>Member</grade>
<joined>318752057</joined>
</member>
</members>
<fame>
<fyros>121065</fyros>
<matis>68713</matis>
<tryker>44439</tryker>
<zorai>131672</zorai>
<kami>328673</kami>
<karavan>-309783</karavan>
</fame>
</guild>
</ryzomapi>
