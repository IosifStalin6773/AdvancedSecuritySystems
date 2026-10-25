// [objeto, nombre] — cajero automático (init del objeto, todas las máquinas)
params ["_obj", ["_name", "Cajero automático"]];
if (isServer && {!(call ADVSEC_fnc_trustedInit)}) exitWith {};
if (isNull _obj) exitWith {};
_obj setVariable ["ADVSEC_atm", true];
if (isServer) then {[_obj, "atm", _name] call ADVSEC_fnc_register};
[_obj, "advsec_atm", "Cajero: cartera y banco", ADVSEC_icDoc,
    {[] call ADVSEC_fnc_ecoOpen},
    {[] call ADVSEC_fnc_ecoOn},
    "main", [], 3
] call ADVSEC_fnc_addInteraction;
