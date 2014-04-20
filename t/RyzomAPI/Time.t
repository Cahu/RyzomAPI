use strict;
use warnings;

use Test::More;
use Test::LWP::UserAgent;

BEGIN {
	use_ok('RyzomAPI::Time');
	use_ok('RyzomAPI', qw(:time));
};


# swap the user agent
$RyzomAPI::UA = Test::LWP::UserAgent->new;

$RyzomAPI::UA->map_response(
	qr/time\.php\?format=xml$/,
	HTTP::Response->parse(join("", <DATA>))
);

my $client = RyzomAPI->new();

my $time = $client->time;
ok($time->server_tick    == 618734369);
ok($time->jena_year      == 2577     );
ok($time->day_of_jy      == 1301     );
ok($time->month_of_jy    == 43       );
ok($time->cycle          == 3        );
ok($time->day_of_cycle   == 221      );
ok($time->month_of_cycle == 7        );
ok($time->day_of_month   == 11       );
ok($time->day_of_week    == 5        );
ok($time->season         == 2        );
ok($time->day_of_season  == 41       );
ok($time->time_of_day    == 13       );

ok($time->as_str('day_of_week')    eq 'Holeth');
ok($time->as_str('season')         eq 'Autumn');
ok($time->as_str('month_of_cycle') eq 'Frutor');

done_testing();


__DATA__
HTTP/1.1 200 OK
Date: Sun, 20 Apr 2014 16:39:05 GMT
Server: Apache
X-Powered-By: PHP/5.3.10-1ubuntu3.9
Expires: Thu, 19 Nov 1981 08:52:00 GMT
Cache-Control: no-store, no-cache, must-revalidate, post-check=0, pre-check=0
Pragma: no-cache
Access-Control-Allow-Origin: *
Set-Cookie: PHPSESSID=5uqmmjiu2gfnbtqcthrvmk1lg6; path=/; HttpOnly
Connection: close
Transfer-Encoding: chunked
Content-Type: application/xml; charset=UTF-8

<?xml version="1.0"?>
<shard_time>
<server_tick>618734369</server_tick>
<jena_year>2577</jena_year>
<day_of_jy>1301</day_of_jy>
<month_of_jy>43</month_of_jy>
<cycle>3</cycle>
<day_of_cycle>221</day_of_cycle>
<month_of_cycle>7</month_of_cycle>
<day_of_month>11</day_of_month>
<day_of_week>5</day_of_week>
<season>2</season>
<day_of_season>41</day_of_season>
<time_of_day>13</time_of_day>
<txt_en>13h - Holeth, Frutor 12, 4th AC 2577</txt_en>
<txt_fr>13h - Holeth, Frutor 12, 4e CA 2577</txt_fr>
<txt_de>13h - Holeth, Frutor 12, 4. AZ 2577</txt_de>
<cache created="1398011888" expire="1398011948"/>
</shard_time>

