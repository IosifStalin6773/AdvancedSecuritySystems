// [objeto, nombre] — terminal de fichaje (init del objeto, todas las máquinas)
params ["_obj", ["_name", "Fichaje"]];
if (isServer && {!(call ADVSEC_fnc_trustedInit)}) exitWith {};
if (isNull _obj) exitWith {};
_obj setVariable ["ADVSEC_dutyTerm", true];
if (isServer) then {[_obj, "duty", _name] call ADVSEC_fnc_register};
[_obj, "advsec_duty", "Fichar entrada / salida de servicio", ADVSEC_icJail,
    {["toggle", _player, [_target]] remoteExecCall ["ADVSEC_fnc_dutyServer", 2]},
    {[_player, "PM"] call ADVSEC_fnc_repAccess || {[_player, "AI"] call ADVSEC_fnc_repAccess}},
    "main", [], 3
] call ADVSEC_fnc_addInteraction;
