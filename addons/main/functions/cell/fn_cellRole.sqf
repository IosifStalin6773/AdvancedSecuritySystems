// [unidad] -> [rol, estado] ("" si no pertenece a ninguna célula). Funciona en cliente y servidor.
params ["_u"];
private _uid = getPlayerUID _u;
private _r = (missionNamespace getVariable ["ADVSEC_cellRoles", []]) select {(_x select 0) == _uid};
if (_r isEqualTo []) exitWith {["", ""]};
[(_r select 0) select 1, (_r select 0) select 2]
