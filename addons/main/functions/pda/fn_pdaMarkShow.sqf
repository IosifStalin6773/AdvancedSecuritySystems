// [id, posición, texto] (cliente): marca táctica compartida (pdaMarkMin minutos, 10 por defecto)
params ["_id", "_pos", "_txt"];
// 1.22: "clear" borra todas las marcas tácticas que están en el mapa
if (_id == "clear") exitWith {
    {if ((_x find "advsec_tac_") == 0) then {deleteMarkerLocal _x}} forEach allMapMarkers;
    hint ("STR_ADVSEC_m_tac_cleared" call ADVSEC_fnc_L);
};
private _m = createMarkerLocal [_id, _pos];
_m setMarkerTypeLocal "mil_warning";
_m setMarkerColorLocal "ColorRed";
_m setMarkerTextLocal _txt;
[_id] spawn {params ["_id"]; sleep (60 * ((["pdaMarkMin", 10] call ADVSEC_fnc_setting) max 1)); deleteMarkerLocal _id};
hint parseText format [("STR_ADVSEC_m_tac_received" call ADVSEC_fnc_L), _txt];
