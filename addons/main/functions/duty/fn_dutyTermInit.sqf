// [objeto, nombre] — terminal de fichaje (init del objeto, todas las máquinas)
params ["_obj", ["_name", ("STR_ADVSEC_duty_clock" call ADVSEC_fnc_L)]];
if (isServer && {!(call ADVSEC_fnc_trustedInit)}) exitWith {};
if (isNull _obj) exitWith {};
_obj setVariable ["ADVSEC_dutyTerm", true];
if (isServer) then {[_obj, "duty", _name] call ADVSEC_fnc_register};
[_obj, "advsec_duty", ("STR_ADVSEC_clock_in_out_of_duty" call ADVSEC_fnc_L), ADVSEC_icJail,
    {["toggle", _player, [_target]] remoteExecCall ["ADVSEC_fnc_dutyServer", 2]},
    {[_player, "PMC"] call ADVSEC_fnc_repAccess || {[_player, "AI"] call ADVSEC_fnc_repAccess}},
    "main", [], 3
] call ADVSEC_fnc_addInteraction;
