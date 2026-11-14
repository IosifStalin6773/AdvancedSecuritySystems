disableSerialization;params ['_event','_args'];private _s=uiNamespace getVariable ['TSL_camera',createHashMap];
if (isNull (_s getOrDefault ['camera',objNull])) exitWith {false};
if (_event=='keyUp' && {(_args select 1)==33}) then {_s set ['quickHeld',false];};
if ((uiNamespace getVariable ['TSL_themeState',createHashMap]) getOrDefault ['active',false]) exitWith {if (_event=='keyDown' && {(_args select 1)==1}) then {['close'] call TSL_fnc_themeUI;true} else {false}};
private _presets=uiNamespace getVariable ['TSL_presets',createHashMap];if (_presets getOrDefault ['active',false]) exitWith {if (_event=='keyDown' && {(_args select 1)==1}) then {['close'] call TSL_fnc_presetUI;true} else {false}};
private _e=uiNamespace getVariable ['TSL_editor',createHashMap];private _editing=_e getOrDefault ['active',false];
if (_editing && {_e getOrDefault ['objectsOpen',false]} && {_event=='keyDown'} && {(_args select 1)==1}) exitWith {['close'] call TSL_fnc_editorObjects;true};
if (_editing && {_e getOrDefault ['catalogOpen',false]} && {_event=='keyDown'} && {(_args select 1)==1}) exitWith {['close'] call TSL_fnc_editorCatalogUI;true};
private _focus=focusedCtrl (findDisplay 78150);if (_editing && {!isNull _focus} && {ctrlType _focus==2} && {ctrlShown _focus} && {_event in ['keyDown','keyUp']}) exitWith {false};
if (_event=='down' && {(_args select 1)==0} && {_s getOrDefault ['sceneLMB',false]}) exitWith {true};
if (_event=='down' && {(_args select 1)==0}) then {
 if !(_s getOrDefault ['sceneLMB',false]) then {_s set ['sceneLMB',[] call TSL_fnc_editorViewport];};
};
if (_event=='up' && {(_args select 1)==0} && {!(_s getOrDefault ['sceneLMB',false])}) exitWith {false};
if (_event=='up' && {(_args select 1)==0}) then {_s set ['sceneLMB',false];};
if (_event=='down' && {(_s getOrDefault ['buttonFrame',[]]) isEqualTo [diag_frameNo,_args select 1]}) exitWith {true};if (_event=='down') then {_s set ['buttonFrame',[diag_frameNo,_args select 1]];};
if (_editing && {_event in ['down','up']}) then {[_event,_args] call TSL_fnc_editorInput;};
if (_editing && {_event=='keyDown'} && {(_args select 1)==1} && {_e getOrDefault ['dragging',false]}) exitWith {['escape'] call TSL_fnc_editorInput;true};
if (_editing && {!(_e getOrDefault ['catalogOpen',false])} && {!(_e getOrDefault ['objectsOpen',false])} && {_event=='keyDown'} && {(_args select 1) in [20,21,34]}) exitWith {[if ((_args select 1)==20) then {'move'} else {if ((_args select 1)==21) then {'rotate'} else {'scale'}}] call TSL_fnc_editorUI;true};
if (_event=='keyUp' && {(_args select 1)==33}) then {_s set ['quickHeld',false];};
if (!_editing && {_event=='keyDown'} && {(_args select 1)==33} && {!(_s getOrDefault ['options',false])}) exitWith {if !(_s getOrDefault ['quickHeld',false]) then {_s set ['quickHeld',true];diag_log '[TS Lockers Input] F received';['quick'] call TSL_fnc_useUI;};true};
private _keys=_s get 'keys';private _move=[17,30,31,32,16,18,42,54,29,157];
switch _event do {
 case 'keyDown': {private _key=_args select 1;if (_key in _move) then {_keys pushBackUnique _key;};if (_key==19) then {['reset',[]] call TSL_fnc_cameraInput;};};
 case 'keyUp': {private _index=_keys find (_args select 1);if (_index>=0) then {_keys deleteAt _index;};};
 case 'wheel': {if (([] call TSL_fnc_editorViewport)) then {_s set ['fov',((_s get 'fov')-(_args select 1)*.045) max .12 min 1.2];};};
 case 'down': {if (((_args select 1)==1 || {(_args select 1)==0 && {_s getOrDefault ['cameraMode',false]}}) && {([] call TSL_fnc_editorViewport)}) then {_s set ['drag',true];_s set ['mouse',getMousePosition];};};
 case 'up': {
  if ((_args select 1)==1 || {(_args select 1)==0 && {_s getOrDefault ['cameraMode',false]}}) then {_s set ['drag',false];};
  if (!_editing && {(_args select 1)==0} && {([] call TSL_fnc_editorViewport)}) then {
   _s set ['inputReleaseCount',(_s getOrDefault ['inputReleaseCount',0])+1];diag_log '[TS Lockers Input] LMB release received';['pick'] call TSL_fnc_useUI;
  };
 };
 case 'reset': {private _l=_s get 'locker';_s set ['position',_l modelToWorld [-.1,-2.8,1.15]];(_s get 'camera') setPosATL (_s get 'position');_s set ['yaw',getDir _l];_s set ['pitch',0];_s set ['fov',.75];_s set ['keys',[]];};
};
(_event in ['keyDown','keyUp']) && {(_args select 1) in (_move+[19])}
