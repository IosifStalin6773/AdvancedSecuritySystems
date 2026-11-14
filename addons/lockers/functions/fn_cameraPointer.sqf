// Recover press/release edges independently of GUI mouse capture.
params [['_pressed',inputMouse 0>0]];
private _s=uiNamespace getVariable ['TSL_camera',createHashMap];if (isNull (_s getOrDefault ['camera',objNull])) exitWith {};
private _previous=_s getOrDefault ['pointerLMB',false];_s set ['pointerLMB',_pressed];
private _modal=((uiNamespace getVariable ['TSL_themeState',createHashMap]) getOrDefault ['active',false]) || {(uiNamespace getVariable ['TSL_presets',createHashMap]) getOrDefault ['active',false]};
if (_modal) exitWith {_s set ['sceneLMB',false];_s set ['drag',false];};
if (_pressed && {!_previous}) then {['down',[findDisplay 78150,0]] call TSL_fnc_cameraInput;};
if (!_pressed && {_previous || {_s getOrDefault ['sceneLMB',false]}}) then {['up',[findDisplay 78150,0]] call TSL_fnc_cameraInput;};
