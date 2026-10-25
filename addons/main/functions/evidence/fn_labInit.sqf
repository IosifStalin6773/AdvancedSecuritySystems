// [objeto, nombre] — laboratorio forense (en todas las máquinas)
params ["_obj", ["_name", "Laboratorio forense"]];
if (isServer && {!(call ADVSEC_fnc_trustedInit)}) exitWith {};
if (isNull _obj) exitWith {};
if (isServer) then {
    _obj setVariable ["ADVSEC_lab", true, true];
    _obj setVariable ["ADVSEC_labName", _name, true];
    [_obj, "lab", _name] call ADVSEC_fnc_register;
};
[_obj, "advsec_lab", _name, ADVSEC_icSearch,
    {[_target] call ADVSEC_fnc_evOpen},
    {[_player, "PM"] call ADVSEC_fnc_repAccess},
    "main", [], 3
] call ADVSEC_fnc_addInteraction;
