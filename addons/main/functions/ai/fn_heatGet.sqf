// [SteamID] -> entrada de sospecha con el decaimiento aplicado (servidor)
params ["_uid"];
private _db = [] call ADVSEC_fnc_heatDB;
private _e = _db getOrDefault [_uid, []];
if (_e isEqualTo []) exitWith {[0, call ADVSEC_fnc_minutes, [], "", ""]};
private _now = call ADVSEC_fnc_minutes;
private _steps = floor ((_now - (_e select 1)) / 10);
if (_steps > 0) then {
    _e set [0, ((_e select 0) - _steps * (["heatDecay", 1] call ADVSEC_fnc_setting)) max 0];
    _e set [1, (_e select 1) + _steps * 10];
};
_e
