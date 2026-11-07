// [sobornador, importe] (agente): aceptar o rechazar el dinero
params ["_b", "_v"];
[format [("STR_ADVSEC_offers_you" call ADVSEC_fnc_L), toUpper name _b, _v, ["currency", "€"] call ADVSEC_fnc_setting], [[("STR_ADVSEC_do_you_accept" call ADVSEC_fnc_L), false, "bool"]], {
    params ["_r", "_ctx"];
    if (_r select 0) then {["bribeAccept", player, _ctx] remoteExecCall ["ADVSEC_fnc_ecoAI", 2]} else {(format [("STR_ADVSEC_refuses_the_money" call ADVSEC_fnc_L), name player]) remoteExecCall ["hint", _ctx select 0]};
}, [_b, _v]] call ADVSEC_fnc_zeusPrompt;
