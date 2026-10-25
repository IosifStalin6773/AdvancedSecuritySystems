// Mis vehículos: denunciar robo / recuperado
["plates", "Mis vehículos", [
    ["Denunciar robo", {params ["_p"]; if (!isNil "_p") then {["stolen", player, [_p]] remoteExecCall ["ADVSEC_fnc_plateServer", 2]}}],
    ["Recuperado", {params ["_p"]; if (!isNil "_p") then {["found", player, [_p]] remoteExecCall ["ADVSEC_fnc_plateServer", 2]}}],
    ["Actualizar", {["refresh"] call ADVSEC_fnc_panelAction}]
], {["mine", player] remoteExecCall ["ADVSEC_fnc_plateServer", 2]}] call ADVSEC_fnc_panelOpen;
