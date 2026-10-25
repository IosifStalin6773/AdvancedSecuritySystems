// (servidor) -> hashmap especialidad -> [miembros [uid], encargados [uid], solicitudes [[uid, nombre, fecha]], historial]
private _db = localNamespace getVariable "ADVSEC_specDB";
if (!isNil "_db") exitWith {_db};
if (isNil "ADVSEC_repKey") then {[] call ADVSEC_fnc_repLoad};
_db = createHashMap;
{if (_x isEqualType [] && {count _x == 2}) then {_db set [_x select 0, +(_x select 1)]}} forEach (profileNamespace getVariable [ADVSEC_repKey + "_spec", []]);
{
    if !(configName _x in _db) then {_db set [configName _x, [[], [], [], []]]};
} forEach ("true" configClasses (configFile >> "ADVSEC_Specialties"));
localNamespace setVariable ["ADVSEC_specDB", _db];
_db
