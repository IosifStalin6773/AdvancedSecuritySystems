// [hospital] (cliente, spawn, 1.24): opera al herido más cercano al hospital (20 s con barra de progreso)
params ["_h"];
private _cands = (_h nearEntities ["CAManBase", 8]) select {alive _x && {_x != player} && {damage _x > 0.3 || {lifeState _x == "INCAPACITATED"} || {_x getVariable ["ACE_isUnconscious", false]}}};
if (_cands isEqualTo []) exitWith {hint ("STR_ADVSEC_hosp_noone" call ADVSEC_fnc_L)};
private _u = ([_cands, [], {_x distance _h}, "ASCEND"] call BIS_fnc_sortBy) select 0;
private _done = {params ["_h", "_u"]; ["surgery", player, [_h, _u]] remoteExecCall ["ADVSEC_fnc_hospServer", 2]};
private _time = 20;
if (!isNil "ace_common_fnc_progressBar") exitWith {
    [_time, [_h, _u, _done], {(_this select 0) params ["_h", "_u", "_done"]; [_h, _u] call _done}, {hint ("STR_ADVSEC_hosp_cancel" call ADVSEC_fnc_L)}, format [("STR_ADVSEC_hosp_operating" call ADVSEC_fnc_L), name _u]] call ace_common_fnc_progressBar;
};
private _start = getPosATL player;
private _end = time + _time;
private _ok = true;
player playMoveNow "AinvPknlMstpSnonWnonDnon_medic_1";
while {time < _end} do {
    if (!alive player || {(player distance _start) > 2}) exitWith {_ok = false};
    hintSilent format [("STR_ADVSEC_hosp_progress" call ADVSEC_fnc_L), name _u, round (100 * (1 - (_end - time) / _time)), "%"];
    sleep 0.5;
};
[player, ""] remoteExecCall ["switchMove", 0];
hintSilent "";
if (_ok) then {[_h, _u] call _done} else {hint ("STR_ADVSEC_hosp_cancel" call ADVSEC_fnc_L)};
