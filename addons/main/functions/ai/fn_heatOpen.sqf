// Panel de AA.II.: índice de sospecha de los agentes
["heat", "Asuntos Internos · índice de sospecha", [
    ["Abrir expediente", {
        params ["_uid"];
        if (isNil "_uid") exitWith {};
        closeDialog 0;
        ["AI", format ["[%1]", _uid]] call ADVSEC_fnc_repEditorOpen;
    }],
    ["Archivar índice", {
        params ["_uid"];
        if (!isNil "_uid") then {["reset", player, [_uid]] remoteExecCall ["ADVSEC_fnc_heatServer", 2]};
    }],
    ["Actualizar", {["refresh"] call ADVSEC_fnc_panelAction}]
], {["list", player] remoteExecCall ["ADVSEC_fnc_heatServer", 2]}] call ADVSEC_fnc_panelOpen;
