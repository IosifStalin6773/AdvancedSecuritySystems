// [sobornador, importe] (agente): aceptar o rechazar el dinero
params ["_b", "_v"];
[format ["%1 TE OFRECE %2 %3", toUpper name _b, _v, ["currency", "€"] call ADVSEC_fnc_setting], [["¿Aceptas?", false, "bool"]], {
    params ["_r", "_ctx"];
    if (_r select 0) then {["bribeAccept", player, _ctx] remoteExecCall ["ADVSEC_fnc_ecoAI", 2]} else {(format ["%1 rechaza el dinero.", name player]) remoteExecCall ["hint", _ctx select 0]};
}, [_b, _v]] call ADVSEC_fnc_zeusPrompt;
