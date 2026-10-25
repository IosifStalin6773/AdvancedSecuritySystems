/*
    (servidor) -> hashmap SteamID -> [efectivo, banco, nombre, historial [[fecha, texto, importe], ...]]
    Se carga del perfil (repKey + "_eco") la primera vez. La tesorería va en localNamespace ADVSEC_treasury.
*/
private _db = localNamespace getVariable "ADVSEC_ecoDB";
if (!isNil "_db") exitWith {_db};
if (isNil "ADVSEC_repKey") then {[] call ADVSEC_fnc_repLoad};
_db = createHashMap;
{
    if (_x isEqualType [] && {count _x == 2}) then {_db set [_x select 0, +(_x select 1)]};
} forEach (profileNamespace getVariable [ADVSEC_repKey + "_eco", []]);
localNamespace setVariable ["ADVSEC_ecoDB", _db];
localNamespace setVariable ["ADVSEC_treasury", profileNamespace getVariable [ADVSEC_repKey + "_treasury", ["treasuryStart", 10000] call ADVSEC_fnc_setting]];
localNamespace setVariable ["ADVSEC_ecoFlags", +(profileNamespace getVariable [ADVSEC_repKey + "_ecoFlags", []])];
localNamespace setVariable ["ADVSEC_treasuryHist", +(profileNamespace getVariable [ADVSEC_repKey + "_treasuryHist", []])];
_db
