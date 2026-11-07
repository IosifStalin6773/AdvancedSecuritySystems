// [SteamID, concepto, importe] (servidor): carga un coste al contrato en curso en el que figure ese operador. -> id o ""
params ["_uid", "_what", "_amt"];
private _db = [] call ADVSEC_fnc_ctrDB;
private _id = "";
{
    if ((_y get "state") == "En curso" && {((_y get "assigned") findIf {(_x select 0) == _uid}) >= 0}) exitWith {
        ((_y get "metrics") get "costs") pushBack [_what, round _amt];
        _id = _x;
        ["contracts"] call ADVSEC_fnc_dbDirty;
    };
} forEach _db;
_id
