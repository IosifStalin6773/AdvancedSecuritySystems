// [agente] — ofrecer un soborno en efectivo
params ["_ag"];
["OFRECER DINERO A " + toUpper name _ag, [["Importe", 200, [50, 100, 200, 500, 1000, 2000, 5000] apply {[format ["%1 %2", _x, ["currency", "€"] call ADVSEC_fnc_setting], _x]}]], {
    params ["_v", "_ag"];
    ["bribe", player, [_ag, _v select 0]] remoteExecCall ["ADVSEC_fnc_ecoAI", 2];
}, _ag] call ADVSEC_fnc_zeusPrompt;
