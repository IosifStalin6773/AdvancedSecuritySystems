// [objeto, nombre] — terminal de superadministrador (init del objeto, todas las máquinas)
params ["_obj", ["_name", ("STR_ADVSEC_superadmin_terminal_2" call ADVSEC_fnc_L)]];
if (isServer && {!(call ADVSEC_fnc_trustedInit)}) exitWith {};
if (isNull _obj) exitWith {};
if (isServer) then {[_obj, "admin", _name] call ADVSEC_fnc_register};
[_obj, "advsec_admin", ("STR_ADVSEC_superadmin_terminal_2" call ADVSEC_fnc_L), ADVSEC_icPol,
    {[] call ADVSEC_fnc_adminOpen},
    {[_player] call ADVSEC_fnc_adminIs},
    "main", [], 3
] call ADVSEC_fnc_addInteraction;
