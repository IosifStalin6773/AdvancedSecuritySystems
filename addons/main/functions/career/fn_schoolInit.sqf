// [objeto] (todas las máquinas): punto de la escuela PM. El alumno pide examen; los instructores en 300 m reciben el aviso.
params ["_obj"];
if (isNull _obj) exitWith {};
if (isServer) then {[_obj, "school", ("STR_ADVSEC_car_school_point" call ADVSEC_fnc_L)] call ADVSEC_fnc_register};
[_obj, "advsec_school_ask", ("STR_ADVSEC_car_school_ask" call ADVSEC_fnc_L), ADVSEC_icDoc,
    {
        private _ins = (allPlayers select {_x != _player && {_x distance _target < 300} && {[_x, "school"] call ADVSEC_fnc_perm}});
        if (_ins isEqualTo []) exitWith {hint ("STR_ADVSEC_car_school_noone" call ADVSEC_fnc_L)};
        (format [("STR_ADVSEC_car_school_asked" call ADVSEC_fnc_L), name _player, mapGridPosition _target]) remoteExecCall ["hint", _ins];
        hint ("STR_ADVSEC_car_school_sent" call ADVSEC_fnc_L);
    },
    {!(_player getVariable ["ADVSEC_schoolOk", false])},
    "main", [], 3
] call ADVSEC_fnc_addInteraction;
[_obj, "advsec_school_pass", ("STR_ADVSEC_car_b_school" call ADVSEC_fnc_L), ADVSEC_icDoc,
    {["school"] call ADVSEC_fnc_carOpen},
    {[_player, "school"] call ADVSEC_fnc_perm},
    "main", [], 3
] call ADVSEC_fnc_addInteraction;
