params [["_delta", 0]];
if (isNil "ADVSEC_camObj") exitWith {};
private _n = count ADVSEC_camList;
ADVSEC_camIdx = (ADVSEC_camIdx + _delta + _n) % _n;
private _src = ADVSEC_camList select ADVSEC_camIdx;

private _p = _src getVariable ["ADVSEC_camPitch", -15];
private _dir = getDir _src + (_src getVariable ["ADVSEC_camYaw", 0]);
private _pos = _src modelToWorldVisual [0, 0.3, 0.15];
ADVSEC_camObj camSetPos _pos;
ADVSEC_camObj camSetTarget (_pos vectorAdd [sin _dir * cos _p * 50, cos _dir * cos _p * 50, sin _p * 50]);
ADVSEC_camObj camCommit 0;
camUseNVG (ADVSEC_camNV == 1);
(ADVSEC_camNV == 2) setCamUseTI 0;

private _hud = uiNamespace getVariable ["ADVSEC_camHUD", displayNull];
if (isNull _hud) exitWith {};
(_hud displayCtrl 4104) ctrlShow (!alive _src);
(_hud displayCtrl 4101) ctrlSetText format ["CAM %1/%2  %3", ADVSEC_camIdx + 1, _n, _src getVariable ["ADVSEC_camName", "CCTV"]];
(_hud displayCtrl 4102) ctrlSetText format ["%1  %2", [dayTime, "HH:MM:SS"] call BIS_fnc_timeToString, ["", "NV", "TI"] select ADVSEC_camNV];
private _active = ADVSEC_alarms select {_x getVariable ["ADVSEC_active", false]};
(_hud displayCtrl 4103) ctrlSetText (
    if (_active isEqualTo []) then {""} else {"ALARMA: " + ((_active apply {_x getVariable ["ADVSEC_alarmName", "?"]}) joinString ", ")}
);
