// Control de servicio: horas por agente (permiso dutyView)
["duty", "Control de servicio", [
    ["Central de despacho", {closeDialog 0; [] spawn {sleep 0.1; [] call ADVSEC_fnc_dspOpen}}],
    ["Actualizar", {["refresh"] call ADVSEC_fnc_panelAction}]
], {["list", player] remoteExecCall ["ADVSEC_fnc_dutyServer", 2]}] call ADVSEC_fnc_panelOpen;
