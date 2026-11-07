// [SteamID] (servidor) -> [[clase, serie], ...] material corporativo firmado por ese jugador. Lo publica en su unidad (ADVSEC_corpArms).
params ["_uid", ["_publish", true]];
private _w = [] call ADVSEC_fnc_wpnDB;
private _out = [];
{
    if ((_y param [4, ""]) == "CORP" && {(_y select 5) == "Firmada"} && {((_y select 6) param [0, ""]) == _uid}) then {_out pushBack [_y select 0, _x, _y select 7]};
} forEach _w;
if (_publish) then {
    private _u = [_uid] call ADVSEC_fnc_uidUnit;
    if (!isNull _u) then {_u setVariable ["ADVSEC_corpArms", _out, true]};
};
_out apply {[_x select 0, _x select 1]}
