private _e=uiNamespace getVariable ['TSL_editor',createHashMap];if !(_e getOrDefault ['active',false]) exitWith {};
private _l=(uiNamespace getVariable ['TSL_camera',createHashMap]) getOrDefault ['locker',objNull];if (isNull _l) exitWith {};
private _proxies=_e getOrDefault ['proxies',[]];
private _sources=if (isServer) then {(_l getVariable ['TSL_slotObjects',[]])+(_l getVariable ['TSL_extraObjects',[]])+(_l getVariable ['TSL_editorObjects',[]])+(_l getVariable ['TSL_decor',[]])+(_l getVariable ['TSL_panels',[]])+(_l getVariable ['TSL_clamps',[]])} else {(_l getVariable ['TSL_clientVisuals',[]])+(((_l getVariable ['TSL_visualState',[[],[]]]) select 1) apply {_x select 0})};
private _wanted=[];
{
 private _source=_x;private _key=_source getVariable ['TSL_editKey',''];
 if (!isNull _source && {_key select [0,6]=='added_'} && {((_e get 'added') findIf {(_x select 0)==_key})<0}) then {
  private _removed=_e getOrDefault ['removedSources',[]];_removed pushBackUnique _source;_e set ['removedSources',_removed];_source hideObject true;
 };

 if (!isNull _source && {_key!=''} && {_key select [0,6]!='added_' || {((_e get 'added') findIf {(_x select 0)==_key})>=0}}) then {
  _wanted pushBack _key;private _i=_proxies findIf {(_x select 0)==_key};
  if (_i<0) then {
   private _model=(getModelInfo _source) select 1;private _ghost=objNull;
   private _weapons=weaponsItemsCargo _source;
   if (_source isKindOf 'GroundWeaponHolder' || {_source isKindOf 'GroundWeaponHolder_Scripted'} || {_weapons isNotEqualTo []} || {(itemCargo _source) isNotEqualTo []}) then {
    _ghost=createVehicleLocal [typeOf _source,[0,0,-1000],[],0,'CAN_COLLIDE'];clearWeaponCargo _ghost;clearMagazineCargo _ghost;clearItemCargo _ghost;clearBackpackCargo _ghost;
    {_ghost addWeaponWithAttachmentsCargo [_x,1]} forEach _weapons;
    {_ghost addItemCargo [_x,1]} forEach itemCargo _source;
    {_ghost addMagazineAmmoCargo [_x select 0,1,_x select 1]} forEach magazinesAmmoCargo _source;
    _ghost lockInventory true;
   } else {private _ref=_source getVariable ['TSL_assetRef',''];_ghost=if (_ref!='') then {[_ref] call TSL_fnc_editorSpawn} else {createSimpleObject [_model,[0,0,-1000],true]};};
   {_ghost setObjectTexture [_forEachIndex,_x]} forEach getObjectTextures _source;{_ghost setObjectMaterial [_forEachIndex,_x]} forEach getObjectMaterials _source;
   _ghost setVariable ['TSL_editorGhost',true];_ghost hideSelection ['zasleh',true];_ghost enableSimulation false;_ghost allowDamage false;_ghost disableCollisionWith _l;
   private _pose=[_l,_source] call TSL_fnc_editorPose;private _base=_source getVariable ['TSL_editBase',_pose];
   _proxies pushBack [_key,_ghost,_source,_base,_source getVariable ['TSL_editSlot',-1],_source getVariable ['TSL_editLabel',_key],isObjectHidden _source];
   private _pi=(_e get 'poses') findIf {(_x select 0)==_key};if (_pi>=0) then {_pose=((_e get 'poses') select _pi) select 1;};[_l,_ghost,_pose] call TSL_fnc_editorPose;
  };
  _source hideObject true;
 };
} forEach _sources;
{
 _x params ['_key','_model','_pose'];_wanted pushBackUnique _key;
 if ((_proxies findIf {(_x select 0)==_key})<0) then {private _o=[_model] call TSL_fnc_editorSpawn;private _pi=(_e get 'poses') findIf {(_x select 0)==_key};if (_pi>=0) then {_pose=((_e get 'poses') select _pi) select 1;};_o setVariable ['TSL_editorGhost',true];[_l,_o,_pose] call TSL_fnc_editorPose;_proxies pushBack [_key,_o,objNull,_pose,-1,_model,false];};
} forEach (_e get 'added');
{if !((_x select 0) in _wanted) then {deleteVehicle (_x select 1);if (!isNull (_x select 2)) then {(_x select 2) hideObject ((_x select 2) getVariable ['TSL_editorHidden',_x select 6]);};};} forEach _proxies;
_proxies=_proxies select {(_x select 0) in _wanted};{private _key=_x select 0;private _i=(_e get 'poses') findIf {(_x select 0)==_key};(_x select 1) hideObject (_i>=0 && {((_e get 'poses') select _i) param [2,false]});} forEach _proxies;_e set ['proxies',_proxies];

private _selected=_e getOrDefault ['selected',''];private _selectedIndex=_proxies findIf {(_x select 0)==_selected};if (_selectedIndex>=0) then {private _r=_proxies select _selectedIndex;_e set ['ghost',_r select 1];_e set ['source',_r select 2];};
