private _e=uiNamespace getVariable ['TSL_editor',createHashMap];if !(_e getOrDefault ['active',false]) exitWith {};
{if !(_x getVariable ['TSL_cameraKeys',false]) then {_x setVariable ['TSL_cameraKeys',true];_x ctrlAddEventHandler ['KeyDown',{['keyDown',_this] call TSL_fnc_cameraInput}];_x ctrlAddEventHandler ['KeyUp',{['keyUp',_this] call TSL_fnc_cameraInput}];};} forEach allControls (findDisplay 78150);
['frame'] call TSL_fnc_editorPreview;
if (diag_tickTime>(_e getOrDefault ['statusAt',0])) then {
 _e set ['statusAt',diag_tickTime+.5];disableSerialization;private _d=findDisplay 78150;private _ru=(profileNamespace getVariable ['TSL_uiLanguage','en'])=='ru';
 if (_e getOrDefault ['catalogOpen',false]) then {['status'] call TSL_fnc_editorCatalogUI;};
 [] call TSL_fnc_editorChrome;
};
if (diag_tickTime>(_e getOrDefault ['refreshAt',0])) then {[] call TSL_fnc_editorRefresh;_e set ['refreshAt',diag_tickTime+.2];};
private _s=uiNamespace getVariable ['TSL_camera',createHashMap];private _l=_s get 'locker';
if (diag_tickTime>(_e getOrDefault ['hoverAt',0])) then {
 _e set ['hoverAt',diag_tickTime+.08];private _hover=[];
 if ([] call TSL_fnc_editorViewport && {!(_s getOrDefault ['drag',false])} && {!(_e getOrDefault ['dragging',false])} && {!(_e getOrDefault ['catalogOpen',false])} && {!(_e getOrDefault ['objectsOpen',false])}) then {
  private _pool=_e getOrDefault ['proxies',[]];if (_e getOrDefault ['selectionLocked',true]) then {_pool=_pool select {(_x select 0)==(_e getOrDefault ['selected',''])};};
  _hover=[_pool,AGLToASL positionCameraToWorld [0,0,0],screenToWorldDirection getMousePosition,getMousePosition,_l] call TSL_fnc_editorPick;
 };_e set ['hover',_hover];
};
private _o=_e getOrDefault ['ghost',objNull];if (isNull _o) exitWith {};
if (_e getOrDefault ['dragging',false]) then {
 // Freeze the item during navigation and rebuild its drag plane at the new view.
 if ((_s getOrDefault ['navigating',false]) || {_e getOrDefault ['navigationPaused',false]}) exitWith {
  private _bb=[_o] call TSL_fnc_editorBounds;private _centre=((_bb select 0) vectorAdd (_bb select 1)) vectorMultiply .5;if ((_e get 'mode')=='POINT') then {private _offset=_o getVariable ['TSL_interactionOffset',[]];if (_offset isNotEqualTo []) then {_centre=_offset;};};private _pivot=AGLToASL (_o modelToWorld _centre);private _normal=vectorDir (_s get 'camera');private _origin=AGLToASL positionCameraToWorld [0,0,0];private _ray=screenToWorldDirection getMousePosition;private _den=_ray vectorDotProduct _normal;private _point=_pivot;
  if (abs _den>.00001) then {_point=_origin vectorAdd (_ray vectorMultiply (((_pivot vectorDiff _origin) vectorDotProduct _normal)/_den));};
  _e set ['dragData',[[_l,_o] call TSL_fnc_editorPose,getMousePosition,_pivot,_normal,_point,_centre]];_e set ['navigationPaused',_s getOrDefault ['navigating',false]];
 };

 (_e get 'dragData') params ['_pose','_mouse0','_pivot','_normal','_point0','_centre'];private _mouse=getMousePosition;
 private _fine=if (42 in (_s get 'keys') || {54 in (_s get 'keys')}) then {.15} else {1};
 private _mode=_e getOrDefault ['dragMode',_e get 'mode'];private _axis=_e getOrDefault ['dragAxis',_e get 'axis'];private _index=['X','Y','Z'] find _axis;private _worldAxis=if (_index<0) then {_normal} else {_l vectorModelToWorld ([[1,0,0],[0,1,0],[0,0,1]] select _index)};
 if (_mode=='SCALE') then {
  private _factor=exp ((((_mouse select 0)-(_mouse0 select 0))-((_mouse select 1)-(_mouse0 select 1)))*3*_fine);[_l,_o,(_pose param [3,1])*_factor,_pivot] call TSL_fnc_editorScale;
 } else {
 if (_mode in ['MOVE','POINT']) then {
  private _origin=AGLToASL positionCameraToWorld [0,0,0];private _ray=screenToWorldDirection _mouse;private _den=_ray vectorDotProduct _normal;
  if (abs _den>.0001) then {private _point=_origin vectorAdd (_ray vectorMultiply (((_pivot vectorDiff _origin) vectorDotProduct _normal)/_den));private _delta=(_point vectorDiff _point0) vectorMultiply _fine;
   if (_index>=0) then {private _a=worldToScreen ASLToAGL _pivot;private _b=worldToScreen ASLToAGL (_pivot vectorAdd _worldAxis);if (count _a==2 && {count _b==2}) then {private _dx=(_b select 0)-(_a select 0);private _dy=(_b select 1)-(_a select 1);private _len=_dx*_dx+_dy*_dy;if (_len>.00001) then {_delta=_worldAxis vectorMultiply ((((_mouse select 0)-(_mouse0 select 0))*_dx+((_mouse select 1)-(_mouse0 select 1))*_dy)/_len*_fine);} else {_delta=[0,0,0];};};};
   if (_index>=0) then {private _alignment=abs (_worldAxis vectorDotProduct _normal);if (_alignment>.97) then {_delta=_worldAxis vectorMultiply (-((_mouse select 1)-(_mouse0 select 1))*((_origin distance _pivot) max .5)*2*_fine);};};
   if (_mode=='POINT') then {_o setVariable ['TSL_interactionOffset',_o worldToModel (ASLToAGL (_pivot vectorAdd _delta))];} else {
   private _p=(_pose select 0) vectorAdd (_l vectorWorldToModel _delta);if (vectorMagnitude _p<3.8) then {[_l,_o,[_p,_pose select 1,_pose select 2,_pose param [3,1]]] call TSL_fnc_editorPose;};
   };
  };
 } else {
  private _angle=(((_mouse select 0)-(_mouse0 select 0))-((_mouse select 1)-(_mouse0 select 1)))*300*_fine;
  private _localAxis=vectorNormalized (_l vectorWorldToModel _worldAxis);
  private _rotated=[_pose,_localAxis,_angle,_centre] call TSL_fnc_editorRotatePose;
  [_l,_o,_rotated] call TSL_fnc_editorPose;
 };
};
};
disableSerialization;private _d=findDisplay 78150;(_d displayCtrl 78200) ctrlSetText ((_e getOrDefault ['label',''])+' | '+(_e get 'mode')+' '+(_e get 'axis'));
