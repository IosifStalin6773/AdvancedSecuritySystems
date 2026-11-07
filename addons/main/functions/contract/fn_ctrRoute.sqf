// [id] (cliente) Marca en el mapa la ruta de un contrato de escolta o VIP (clic añade, Alt+clic quita el último)
params ["_id"];
ADVSEC_patPts = [];
ADVSEC_patDraw = {
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
private _eh = addMissionEventHandler ["MapSingleClick", {
    params ["", "_pos", "_alt"];
    if (_alt) then {if (ADVSEC_patPts isNotEqualTo []) then {ADVSEC_patPts deleteAt (count ADVSEC_patPts - 1)}} else {
        if (count ADVSEC_patPts < 30) then {ADVSEC_patPts pushBack [_pos select 0, _pos select 1]};
    };
    call ADVSEC_patDraw;
}];
openMap [true, false];
call ADVSEC_patDraw;
sleep 0.5;
waitUntil {sleep 0.1; !visibleMap};
removeMissionEventHandler ["MapSingleClick", _eh];
{if ((_x find "advsec_patplan_") == 0) then {deleteMarkerLocal _x}} forEach allMapMarkers;
if (count ADVSEC_patPts >= 2) then {["route", player, [_id, +ADVSEC_patPts]] remoteExecCall ["ADVSEC_fnc_ctrServer", 2]} else {hint ("STR_ADVSEC_pmc_route_two_points" call ADVSEC_fnc_L)};
ADVSEC_patPts = nil;
