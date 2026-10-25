// Lista de especialidades: abrir su PDA, solicitar ingreso o darse de baja
["specs", "Especialidades · metopas", [
    ["Abrir PDA", {params ["_id"]; if (!isNil "_id") then {closeDialog 0; [_id] spawn {sleep 0.1; _this call ADVSEC_fnc_specPda}}}],
    ["Solicitar ingreso", {params ["_id"]; if (!isNil "_id") then {["apply", player, [_id]] remoteExecCall ["ADVSEC_fnc_specServer", 2]}}],
    ["Darme de baja", {params ["_id"]; if (!isNil "_id") then {["leave", player, [_id]] remoteExecCall ["ADVSEC_fnc_specServer", 2]}}],
    ["Actualizar", {["refresh"] call ADVSEC_fnc_panelAction}]
], {["list", player] remoteExecCall ["ADVSEC_fnc_specServer", 2]}] call ADVSEC_fnc_panelOpen;
