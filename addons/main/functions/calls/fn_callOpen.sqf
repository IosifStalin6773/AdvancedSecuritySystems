// (cliente, 1.24) avisos IA activos y tensión social; con Zeus o permiso callLaunch, lanzar y cancelar avisos
if !([player, "PMC"] call ADVSEC_fnc_repAccess) exitWith {hint ("STR_ADVSEC_only_the_military_police_can_2" call ADVSEC_fnc_L)};
private _btn = [];
if ([player] call ADVSEC_fnc_isZeus || {[player, "callLaunch"] call ADVSEC_fnc_perm}) then {
    _btn pushBack [("STR_ADVSEC_call_launch" call ADVSEC_fnc_L), {closeDialog 0; [] spawn {sleep 0.1; [] call ADVSEC_fnc_callZeus}}];
    _btn pushBack [("STR_ADVSEC_call_cancel" call ADVSEC_fnc_L), {params ["_id"]; if (!isNil "_id") then {["cancel", player, [_id]] remoteExecCall ["ADVSEC_fnc_callServer", 2]}}];
};
_btn pushBack [("STR_ADVSEC_refresh" call ADVSEC_fnc_L), {["refresh"] call ADVSEC_fnc_panelAction}];
["aicalls", ("STR_ADVSEC_call_menu" call ADVSEC_fnc_L), _btn, {["list", player] remoteExecCall ["ADVSEC_fnc_callServer", 2]}] call ADVSEC_fnc_panelOpen;
