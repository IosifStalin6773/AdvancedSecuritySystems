private _s=uiNamespace getVariable ['TSL_camera',createHashMap];private _cam=_s getOrDefault ['camera',objNull];private _l=_s getOrDefault ['locker',objNull];
if (isNull _cam) exitWith {};
if (isNull findDisplay 78150 || {isNull _l} || {!alive player} || {player distance _l>3.5}) exitWith {if (!isNull findDisplay 78150) then {closeDialog 0;};[] call TSL_fnc_cameraStop;};
private _now=diag_tickTime;private _dt=(_now-(_s get 'last')) max 0 min .05;_s set ['last',_now];
[] call TSL_fnc_cameraPointer;
private _mouse=getMousePosition;
private _e=uiNamespace getVariable ['TSL_editor',createHashMap];
private _modal=((uiNamespace getVariable ['TSL_themeState',createHashMap]) getOrDefault ['active',false]) || {(uiNamespace getVariable ['TSL_presets',createHashMap]) getOrDefault ['active',false]};
// A pressed UI button can capture mouse events; poll RMB as a fallback.
if (!_modal && {([_mouse] call TSL_fnc_editorViewport)} && {inputMouse 1>0}) then {
 if !(_s getOrDefault ['drag',false]) then {_s set ['mouse',_mouse];};_s set ['drag',true];_s set ['physicalRMB',true];
} else {if (_s getOrDefault ['physicalRMB',false]) then {_s set ['physicalRMB',false];_s set ['drag',false];};};
if (_modal) then {_s set ['drag',false];_s set ['keys',[]];};

if (_s get 'drag') then {private _old=_s get 'mouse';_s set ['yaw',(_s get 'yaw')+((_mouse select 0)-(_old select 0))*160];_s set ['pitch',((_s get 'pitch')-((_mouse select 1)-(_old select 1))*120) max -89 min 89];};
_s set ['mouse',_mouse];
private _yaw=_s get 'yaw';private _pitch=_s get 'pitch';private _forward=[sin _yaw*cos _pitch,cos _yaw*cos _pitch,sin _pitch];private _right=[cos _yaw,-sin _yaw,0];
private _keys=_s get 'keys';private _speed=1.0;if (42 in _keys || {54 in _keys}) then {_speed=2.8;};if (29 in _keys || {157 in _keys}) then {_speed=.2;};
private _delta=[0,0,0];
{_x params ['_key','_direction'];if (_key in _keys) then {_delta=_delta vectorAdd _direction;};} forEach [[17,_forward],[31,_forward vectorMultiply -1],[32,_right],[30,_right vectorMultiply -1],[16,[0,0,1]],[18,[0,0,-1]]];
if (vectorMagnitude _delta>0) then {private _pos=(_s getOrDefault ['position',getPosATL _cam]) vectorAdd ((vectorNormalized _delta) vectorMultiply (_speed*_dt));private _centre=_l modelToWorld [0,0,1];private _offset=_pos vectorDiff _centre;if (vectorMagnitude _offset>8) then {_pos=_centre vectorAdd ((vectorNormalized _offset) vectorMultiply 8);};_pos set [2,(_pos select 2) max .08];_s set ['position',_pos];};
private _position=_s getOrDefault ['position',getPosATL _cam];
if (_s getOrDefault ['restoreView',false]) then {_cam switchCamera 'INTERNAL';_s set ['restoreView',false];};
_cam camSetPos _position;_cam camSetTarget (_position vectorAdd (_forward vectorMultiply 10));_cam camSetFov (_s get 'fov');_cam camCommit 0;
_cam setPosATL _position;_cam setVectorDirAndUp [_forward,[-sin _yaw*sin _pitch,-cos _yaw*sin _pitch,cos _pitch]];
_s set ['navigating',(_s getOrDefault ['cameraMode',false]) || {_s get 'drag'} || {vectorMagnitude _delta>0}];
[] call TSL_fnc_editorFrame;
if (_e getOrDefault ['active',false]) then {[] call TSL_fnc_editorDraw;};[] call TSL_fnc_useFrame;

if (diag_tickTime>(_s getOrDefault ['themeAfter',0])) then {_s set ['themeAfter',diag_tickTime+.25];[findDisplay 78150] call TSL_fnc_theme;};

