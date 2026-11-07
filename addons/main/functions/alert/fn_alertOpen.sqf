// Cambiar el nivel de alerta de la base (permiso alertLevel)
if !([player, "alertLevel"] call ADVSEC_fnc_perm) exitWith {hint ("STR_ADVSEC_your_rank_does_not_allow_3" call ADVSEC_fnc_L)};
[("STR_ADVSEC_base_alert_level" call ADVSEC_fnc_L), [[("STR_ADVSEC_level_2" call ADVSEC_fnc_L), missionNamespace getVariable ["ADVSEC_alertLevel", 0], [[("STR_ADVSEC_green_normal" call ADVSEC_fnc_L), 0], [("STR_ADVSEC_yellow_alarms_armed" call ADVSEC_fnc_L), 1], [("STR_ADVSEC_red_doors_locked_and_id" call ADVSEC_fnc_L), 2]]]], {
    params ["_v"];
    ["set", player, [_v select 0]] remoteExecCall ["ADVSEC_fnc_alertServer", 2];
}] call ADVSEC_fnc_zeusPrompt;
