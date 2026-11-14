// [id, posición, texto] (cliente): marca táctica compartida (pdaMarkMin minutos, 10 por defecto)
params ["_id", "_pos", "_txt"];
private _m = createMarkerLocal [_id, _pos];
_m setMarkerTypeLocal "mil_warning";
_m setMarkerColorLocal "ColorRed";
_m setMarkerTextLocal _txt;
[_id] spawn {params ["_id"]; sleep (60 * ((["pdaMarkMin", 10] call ADVSEC_fnc_setting) max 1)); deleteMarkerLocal _id};
hint parseText format [("STR_ADVSEC_m_tac_received" call ADVSEC_fnc_L), _txt];
