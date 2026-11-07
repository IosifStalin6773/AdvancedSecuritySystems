// [unidad] (servidor) -> series firmadas por la unidad que no lleva encima ni en su vehículo
params ["_u"];
private _have = (weapons _u) apply {[_x] call BIS_fnc_baseWeapon};
private _veh = objectParent _u;
if (!isNull _veh) then {_have append ((getWeaponCargo _veh select 0) apply {[_x] call BIS_fnc_baseWeapon})};
private _out = [];
{
    _x params ["_c", "_s"];
    private _i = _have find _c;
    if (_i < 0) then {_out pushBack _s} else {_have deleteAt _i};
} forEach ([getPlayerUID _u, false] call ADVSEC_fnc_armSigned);
_out
