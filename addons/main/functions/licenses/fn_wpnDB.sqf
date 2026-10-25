// (servidor) -> hashmap nº de serie -> [clase, SteamID titular, nombre titular, fecha]
private _db = localNamespace getVariable "ADVSEC_wpnDB";
if (!isNil "_db") exitWith {_db};
if (isNil "ADVSEC_repKey") then {[] call ADVSEC_fnc_repLoad};
_db = createHashMap;
{if (_x isEqualType [] && {count _x == 2}) then {_db set [_x select 0, +(_x select 1)]}} forEach (profileNamespace getVariable [ADVSEC_repKey + "_weapons", []]);
localNamespace setVariable ["ADVSEC_wpnDB", _db];
_db
