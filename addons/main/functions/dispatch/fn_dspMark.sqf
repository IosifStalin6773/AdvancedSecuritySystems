// [id, posición, pánico] (cliente): marcador local que se borra a los 10 min
params ["_id", "_pos", ["_panic", false]];
private _m = "advsec_dsp_" + _id;
deleteMarkerLocal _m;
createMarkerLocal [_m, _pos];
_m setMarkerTypeLocal (["mil_warning", "mil_objective"] select _panic);
_m setMarkerColorLocal (["ColorOrange", "ColorRed"] select _panic);
_m setMarkerTextLocal format ["%1 %2", ["112", "PÁNICO"] select _panic, _id];
[_m] spawn {sleep 600; deleteMarkerLocal (_this select 0)};
