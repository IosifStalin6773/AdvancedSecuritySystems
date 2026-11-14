// Panel de patrullas (PM): las propias o asignadas; el mando ve todas
if !([player, "PMC"] call ADVSEC_fnc_repAccess) exitWith {hint ("STR_ADVSEC_only_the_military_police_can" call ADVSEC_fnc_L)};
private _b = [];
if ([player, "patrolPlan"] call ADVSEC_fnc_perm) then {
    _b pushBack [("STR_ADVSEC_new_patrol" call ADVSEC_fnc_L), {closeDialog 0; [] spawn {sleep 0.1; [] call ADVSEC_fnc_patrolPlan}}];
};
_b pushBack [("STR_ADVSEC_show_route_on_the_map" call ADVSEC_fnc_L), {params ["_id"]; if (!isNil "_id") then {["show", player, [_id]] remoteExecCall ["ADVSEC_fnc_patrolServer", 2]}}];
if ([player, "patrolPlan"] call ADVSEC_fnc_perm) then {
    _b pushBack [("STR_ADVSEC_cancel_patrol" call ADVSEC_fnc_L), {params ["_id"]; if (!isNil "_id") then {["cancel", player, [_id]] remoteExecCall ["ADVSEC_fnc_patrolServer", 2]}}];
};
_b pushBack [("STR_ADVSEC_refresh" call ADVSEC_fnc_L), {["refresh"] call ADVSEC_fnc_panelAction}];
["patrol", ("STR_ADVSEC_route_patrols" call ADVSEC_fnc_L), _b, {["list", player] remoteExecCall ["ADVSEC_fnc_patrolServer", 2]}] call ADVSEC_fnc_panelOpen;
