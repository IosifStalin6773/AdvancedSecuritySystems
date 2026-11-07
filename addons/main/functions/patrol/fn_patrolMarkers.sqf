// [id, nombre, puntos, alcanzados [bool], radio, estado] (cliente): ruta de la patrulla en el mapa (se borra 2 min después de terminar)
params ["_id", "_name", "_pts", "_reached", "_rad", "_state"];
private _pre = "advsec_pat_" + _id + "_";
{if ((_x find _pre) == 0) then {deleteMarkerLocal _x}} forEach allMapMarkers;
private _line = [];
{_line append [_x select 0, _x select 1]} forEach _pts;
if (count _pts > 1) then {
    private _m = createMarkerLocal [_pre + "line", _pts select 0];
    _m setMarkerShapeLocal "POLYLINE";
    _m setMarkerPolylineLocal _line;
    _m setMarkerColorLocal "ColorBlue";
};
{
    private _ok = _reached param [_forEachIndex, false];
    private _a = createMarkerLocal [_pre + "a" + str _forEachIndex, _x];
    _a setMarkerShapeLocal "ELLIPSE";
    _a setMarkerSizeLocal [_rad, _rad];
    _a setMarkerBrushLocal "Border";
    _a setMarkerColorLocal (["ColorBlue", "ColorGreen"] select _ok);
    private _m = createMarkerLocal [_pre + str _forEachIndex, _x];
    _m setMarkerTypeLocal (["mil_dot", "mil_end"] select _ok);
    _m setMarkerColorLocal (["ColorBlue", "ColorGreen"] select _ok);
    _m setMarkerTextLocal format ["%1 %2 · %3", _id, _forEachIndex + 1, _name];
} forEach _pts;
if !(_state in ["assigned", "active"]) then {
    [_pre] spawn {
        params ["_pre"];
        sleep 120;
        {if ((_x find _pre) == 0) then {deleteMarkerLocal _x}} forEach allMapMarkers;
    };
};
