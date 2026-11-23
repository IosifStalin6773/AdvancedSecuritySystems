// [objeto] (todas las máquinas, 1.24): caja de equipo de la PM con herramientas, material de la PM y munición
params ["_obj"];
if (isNull _obj) exitWith {};
if (isServer) then {
    [_obj, "mpcrate", ("STR_ADVSEC_crate" call ADVSEC_fnc_L)] call ADVSEC_fnc_register;
    ["fill", objNull, [_obj]] call ADVSEC_fnc_crateServer;
};
[_obj, "advsec_crate_restock", ("STR_ADVSEC_crate_restock" call ADVSEC_fnc_L), ADVSEC_icDoc,
    {["restock", _player, [_target]] remoteExecCall ["ADVSEC_fnc_crateServer", 2]},
    {[_player, "mpCrate"] call ADVSEC_fnc_perm},
    "main", [], 3
] call ADVSEC_fnc_addInteraction;
