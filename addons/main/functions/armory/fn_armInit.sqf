// [caja, nombre] — armería corporativa (init del objeto, todas las máquinas). Vale cualquier contenedor, también una taquilla TS_Lockers.
params ["_obj", ["_name", ("STR_ADVSEC_pmc_armory" call ADVSEC_fnc_L)]];
if (isServer && {!(call ADVSEC_fnc_trustedInit)}) exitWith {};
if (isNull _obj) exitWith {};
if (isServer) then {
    _obj setVariable ["ADVSEC_armory", true, true];
    [_obj, "armory", _name] call ADVSEC_fnc_register;
    [] call ADVSEC_fnc_armDB;
};
[_obj, "advsec_armory", _name, ADVSEC_icKey,
    {[_target] call ADVSEC_fnc_armOpen},
    {[_player, "armoryCheckout"] call ADVSEC_fnc_perm || {[_player, "armoryManage"] call ADVSEC_fnc_perm}},
    "main", [], 3
] call ADVSEC_fnc_addInteraction;
