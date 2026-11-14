// Módulo de Eden (solo servidor): zona de encargos. Crea el marcador advsec_ctr_* que usan las ofertas automáticas.
// Borrar el módulo retira el marcador.
params ["_logic", "", ["_activated", true]];
if (!_activated || {!isServer} || {!isNull (_logic getVariable ["ADVSEC_ctrZoneMark", objNull]) || {(_logic getVariable ["ADVSEC_ctrZone", ""]) != ""}}) exitWith {};
private _name = _logic getVariable ["Name", ("STR_ADVSEC_pmc_zone_name" call ADVSEC_fnc_L)];
private _rad = (_logic getVariable ["Radius", 300]) max 50;
private _mark = format ["advsec_ctr_%1_%2", count allMapMarkers, round (random 99999)];
createMarker [_mark, getPosATL _logic];
_mark setMarkerShape "ELLIPSE";
_mark setMarkerSize [_rad, _rad];
_mark setMarkerColor "ColorOrange";
_mark setMarkerAlpha 0.6;
_mark setMarkerText _name;
_logic setVariable ["ADVSEC_ctrZone", _mark];
_logic addEventHandler ["Deleted", {
    params ["_l"];
    private _m = _l getVariable ["ADVSEC_ctrZone", ""];
    if (_m != "") then {deleteMarker _m};
}];
