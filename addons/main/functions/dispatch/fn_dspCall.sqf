// Llamada al 112 (cualquier jugador)
[("STR_ADVSEC_112_call_2" call ADVSEC_fnc_L), [[("STR_ADVSEC_what_is_happening" call ADVSEC_fnc_L), "", "text"]], {
    params ["_v"];
    ["call", player, [_v select 0]] remoteExecCall ["ADVSEC_fnc_dspServer", 2];
}] call ADVSEC_fnc_zeusPrompt;
