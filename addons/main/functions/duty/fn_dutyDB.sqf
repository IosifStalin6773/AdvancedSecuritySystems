// (servidor) -> hashmap SteamID -> [minutos totales, nombre, turnos [[inicio, fin, minutos], ...]]
private _db = localNamespace getVariable "ADVSEC_dutyDB";
if (!isNil "_db") exitWith {_db};
if (isNil "ADVSEC_repKey") then {[] call ADVSEC_fnc_repLoad};
_db = createHashMap;
{if (_x isEqualType [] && {count _x == 2}) then {_db set [_x select 0, +(_x select 1)]}} forEach (profileNamespace getVariable [ADVSEC_repKey + "_duty", []]);
localNamespace setVariable ["ADVSEC_dutyDB", _db];
_db
