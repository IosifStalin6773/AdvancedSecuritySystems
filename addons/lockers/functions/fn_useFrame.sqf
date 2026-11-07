private _s=uiNamespace getVariable ['TSL_camera',createHashMap];if !(_s getOrDefault ['useMode',false]) exitWith {};
if ((uiNamespace getVariable ['TSL_editor',createHashMap]) getOrDefault ['active',false]) exitWith {};
private _l=_s getOrDefault ['locker',objNull];if (isNull _l || {(_l getVariable ['TSL_owner',''])!=getPlayerUID player}) exitWith {};
if (diag_tickTime<(_s getOrDefault ['useAt',0])) exitWith {};_s set ['useAt',diag_tickTime+.1];
{if !(_x getVariable ['TSL_quickBound',false]) then {_x setVariable ['TSL_quickBound',true];_x ctrlAddEventHandler ['KillFocus',{private _s=uiNamespace getVariable ['TSL_camera',createHashMap];_s set ['quickHeld',false];_s set ['keys',[]];}];_x ctrlAddEventHandler ['KeyDown',{if ((_this select 1) in [33,17,30,31,32,16,18,42,54,29,157,19]) then {['keyDown',_this] call TSL_fnc_cameraInput} else {false}}];_x ctrlAddEventHandler ['KeyUp',{if ((_this select 1) in [33,17,30,31,32,16,18,42,54,29,157,19]) then {['keyUp',_this] call TSL_fnc_cameraInput} else {false}}];};} forEach allControls (findDisplay 78150);
private _rows=[_l] call TSL_fnc_useTargets;_s set ['useTargets',_rows];private _hover=[];
if ([] call TSL_fnc_editorViewport && {!(_s getOrDefault ['drag',false])}) then {
 private _proxies=[];{private _row=_x;{if (!isNull _x && {!isObjectHidden _x}) then {_proxies pushBack [_row select 0,_x,objNull,[],-1,_row select 3,false];};} forEach (_row param [6,[_row select 5]]);} forEach _rows;
 private _hit=[_proxies,AGLToASL positionCameraToWorld [0,0,0],screenToWorldDirection getMousePosition,getMousePosition,_l] call TSL_fnc_editorPick;
 if (_hit isNotEqualTo []) then {private _i=_rows findIf {(_x select 0)==(_hit select 0)};if (_i>=0) then {_hover=_rows select _i;};} else {
  private _best=24;{private _screen=worldToScreen (_x select 4);if (count _screen==2) then {private _dx=((_screen select 0)-(getMousePosition select 0))/pixelW;private _dy=((_screen select 1)-(getMousePosition select 1))/pixelH;private _dist=sqrt (_dx*_dx+_dy*_dy);if (_dist<_best) then {_best=_dist;_hover=_x;};};} forEach _rows;
 };
};_s set ['useHover',_hover];
private _revision=str [_l getVariable ['TSL_menuRevision',0],_l getVariable ['TSL_editorRevision',0],_l getVariable ['TSL_busy',false]];
if (_revision!=(_s getOrDefault ['useRevision',''])) then {_s set ['useRevision',_revision];if !(_s getOrDefault ['options',false]) then {['refresh'] call TSL_fnc_useUI;};};
