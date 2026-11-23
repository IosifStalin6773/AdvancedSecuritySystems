// (cliente, 1.24) resultado del autotest; un Zeus puede repetirlo
private _st = missionNamespace getVariable ["ADVSEC_selfTest", []];
if (_st isEqualTo []) exitWith {hint ("STR_ADVSEC_st_none" call ADVSEC_fnc_L)};
_st params ["_date", "_r"];
private _t = format ["<t font='PuristaBold'>%1</t> · %2<br/><br/>", "STR_ADVSEC_st_title" call ADVSEC_fnc_L, _date];
{_t = _t + format ["<t color='%1'>%2</t> %3<br/>", ["#FF5555", "#66DD66"] select (_x select 0), ["[X]", "[OK]"] select (_x select 0), (_x select 1) call ADVSEC_fnc_repEsc]} forEach _r;
[_t, "STR_ADVSEC_st_title" call ADVSEC_fnc_L] call ADVSEC_fnc_carShow;
