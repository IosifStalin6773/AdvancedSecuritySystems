// Central de despacho (PM): avisos 112 y pánicos
if !([player, "PMC"] call ADVSEC_fnc_repAccess) exitWith {hint ("STR_ADVSEC_only_the_military_police_can_2" call ADVSEC_fnc_L)};
["dispatch", ("STR_ADVSEC_dispatch_centre" call ADVSEC_fnc_L), [
    [("STR_ADVSEC_accept_alert" call ADVSEC_fnc_L), {params ["_id"]; if (!isNil "_id") then {["accept", player, [_id]] remoteExecCall ["ADVSEC_fnc_dspServer", 2]}}],
    [("STR_ADVSEC_close_alert" call ADVSEC_fnc_L), {params ["_id"]; if (!isNil "_id") then {["close", player, [_id]] remoteExecCall ["ADVSEC_fnc_dspServer", 2]}}],
    [("STR_ADVSEC_clock_in_out" call ADVSEC_fnc_L), {["toggle", player] remoteExecCall ["ADVSEC_fnc_dutyServer", 2]}],
    [("STR_ADVSEC_officers_on_duty" call ADVSEC_fnc_L), {closeDialog 0; [] spawn {sleep 0.1; [] call ADVSEC_fnc_dutyOpen}}],
    [("STR_ADVSEC_refresh" call ADVSEC_fnc_L), {["refresh"] call ADVSEC_fnc_panelAction}]
], {["list", player] remoteExecCall ["ADVSEC_fnc_dspServer", 2]}] call ADVSEC_fnc_panelOpen;
