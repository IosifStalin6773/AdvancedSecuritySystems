// [SteamID, nombre, motivo, peligrosidad] (servidor) — requisitoria emitida por el sistema (checkpoint, multas impagadas)
params ["_uid", "_name", "_reason", ["_level", "Media"]];
if (!isServer || {_uid isEqualTo ""} || {(_uid select [0, 3]) == "AI:"}) exitWith {};
if (isNil "ADVSEC_wantedDB") then {[] call ADVSEC_fnc_policeDBLoad};
if (_uid in ADVSEC_wantedDB) exitWith {};
ADVSEC_wantedDB set [_uid, [_name, _reason, _level, "Sistema ADVSEC", call ADVSEC_fnc_now, ""]];
["wanted"] call ADVSEC_fnc_policeDBSave;
["wantedAdd", objNull, [_name, _uid, _level, _reason]] call ADVSEC_fnc_logEvent;
(format ["PM: %1 declarado BUSCADO (%2).", _name, _reason]) remoteExecCall ["systemChat", 0];
