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

	my ($error, $character, $updated) = $client->character("dummykey");

	ok($updated);
	recurent_tests($character);
}

{	# make sure the cache is used and the content hasn't changed by loading from
	# cache

	init_useragent($client, $never_expire);

	my ($error, $character, $updated) = $client->character("dummykey");

	ok(!$error);
	ok(not $updated);
	recurent_tests($character);
}

{	# make sure the entry in the cache expires and proper reloading is performed

	init_useragent($client, $always_expire);

	my ($error, $character, $updated) = $client->character("dummykey");

	ok(!$error);
	ok($updated);
	recurent_tests($character);
}

{	# make sure the cache is ignored when $forcefetch is non-zero

	init_useragent($client, $never_expire);

	my ($error, $character, $updated) = $client->character("dummykey", "force");

	ok(!$error);
	ok($updated);
	recurent_tests($character);
}


done_testing();


sub init_useragent {
	my ($client, $timeresp) = @_;

	$client->_ua(Test::LWP::UserAgent->new);

	$client->_ua->map_response(
		qr/character\.php\?apikey=.*$/,
		HTTP::Response->parse($data)
	);

	$client->_ua->map_response(
		qr/time\.php.*$/,
		HTTP::Response->parse($timeresp)
	);
}

sub recurent_tests {
	my $character = shift;

	ok($character->id           == 9999999              );
	ok($character->name          eq 'Tony'    );
	ok($character->race          eq 'Fyros'   );
	ok($character->cult          eq 'Neutral' );
	ok($character->civilization  eq 'Neutral' );

	ok(scalar grep { defined } @{ $character->room } == 2);
}


__DATA__
HTTP/1.1 200 OK
Content-Type: application/xml; charset=UTF-8

<?xml version="1.0"?>
<ryzomapi>
<character apikey="censored" created="1399118058" modules="C01:C02:C03:C04:C05:C06:A01:A02:A03:P01:P02:P03:P04:P05:P06" cached_until="1399121516">
<id>9999999</id>
<name>Tony</name>
<shard>Atys</shard>
<race>Fyros</race>
<gender>m</gender>
<titleid>Homin</titleid>
<cult>Neutral</cult>
<civilization>Neutral</civilization>
<played lastlogin="1399108810" lastlogout="1399118046">830288</played>
<body>
<hairtype>61</hairtype>
<haircolor>6</haircolor>
<tattoo>12</tattoo>
<eyescolor>1</eyescolor>
<gabarit height="10" torso="6" arms="5" legs="5" breast="4"/>
<morph target1="3" target2="2" target3="1" target4="3" target5="3" target6="4" target7="1" target8="2"/>
</body>
<guild>
<gid>909090</gid>
<name>Guild Name</name>
<icon>838900</icon>
<grade>Member</grade>
</guild>
<equipment>
<handr slot="11" quality="100">itarmor.sitem</handr>
</equipment>
<position x="18577" y="-24610" z="0"/>
<characteristics>
<constitution>90</constitution>
<metabolism>90</metabolism>
<intelligence>135</intelligence>
<wisdom>135</wisdom>
<strength>90</strength>
<wellbalanced>70</wellbalanced>
<dexterity>120</dexterity>
<will>90</will>
</characteristics>
<scores>
<hitpoints base="1000">1000</hitpoints>
<stamina base="1000">1000</stamina>
<sap base="1450">1450</sap>
<focus base="1300">1300</focus>
</scores>
<bag>
<item id="7312981313821236233" slot="0">
<stack>1</stack>
<sheet>itforage.sitem</sheet>
<quality>250</quality>
<locked>1</locked>
<hp>75</hp>
</item>
<item id="7311029006371641585" slot="1">
<stack>1</stack>
<sheet>itjewel.sitem</sheet>
<quality>100</quality>
<locked>1</locked>
<hp>44</hp>
</item>
</bag>
<money>526912</money>
<building>7897221</building>
<room>
<item id="7302033523785459808" slot="4">
<stack>1</stack>
<sheet>icmahg.sitem</sheet>
<quality>80</quality>
<locked>1</locked>
<hp>293</hp>
<craftparameters>
<durability value="335">0.677944</durability>
<weight value="5.22">0.696208</weight>
<statenergy>0.633334</statenergy>
<dodgemodifier value="-1">0.724950</dodgemodifier>
<parrymodifier value="1">0.553393</parrymodifier>
<protectionfactor value="51.07">0.553393</protectionfactor>
<maxslashingprotection value="165">0.553393</maxslashingprotection>
<maxbluntprotection value="205">0.933333</maxbluntprotection>
<maxpiercingprotection value="167">0.574052</maxpiercingprotection>
<color>7</color>
<hpbuff>40</hpbuff>
<protection>None</protection>
<protection1>None</protection1>
<protection2>None</protection2>
<protection3>None</protection3>
</craftparameters>
</item>
<item id="7302057352264018110" slot="5">
<stack>1</stack>
<sheet>icmahv_2.sitem</sheet>
<quality>80</quality>
<locked>1</locked>
<hp>335</hp>
<craftparameters>
<durability value="378">0.890000</durability>
<weight value="11.94">0.806000</weight>
<statenergy>0.650000</statenergy>
<dodgemodifier value="0">0.790000</dodgemodifier>
<parrymodifier value="0">0.460000</parrymodifier>
<protectionfactor value="50.88">0.544000</protectionfactor>
<maxslashingprotection value="155">0.460000</maxslashingprotection>
<maxbluntprotection value="199">0.874000</maxbluntprotection>
<maxpiercingprotection value="192">0.806000</maxpiercingprotection>
<color>7</color>
<hpbuff>40</hpbuff>
<protection>None</protection>
<protection1>None</protection1>
<protection2>None</protection2>
<protection3>None</protection3>
</craftparameters>
</item>
</room>
<shop/>
<pets>
<animal index="0">
<sheet>chidb2.creature</sheet>
<status>landscape</status>
<satiety>548.19531</satiety>
<position x="18886" y="-24379" z="-7"/>
<inventory>
<item id="7281812113382892930" slot="0">
<stack>4</stack>
<sheet>if1.sitem</sheet>
<quality>1</quality>
<locked>0</locked>
<hp>0</hp>
</item>
<item id="7333833126640355396" slot="2">
<stack>62</stack>
<sheet>m0006dxacc01.sitem</sheet>
<quality>90</quality>
<locked>0</locked>
<hp>0</hp>
</item>
<item id="7314802998430038058" slot="3">
<stack>10</stack>
<sheet>m0014dxacc01.sitem</sheet>
<quality>80</quality>
<locked>0</locked>
<hp>0</hp>
</item>
</inventory>
</animal>
<animal index="1">
<sheet>chjdf3.creature</sheet>
<status>landscape</status>
<satiety>650.99640</satiety>
<position x="17601" y="-25117" z="1"/>
<inventory>
<item id="7326572282562141796" slot="48">
<stack>4</stack>
<sheet>m0586ckdca01.sitem</sheet>
<quality>238</quality>
<locked>0</locked>
<hp>0</hp>
</item>
<item id="7288887904499762279" slot="51">
<stack>5</stack>
<sheet>m0535dxadd01.sitem</sheet>
<quality>100</quality>
<locked>0</locked>
<hp>0</hp>
</item>
</inventory>
</animal>
<animal index="2">
<sheet/>
<status>not_present</status>
<satiety>0.00000</satiety>
<position x="0" y="0" z="0"/>
<inventory/>
</animal>
<animal index="3">
<sheet/>
<status>not_present</status>
<satiety>0.00000</satiety>
<position x="0" y="0" z="0"/>
<inventory/>
</animal>
</pets>
<fame>
<fyros>285902</fyros>
<kami>107840</kami>
<karavan>-48195</karavan>
<matis>-120000</matis>
<tribe_antikamis>-300253</tribe_antikamis>
<tribe_company_of_the_eternal_tree>-99794</tribe_company_of_the_eternal_tree>
<tribe_darkening_sap>-244</tribe_darkening_sap>
<tribe_ecowarriors>244</tribe_ecowarriors>
<tribe_frahar_hunters>300000</tribe_frahar_hunters>
<tribe_goo_heads>-488</tribe_goo_heads>
<tribe_icon_workshipers>-99179</tribe_icon_workshipers>
<tribe_lawless>-500803</tribe_lawless>
<tribe_leviers>123833</tribe_leviers>
<tribe_master_of_the_goo>-488</tribe_master_of_the_goo>
<tribe_oasis_diggers>300000</tribe_oasis_diggers>
<tribe_pyromancers>300000</tribe_pyromancers>
<tribe_renegades>-403135</tribe_renegades>
<tribe_restorers>206001</tribe_restorers>
<tribe_root_tappers>300000</tribe_root_tappers>
<tribe_sacred_sap>200332</tribe_sacred_sap>
<tribe_scorchers>-501693</tribe_scorchers>
<tribe_siblings_of_the_weeds>100410</tribe_siblings_of_the_weeds>
<tribe_tutors>-399824</tribe_tutors>
<tribe_water_breakers>300000</tribe_water_breakers>
<tryker>-57000</tryker>
<zorai>64700</zorai>
</fame>
<skills>
<sc>20</sc>
<sca>50</sca>
<scah>65.00</scah>
<scal>94.05</scal>
<scam>51</scam>
<scas>51</scas>
<scj>50</scj>
<scja>51</scja>
<scjb>51</scjb>
<scjd>51</scjd>
<scje>80.07</scje>
<scjp>51</scjp>
<scjr>51</scjr>
<scm>50</scm>
<scm1>51</scm1>
<scm2>51</scm2>
<scmc>74.67</scmc>
<scr>21</scr>
<sf>20</sf>
<sfm>50</sfm>
<sfm1>51</sfm1>
<sfm2>75.07</sfm2>
<sfmc>51.16</sfmc>
<sfr>21</sfr>
<sh>20</sh>
<shf>50</shf>
<shfd>100</shfd>
<shfda>110.37</shfda>
<shff>51</shff>
<shfj>51</shfj>
<shfl>83.63</shfl>
<shfp>56.54</shfp>
<sm>20</sm>
<smd>50</smd>
<smda>77.09</smda>
<smdh>100</smdh>
<smdha>120.18</smdha>
<smo>50</smo>
<smoa>57.06</smoa>
<smoe>85.00</smoe>
</skills>
<factionpoints>
<kami>0</kami>
<karavan>0</karavan>
<fyros>1327</fyros>
<matis>0</matis>
<tryker>0</tryker>
<zorai>0</zorai>
</factionpoints>
<pvppoints>0</pvppoints>
<skillpoints>
<fight spent="740">0</fight>
<magic spent="1906">244</magic>
<craft spent="2095">95</craft>
<harvest spent="1455">5</harvest>
</skillpoints>
<rpjobs>
<rpjob sheet="rpjob_204.sitem" echelon="1" progress="1" active="false"/>
<rpjob sheet="rpjob_205.sitem" echelon="1" progress="1" active="true"/>
<rpjob sheet="rpjob_200.sitem" echelon="1" progress="1" active="false"/>
<rpjob sheet="rpjob_203.sitem" echelon="1" progress="1" active="true"/>
<rpjob sheet="rpjob_202.sitem" echelon="1" progress="4" active="true"/>
</rpjobs>
</character>
</ryzomapi>
