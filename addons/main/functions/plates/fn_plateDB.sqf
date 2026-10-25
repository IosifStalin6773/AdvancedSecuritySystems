// (servidor) -> hashmap matrícula -> [clase, SteamID dueño, nombre dueño, fecha, robado, netId]
private _db = localNamespace getVariable "ADVSEC_plateDB";
if (!isNil "_db") exitWith {_db};
if (isNil "ADVSEC_repKey") then {[] call ADVSEC_fnc_repLoad};
_db = createHashMap;
{if (_x isEqualType [] && {count _x == 2}) then {_db set [_x select 0, +(_x select 1)]}} forEach (profileNamespace getVariable [ADVSEC_repKey + "_plates", []]);
localNamespace setVariable ["ADVSEC_plateDB", _db];
_db
