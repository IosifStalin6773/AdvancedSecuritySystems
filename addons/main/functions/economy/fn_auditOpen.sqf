// AA.II.: movimientos sospechosos, auditoría y congelación de cuentas
["flags", "AA.II. · Auditoría bancaria", [
    ["Auditar cuenta", {params ["_d"]; if (!isNil "_d") then {["audit", player, [[_d, _d select 0] select (_d isEqualType [])]] remoteExecCall ["ADVSEC_fnc_ecoAI", 2]}}],
    ["Congelar / descongelar", {params ["_d"]; if (!isNil "_d") then {["freeze", player, [[_d, _d select 0] select (_d isEqualType [])]] remoteExecCall ["ADVSEC_fnc_ecoAI", 2]}}],
    ["Auditar al que cobra", {params ["_d"]; if (!isNil "_d" && {_d isEqualType []}) then {["audit", player, [_d select 1]] remoteExecCall ["ADVSEC_fnc_ecoAI", 2]}}],
    ["Volver a la lista", {["refresh"] call ADVSEC_fnc_panelAction}]
], {["flags", player] remoteExecCall ["ADVSEC_fnc_ecoAI", 2]}] call ADVSEC_fnc_panelOpen;
