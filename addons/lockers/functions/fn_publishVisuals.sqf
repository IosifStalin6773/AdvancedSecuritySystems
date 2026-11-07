params ['_l'];
if (!isServer || {isNull _l}) exitWith {};
if !(_l isKindOf 'Land_TS_Locker_F') exitWith {};
if (isRemoteExecuted && {diag_tickTime<(_l getVariable ['TSL_syncRequestAfter',0])}) exitWith {};
if (isRemoteExecuted) then {_l setVariable ['TSL_syncRequestAfter',diag_tickTime+2];};
private _simple=[];private _network=[];
private _objects=[];
{_objects append (_l getVariable [_x,[]]);} forEach ['TSL_visuals','TSL_extraObjects','TSL_decor','TSL_clamps','TSL_panels','TSL_editorObjects'];
{
 if (!isNull _x) then {
  _x setVariable ['TSL_locker',_l];
  private _pose=[getPosWorld _x,vectorNormalized vectorDir _x,vectorNormalized vectorUp _x,getObjectScale _x];
  if (isSimpleObject _x || {_x getVariable ['TSL_localDisplay',false]}) then {
   _simple pushBack [(getModelInfo _x) select 1,_pose,getObjectTextures _x,getObjectMaterials _x,_x getVariable ['TSL_editKey',''],_x getVariable ['TSL_editSlot',-1],_x getVariable ['TSL_editBase',[]],_x getVariable ['TSL_editLabel',''],_x getVariable ['TSL_editorHidden',false],_x getVariable ['TSL_assetRef','']];
  } else {_network pushBack [_x,_pose];};
 };
} forEach (_objects arrayIntersect _objects);
private _state=[_simple,_network];private _key=str _state;
if (isRemoteExecuted || {_key!=(_l getVariable ['TSL_visualStateKey',''])}) then {
 _l setVariable ['TSL_visualStateKey',_key];
 _l setVariable ['TSL_visualState',_state,true];
};
