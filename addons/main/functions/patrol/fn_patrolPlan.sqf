// (cliente, mando) Nueva patrulla: datos en un formulario y ruta marcada con clics en el mapa
if !([player, "patrolPlan"] call ADVSEC_fnc_perm) exitWith {hint ("STR_ADVSEC_you_are_not_allowed_to" call ADVSEC_fnc_L)};
private _pm = ((allPlayers - entities "HeadlessClient_F") select {alive _x && {[_x, "PM"] call ADVSEC_fnc_repAccess}}) apply {[name _x, getPlayerUID _x]};
if (_pm isEqualTo []) exitWith {hint ("STR_ADVSEC_there_are_no_mp_officers" call ADVSEC_fnc_L)};
[("STR_ADVSEC_new_route_patrol" call ADVSEC_fnc_L), [
    [("STR_ADVSEC_name" call ADVSEC_fnc_L), format [("STR_ADVSEC_patrol_2" call ADVSEC_fnc_L), groupId group player]],
    [("STR_ADVSEC_assigned_officers" call ADVSEC_fnc_L), [], ["multi", _pm]],
    [("STR_ADVSEC_radius_of_each_point_m" call ADVSEC_fnc_L), "50"],
    [("STR_ADVSEC_time_limit_min_0_no" call ADVSEC_fnc_L), "30"]
], {
    params ["_v"];
    _v params ["_name", "_uids", "_rad", "_min"];
    if (_uids isEqualTo []) exitWith {hint ("STR_ADVSEC_assign_at_least_one_officer" call ADVSEC_fnc_L)};
    [_name, _uids, parseNumber _rad, parseNumber _min] spawn {
        params ["_name", "_uids", "_rad", "_min"];
        ADVSEC_patPts = [];
        private _draw = {
            {if ((_x find "advsec_patplan_") == 0) then {deleteMarkerLocal _x}} forEach allMapMarkers;
            {
                private _m = createMarkerLocal ["advsec_patplan_" + str _forEachIndex, _x];
                _m setMarkerTypeLocal "mil_dot";
                _m setMarkerColorLocal "ColorOrange";
                _m setMarkerTextLocal str (_forEachIndex + 1);
            } forEach ADVSEC_patPts;
            if (count ADVSEC_patPts > 1) then {
                private _l = [];
                {_l append [_x select 0, _x select 1]} forEach ADVSEC_patPts;
                private _m = createMarkerLocal ["advsec_patplan_line", ADVSEC_patPts select 0];
                _m setMarkerShapeLocal "POLYLINE";
                _m setMarkerPolylineLocal _l;
                _m setMarkerColorLocal "ColorOrange";
            };
            hintSilent parseText format [("STR_ADVSEC_plan_routeclick_add_point_alt" call ADVSEC_fnc_L), count ADVSEC_patPts];
        };
        ADVSEC_patDraw = _draw;
        private _eh = addMissionEventHandler ["MapSingleClick", {
            params ["", "_pos", "_alt"];
            if (_alt) then {if (ADVSEC_patPts isNotEqualTo []) then {ADVSEC_patPts deleteAt (count ADVSEC_patPts - 1)}} else {
                if (count ADVSEC_patPts < 30) then {ADVSEC_patPts pushBack [_pos select 0, _pos select 1]};
            };
            call ADVSEC_patDraw;
        }];
        openMap [true, false];
        call _draw;
        sleep 0.5;
        waitUntil {sleep 0.1; !visibleMap};
        removeMissionEventHandler ["MapSingleClick", _eh];
        {if ((_x find "advsec_patplan_") == 0) then {deleteMarkerLocal _x}} forEach allMapMarkers;
        if (ADVSEC_patPts isEqualTo []) exitWith {hint ("STR_ADVSEC_patrol_discarded_the_route_has" call ADVSEC_fnc_L)};
        ["create", player, [_name, +ADVSEC_patPts, _rad, _min, _uids]] remoteExecCall ["ADVSEC_fnc_patrolServer", 2];
        ADVSEC_patPts = nil;
    };
}] call ADVSEC_fnc_zeusPrompt;
