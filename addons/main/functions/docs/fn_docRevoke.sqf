// [unidad, idDocumento] (servidor): retira un documento del almacén
params ["_unit", "_id"];
if (!isServer) exitWith {};
private _db = [] call ADVSEC_fnc_docStore;
private _key = [_unit] call ADVSEC_fnc_docKey;
_db set [_key, (_db getOrDefault [_key, []]) select {(_x get "id") isNotEqualTo _id}];
if (isPlayer _unit) then {["docs"] call ADVSEC_fnc_dbDirty};
[_unit] call ADVSEC_fnc_docPublish;
