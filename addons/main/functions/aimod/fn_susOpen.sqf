// AA.II.: suspensiones temporales de agentes
["susp", ("STR_ADVSEC_ia_suspensions" call ADVSEC_fnc_L), [
    [("STR_ADVSEC_suspend_officer" call ADVSEC_fnc_L), {[("STR_ADVSEC_suspend_officer_2" call ADVSEC_fnc_L), [[("STR_ADVSEC_officer" call ADVSEC_fnc_L), objNull, "players"], [("STR_ADVSEC_hours" call ADVSEC_fnc_L), 24, [1, 6, 12, 24, 48, 72, 168, 336, 720] apply {[format ["%1 h", _x], _x]}], [("STR_ADVSEC_reason" call ADVSEC_fnc_L), "", "text"]], {
        params ["_v"];
        ["suspend", player, _v] remoteExecCall ["ADVSEC_fnc_susServer", 2];
    }] call ADVSEC_fnc_zeusPrompt}],
    [("STR_ADVSEC_lift_suspension" call ADVSEC_fnc_L), {params ["_uid"]; if (!isNil "_uid") then {["lift", player, [_uid]] remoteExecCall ["ADVSEC_fnc_susServer", 2]}}],
    [("STR_ADVSEC_bank_audit" call ADVSEC_fnc_L), {closeDialog 0; [] spawn {sleep 0.1; [] call ADVSEC_fnc_auditOpen}}],
    [("STR_ADVSEC_body_cameras" call ADVSEC_fnc_L), {closeDialog 0; [] spawn {sleep 0.1; [] call ADVSEC_fnc_bodyOpen}}],
    [("STR_ADVSEC_refresh" call ADVSEC_fnc_L), {["refresh"] call ADVSEC_fnc_panelAction}]
], {["list", player] remoteExecCall ["ADVSEC_fnc_susServer", 2]}] call ADVSEC_fnc_panelOpen;
