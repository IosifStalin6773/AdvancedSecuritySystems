// [matrícula] (servidor) -> [estado 0 sin registro / 1 en vigor / 2 caducada, minutos restantes]
params ["_plate"];
if ((["itvDays", 30] call ADVSEC_fnc_setting) <= 0) exitWith {[1, 0]};
private _db = ["itv", "ADVSEC_itvDB"] call ADVSEC_fnc_mapDB;
private _until = _db getOrDefault [_plate, -1];
if (_until < 0) exitWith {[0, 0]};
private _left = _until - (call ADVSEC_fnc_utcMin);
[[2, 1] select (_left > 0), _left max 0]
