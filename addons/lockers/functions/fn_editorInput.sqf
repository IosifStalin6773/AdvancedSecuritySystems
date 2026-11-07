params ['_command',['_args',[]]];private _e=uiNamespace getVariable ['TSL_editor',createHashMap];if !(_e getOrDefault ['active',false]) exitWith {false};
private _s=uiNamespace getVariable ['TSL_camera',createHashMap];private _l=_s getOrDefault ['locker',objNull];
switch _command do {
 case 'checkpoint': {private _h=_e get 'undo';_h pushBack parseSimpleArray str [_e get 'poses',_e get 'added'];if (count _h>30) then {_h deleteAt 0;};};
 case 'cancel': { {if (!isNull _x) then {_x hideObject (_x getVariable ['TSL_editorHidden',false]);};} forEach (_e getOrDefault ['removedSources',[]]);_e set ['removedSources',[]];
  {deleteVehicle (_x select 1);private _source=_x select 2;if (!isNull _source) then {_source hideObject (_source getVariable ['TSL_editorHidden',_x select 6]);};} forEach (_e getOrDefault ['proxies',[]]);
  private _ghost=_e getOrDefault ['ghost',objNull];if (!isNull _ghost) then {deleteVehicle _ghost;};
  _e set ['proxies',[]];_e set ['selected',''];_e set ['ghost',objNull];_e set ['source',objNull];_e set ['dragging',false];
 };
 case 'finish': {
  if (_e getOrDefault ['dragging',false]) then {
   private _key=_e get 'selected';private _ghost=_e getOrDefault ['ghost',objNull];
   if (!isNull _ghost) then {private _pose=[_l,_ghost] call TSL_fnc_editorPose;private _poses=_e get 'poses';private _i=_poses findIf {(_x select 0)==_key};if (_i<0) then {_poses pushBack [_key,_pose]} else {_poses set [_i,[_key,_pose]];};};
  };_e set ['dragging',false];
 };
 case 'escape': {
  if (_e getOrDefault ['dragging',false]) then {private _o=_e get 'ghost';private _start=_e getOrDefault ['dragStartPose',(_e get 'dragData') select 0];_o setVariable ['TSL_interactionOffset',_start param [4,[]]];[_l,_o,_start] call TSL_fnc_editorPose;_e set ['dragging',false];private _h=_e get 'undo';if (count _h>0) then {_h deleteAt (count _h-1);};};
 };
 case 'down': {
  if (_e getOrDefault ['dragging',false]) exitWith {};
  if (_e getOrDefault ['pending',false] || {_s getOrDefault ['cameraMode',false]} || {_s getOrDefault ['drag',false]}) exitWith {};
  if ((_args select 1)!=0 || {!([] call TSL_fnc_editorViewport)} || {_e getOrDefault ['catalogOpen',false]} || {_e getOrDefault ['objectsOpen',false]}) exitWith {};
  [] call TSL_fnc_editorRefresh;private _origin=AGLToASL positionCameraToWorld [0,0,0];private _ray=screenToWorldDirection getMousePosition;private _locked=_e getOrDefault ['selectionLocked',true];private _best=[];if (_locked) then {private _i=(_e get 'proxies') findIf {(_x select 0)==(_e get 'selected') && {!isObjectHidden (_x select 1)}};if (_i>=0) then {_best=[[(_e get 'proxies') select _i],_origin,_ray,getMousePosition,_l] call TSL_fnc_editorPick;};} else {_best=[_e getOrDefault ['proxies',[]],_origin,_ray,getMousePosition,_l] call TSL_fnc_editorPick;};
  private _selected=_e getOrDefault ['selected',''];private _selectedIndex=(_e getOrDefault ['proxies',[]]) findIf {(_x select 0)==_selected};
  if ((_best isEqualTo [] || {(_best select 0)==_selected}) && {_selectedIndex>=0} && {!isObjectHidden (((_e get 'proxies') select _selectedIndex) select 1)}) then {
   private _record=(_e get 'proxies') select _selectedIndex;private _object=_record select 1;private _box=[_object] call TSL_fnc_editorBounds;private _mid=((_box select 0) vectorAdd (_box select 1)) vectorMultiply .5;private _off=_object getVariable ['TSL_interactionOffset',[]];private _pivot=_object modelToWorld (if ((_e get 'mode')=='POINT' && {_off isNotEqualTo []}) then {_off} else {_mid});private _mouse=getMousePosition;private _axes=[[1,0,0],[0,1,0],[0,0,1]];private _closest=.014;private _chosen=-1;
   {
    private _i=_forEachIndex;
    if ((_e get 'mode') in ['MOVE','POINT','SCALE']) then {
     private _a=worldToScreen _pivot;private _b=worldToScreen (_pivot vectorAdd ((_l vectorModelToWorld _x) vectorMultiply .42));
     if (count _a==2 && {count _b==2}) then {private _dx=(_b select 0)-(_a select 0);private _dy=(_b select 1)-(_a select 1);private _len=_dx*_dx+_dy*_dy;if (_len>.00001) then {private _t=(((_mouse select 0)-(_a select 0))*_dx+((_mouse select 1)-(_a select 1))*_dy)/_len;if (_t>.25 && {_t<1.15}) then {private _d=_mouse distance2D [(_a select 0)+_t*_dx,(_a select 1)+_t*_dy];if (_d<_closest) then {_closest=_d;_chosen=_i;};};};};
    } else {
     private _a=_l vectorModelToWorld (_axes select ((_i+1) mod 3));private _b=_l vectorModelToWorld (_axes select ((_i+2) mod 3));
     for '_angle' from 0 to 355 step 5 do {private _screen=worldToScreen ((_pivot vectorAdd (_a vectorMultiply (.32*cos _angle))) vectorAdd (_b vectorMultiply (.32*sin _angle)));if (count _screen==2) then {private _d=_screen distance2D _mouse;if (_d<_closest) then {_closest=_d;_chosen=_i;};};};
    };
   } forEach _axes;
   if (_chosen>=0) then {_best=_record;_e set ['axis',['X','Y','Z'] select _chosen];disableSerialization;((findDisplay 78150) displayCtrl 78203) ctrlSetText ('AXIS / ОСЬ: '+(_e get 'axis'));};
  };
  if ((_e get 'mode')=='POINT' && {_selectedIndex>=0}) then {private _r=(_e get 'proxies') select _selectedIndex;private _ob=_r select 1;private _bb=[_ob] call TSL_fnc_editorBounds;private _offset=_ob getVariable ['TSL_interactionOffset',((_bb select 0) vectorAdd (_bb select 1)) vectorMultiply .5];if (_offset isEqualTo []) then {_offset=((_bb select 0) vectorAdd (_bb select 1)) vectorMultiply .5;};private _screen=worldToScreen (_ob modelToWorld _offset);if (count _screen==2 && {_screen distance2D getMousePosition<.025}) then {_best=_r;};};
  if (_best isEqualTo []) exitWith {};
  _best params ['_key','_o','_source','_base','_slot','_label'];_e set ['selected',_key];_e set ['ghost',_o];_e set ['source',_source];_e set ['label',_label];
  if (_key!=_selected) exitWith {[] call TSL_fnc_editorChrome;};
  ['checkpoint'] call TSL_fnc_editorInput;private _bb=[_o] call TSL_fnc_editorBounds;private _centre=((_bb select 0) vectorAdd (_bb select 1)) vectorMultiply .5;if ((_e get 'mode')=='POINT') then {private _offset=_o getVariable ['TSL_interactionOffset',[]];if (_offset isNotEqualTo []) then {_centre=_offset;};};private _pivot=AGLToASL (_o modelToWorld _centre);
  private _normal=vectorDir (_s get 'camera');private _den=_ray vectorDotProduct _normal;private _point=_pivot;if (abs _den>.00001) then {_point=_origin vectorAdd (_ray vectorMultiply (((_pivot vectorDiff _origin) vectorDotProduct _normal)/_den));};
  _e set ['dragMode',_e get 'mode'];_e set ['dragAxis',_e get 'axis'];_e set ['rotationLastAngle',0];_e set ['rotationTotalAngle',0];
  _e set ['dragStartPose',[_l,_o] call TSL_fnc_editorPose];_e set ['navigationPaused',false];
  _e set ['dragData',[[_l,_o] call TSL_fnc_editorPose,getMousePosition,_pivot,_normal,_point,_centre]];_e set ['dragging',true];
 };
 case 'up': {if ((_args select 1)==0) then {['finish'] call TSL_fnc_editorInput;};};
};true
