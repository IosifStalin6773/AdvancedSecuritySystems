// Control de servicio: horas por agente (permiso dutyView)
["duty", ("STR_ADVSEC_duty_control" call ADVSEC_fnc_L), [
    [("STR_ADVSEC_dispatch_centre" call ADVSEC_fnc_L), {closeDialog 0; [] spawn {sleep 0.1; [] call ADVSEC_fnc_dspOpen}}],
    [("STR_ADVSEC_refresh" call ADVSEC_fnc_L), {["refresh"] call ADVSEC_fnc_panelAction}]
], {["list", player] remoteExecCall ["ADVSEC_fnc_dutyServer", 2]}] call ADVSEC_fnc_panelOpen;
