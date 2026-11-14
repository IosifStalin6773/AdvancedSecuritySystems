// [unidad] -> bool (servidor/cliente): hay una orden de registro vigente para esta persona
params ["_u"];
private _w = localNamespace getVariable ["ADVSEC_warrantDB", createHashMap];
private _until = _w getOrDefault [getPlayerUID _u, -1];
_until > (call ADVSEC_fnc_utcMin)
