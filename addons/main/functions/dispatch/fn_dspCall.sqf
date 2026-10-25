// Llamada al 112 (cualquier jugador)
["LLAMADA AL 112", [["¿Qué ocurre?", "", "text"]], {
    params ["_v"];
    ["call", player, [_v select 0]] remoteExecCall ["ADVSEC_fnc_dspServer", 2];
}] call ADVSEC_fnc_zeusPrompt;
