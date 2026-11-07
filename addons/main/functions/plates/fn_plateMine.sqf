// Mis vehículos: denunciar robo / recuperado
["plates", ("STR_ADVSEC_my_vehicles" call ADVSEC_fnc_L), [
    [("STR_ADVSEC_report_as_stolen" call ADVSEC_fnc_L), {params ["_p"]; if (!isNil "_p") then {["stolen", player, [_p]] remoteExecCall ["ADVSEC_fnc_plateServer", 2]}}],
    [("STR_ADVSEC_recovered" call ADVSEC_fnc_L), {params ["_p"]; if (!isNil "_p") then {["found", player, [_p]] remoteExecCall ["ADVSEC_fnc_plateServer", 2]}}],
    [("STR_ADVSEC_refresh" call ADVSEC_fnc_L), {["refresh"] call ADVSEC_fnc_panelAction}]
], {["mine", player] remoteExecCall ["ADVSEC_fnc_plateServer", 2]}] call ADVSEC_fnc_panelOpen;
