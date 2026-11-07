// Lista de especialidades: abrir su PDA, solicitar ingreso o darse de baja
["specs", ("STR_ADVSEC_specialties_patches" call ADVSEC_fnc_L), [
    [("STR_ADVSEC_open_pda" call ADVSEC_fnc_L), {params ["_id"]; if (!isNil "_id") then {closeDialog 0; [_id] spawn {sleep 0.1; _this call ADVSEC_fnc_specPda}}}],
    [("STR_ADVSEC_request_to_join" call ADVSEC_fnc_L), {params ["_id"]; if (!isNil "_id") then {["apply", player, [_id]] remoteExecCall ["ADVSEC_fnc_specServer", 2]}}],
    [("STR_ADVSEC_leave" call ADVSEC_fnc_L), {params ["_id"]; if (!isNil "_id") then {["leave", player, [_id]] remoteExecCall ["ADVSEC_fnc_specServer", 2]}}],
    [("STR_ADVSEC_refresh" call ADVSEC_fnc_L), {["refresh"] call ADVSEC_fnc_panelAction}]
], {["list", player] remoteExecCall ["ADVSEC_fnc_specServer", 2]}] call ADVSEC_fnc_panelOpen;
