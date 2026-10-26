// [radar, aviso] — destello y disparo de la cámara (cliente); el conductor multado recibe el aviso
params ["_cam", ["_msg", ""]];
// Al conductor: fogonazo blanco en pantalla, como el flash de un radar
if (_msg isNotEqualTo "") then {
    ("advsec_flash" call BIS_fnc_rscLayer) cutText ["", "WHITE IN", 0.9];
    hint parseText _msg;
};
if (isNull _cam) exitWith {};
private _l = "#lightpoint" createVehicleLocal (getPosATL _cam vectorAdd [0, 0, 1.2]);
_l setLightColor [1, 1, 1];
_l setLightAmbient [1, 1, 1];
_l setLightBrightness 6;
_l setLightAttenuation [0, 0, 0, 1.2];
playSound3D ["a3\sounds_f\sfx\beep_target.wss", _cam, false, getPosASL _cam, 1.5, 1.4, 120];
[_l] spawn {sleep 0.12; deleteVehicle (_this select 0)};
