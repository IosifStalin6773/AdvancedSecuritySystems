// [id, posición, texto] (cliente): marca táctica compartida durante 10 minutos
params ["_id", "_pos", "_txt"];
private _m = createMarkerLocal [_id, _pos];
_m setMarkerTypeLocal "mil_warning";
_m setMarkerColorLocal "ColorRed";
_m setMarkerTextLocal _txt;
[_id] spawn {params ["_id"]; sleep 600; deleteMarkerLocal _id};
hint parseText format [("STR_ADVSEC_m_tac_received" call ADVSEC_fnc_L), _txt];
