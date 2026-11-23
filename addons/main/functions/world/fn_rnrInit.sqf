// [objeto] (todas las máquinas, 1.24): terminal de permisos. Estado de la base y vuelos de permiso (R&R).
params ["_obj"];
if (isNull _obj) exitWith {};
if (isServer) then {[_obj, "rnr", ("STR_ADVSEC_rnr" call ADVSEC_fnc_L)] call ADVSEC_fnc_register};
[_obj, "advsec_rnr_status", ("STR_ADVSEC_rnr_status" call ADVSEC_fnc_L), ADVSEC_icDoc,
    {["status", _player, [_target]] remoteExecCall ["ADVSEC_fnc_rnrServer", 2]},
    {true}, "main", [], 3
] call ADVSEC_fnc_addInteraction;
[_obj, "advsec_rnr_leave", ("STR_ADVSEC_rnr_leave" call ADVSEC_fnc_L), ADVSEC_icRun,
    {
        private _d = ["rnrDestinations", ["Base"]] call ADVSEC_fnc_setting;
        [("STR_ADVSEC_rnr_leave" call ADVSEC_fnc_L), [[("STR_ADVSEC_rnr_f_dest" call ADVSEC_fnc_L), _d select 0, _d apply {[_x, _x]}]], {
            params ["_v", "_t"];
            ["leave", player, [_t, _v select 0]] remoteExecCall ["ADVSEC_fnc_rnrServer", 2];
        }, _target] call ADVSEC_fnc_zeusPrompt;
    },
    {(_player getVariable ["ADVSEC_leaveUntil", 0]) < serverTime},
    "main", [], 3
] call ADVSEC_fnc_addInteraction;
