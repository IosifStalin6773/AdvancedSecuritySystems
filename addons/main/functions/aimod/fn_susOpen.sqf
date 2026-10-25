// AA.II.: suspensiones temporales de agentes
["susp", "AA.II. · Suspensiones", [
    ["Suspender agente", {["SUSPENDER AGENTE", [["Agente", objNull, "players"], ["Horas", 24, [1, 6, 12, 24, 48, 72, 168, 336, 720] apply {[format ["%1 h", _x], _x]}], ["Motivo", "", "text"]], {
        params ["_v"];
        ["suspend", player, _v] remoteExecCall ["ADVSEC_fnc_susServer", 2];
    }] call ADVSEC_fnc_zeusPrompt}],
    ["Levantar suspensión", {params ["_uid"]; if (!isNil "_uid") then {["lift", player, [_uid]] remoteExecCall ["ADVSEC_fnc_susServer", 2]}}],
    ["Auditoría bancaria", {closeDialog 0; [] spawn {sleep 0.1; [] call ADVSEC_fnc_auditOpen}}],
    ["Cámaras corporales", {closeDialog 0; [] spawn {sleep 0.1; [] call ADVSEC_fnc_bodyOpen}}],
    ["Actualizar", {["refresh"] call ADVSEC_fnc_panelAction}]
], {["list", player] remoteExecCall ["ADVSEC_fnc_susServer", 2]}] call ADVSEC_fnc_panelOpen;
