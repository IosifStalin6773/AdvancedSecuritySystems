// -> clases ilegales: illegalItems + mercado negro (blackMarketIllegal) + explosivos de contrabando
private _l = +(["illegalItems", []] call ADVSEC_fnc_setting);
if ((["blackMarketIllegal", 1] call ADVSEC_fnc_setting) isEqualTo 1) then {_l append ((["blackMarketItems", []] call ADVSEC_fnc_setting) apply {_x select 0})};
_l append (["contrabandExplosives", []] call ADVSEC_fnc_setting);
_l arrayIntersect _l
