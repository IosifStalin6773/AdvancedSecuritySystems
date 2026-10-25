// [objetoCámara, nombre, inclinación (grados, negativo = abajo), giro extra, red]
params ["_cam", ["_name", ""], ["_pitch", -15], ["_yaw", 0], ["_network", "default"]];
if (isServer && {!(call ADVSEC_fnc_trustedInit)}) exitWith {};
if (isNull _cam) exitWith {};
if (_name isEqualTo "") then {_name = vehicleVarName _cam};
if (isServer) then {[_cam, "camera", _name, _network] call ADVSEC_fnc_register};
_cam setVariable ["ADVSEC_camName", _name];
_cam setVariable ["ADVSEC_camPitch", _pitch];
_cam setVariable ["ADVSEC_camYaw", _yaw];
_cam setVariable ["ADVSEC_camNet", _network];
ADVSEC_camRegistry pushBackUnique _cam;
