// [objeto] (todas las máquinas, 1.24): sirena de la base. Suena con la alarma de base y con el toque de queda.
params ["_obj"];
if (isNull _obj) exitWith {};
if (isServer) then {
    [_obj, "siren", ("STR_ADVSEC_siren" call ADVSEC_fnc_L)] call ADVSEC_fnc_register;
    if (isNil "ADVSEC_sirens") then {ADVSEC_sirens = []};
    ADVSEC_sirens pushBackUnique _obj;
    if (isNil "ADVSEC_curfewH") then {ADVSEC_curfewH = [] spawn {["loop", objNull] call ADVSEC_fnc_sirenServer}};
};
[_obj, "advsec_siren_alarm", ("STR_ADVSEC_siren_alarm" call ADVSEC_fnc_L), ADVSEC_icAlarm,
    {["alarm", _player, [_target]] remoteExecCall ["ADVSEC_fnc_sirenServer", 2]},
    {[_player, "baseAlarm"] call ADVSEC_fnc_perm},
    "main", [], 4
] call ADVSEC_fnc_addInteraction;
