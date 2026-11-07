// [objeto, nombre] — terminal ciber de Inteligencia/Compliance (init del objeto, todas las máquinas)
params ["_obj", ["_name", ("STR_ADVSEC_pmc_cy_terminal" call ADVSEC_fnc_L)]];
if (isServer && {!(call ADVSEC_fnc_trustedInit)}) exitWith {};
if (isNull _obj) exitWith {};
if (isServer) then {[_obj, "cyber", _name] call ADVSEC_fnc_register};
[_obj, "advsec_cyber", _name, ADVSEC_icCam,
    {[] call ADVSEC_fnc_cyOpen},
    {[_player, "cyberView"] call ADVSEC_fnc_perm || {(([_player] call ADVSEC_fnc_cellRole) select 0) == "SEC"}},
    "main", [], 3
] call ADVSEC_fnc_addInteraction;
