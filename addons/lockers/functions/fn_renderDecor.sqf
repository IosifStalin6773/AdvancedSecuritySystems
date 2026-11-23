params ['_l'];if (!isServer) exitWith {};
private _c=[_l getVariable ['TSL_custom',TSL_customDefault]] call TSL_fnc_normalizeCustom;
private _layout=+(_l getVariable ['TSL_panelLayout',[-1,-1,-1,-1]]);
// Move the previous shared shelf layout to its own saved slots, once.
if (6 in _layout) then {
 private _patches=+(_l getVariable ['TSL_patch',[-1,-1,-1,-1]]);private _shelf=+(_c select 31);private _angles=+(_c select 32);
 {if (_x==6) then {_shelf set [_forEachIndex,_patches select _forEachIndex];_angles set [_forEachIndex,(_c select 30) select _forEachIndex];_patches set [_forEachIndex,-1];_layout set [_forEachIndex,-1];};} forEach +_layout;
 _c set [31,_shelf];_c set [32,_angles];_c set [33,true];_l setVariable ['TSL_patch',_patches,true];_l setVariable ['TSL_panelLayout',_layout,true];
};
_l setVariable ['TSL_custom',_c,true];[_l] call TSL_fnc_renderPanels;
private _angles=([_l getVariable ['TSL_custom',TSL_customDefault]] call TSL_fnc_normalizeCustom) select 30;private _key=str [_c select 34,_c select 31,_c select 32,_c select 33,_angles,_l getVariable ['TSL_wallPhotos',[]],_l getVariable ['TSL_patch',[]],_l getVariable ['TSL_photo',[]],_layout,(_l getVariable ['TSL_custom',TSL_customDefault]) select 6,getPosWorld _l,vectorDir _l,vectorUp _l];
if (_key==(_l getVariable ['TSL_decorKey',''])) exitWith {};_l setVariable ['TSL_decorKey',_key];
{if (!isNull _x) then {deleteVehicle _x;};} forEach (_l getVariable ['TSL_decor',[]]);private _objs=[];
{
 _x params ['_kind','_catalog','_positions'];
private _values=_l getVariable ['TSL_'+_kind,[]];
 {
  if (_x>=0 && {_x<count _catalog} && {_kind!='patch' || {(_layout select _forEachIndex)>=0}}) then {
   private _class=(_catalog select _x) select 1;private _shelf=_kind=='patch' && {(_layout select _forEachIndex)==6};private _obj=createVehicle [_class,[0,0,-1000],[],0,'CAN_COLLIDE'];_obj hideObjectGlobal true;private _pos=_positions select _forEachIndex;if (_kind=='patch') then {private _def=TSL_panelDefs select (_layout select _forEachIndex);_pos=(_def select 1) vectorAdd ((_def select 3) vectorMultiply .006);_pos=_pos vectorAdd (((_def select 2) vectorCrossProduct [0,0,1]) vectorMultiply (((_l getVariable ['TSL_custom',TSL_customDefault]) select 6) select _forEachIndex));};_obj enableSimulationGlobal false;_obj allowDamage false;
   if (_kind=='patch') then {
    private _def=TSL_panelDefs select (_layout select _forEachIndex);private _angle=_angles select _forEachIndex;private _up=(((_def select 2) vectorCrossProduct [0,0,1]) vectorMultiply sin _angle) vectorAdd [0,0,cos _angle];if (_shelf) then {_pos=_pos vectorAdd [([-.105,-.035,.035,.105] select _forEachIndex),-.0008*_forEachIndex,([.003,-.003,.002,-.002] select _forEachIndex)];};[_obj,_l,_pos,_def select 2,_up] call TSL_fnc_placeDisplay;
   } else {private _angle=[-7,5,-3] select _forEachIndex;[_obj,_l,_pos,[0,1,0],[sin _angle,0,cos _angle]] call TSL_fnc_placeDisplay;};
   _obj setVariable ['TSL_editKey',_kind+'_'+str _forEachIndex,true];_obj setVariable ['TSL_editLabel',_kind+' '+str (_forEachIndex+1),true];_obj hideObjectGlobal false;_objs pushBack _obj;
  };
 } forEach _values;
} forEach [['patch',TSL_patches,TSL_patchPos],['photo',TSL_photos,TSL_photoPos]];
if (_c select 33) then {
 {if (_x>=0 && {_x<count TSL_patches}) then {
  private _slot=_forEachIndex;private _o=createVehicle [(TSL_patches select _x) select 1,[0,0,-1000],[],0,'CAN_COLLIDE'];_o hideObjectGlobal true;_o enableSimulationGlobal false;_o allowDamage false;
  private _shift=(_c select 34) select _slot;private _pos=[-.2997+([-.105,-.035,.035,.105] select _slot)+_shift,-.5215-.0008*_slot,1.425+([.003,-.003,.002,-.002] select _slot)];
  private _angle=(_c select 32) select _slot;[_o,_l,_pos,[0,1,0],[sin _angle,0,cos _angle]] call TSL_fnc_placeDisplay;_o setVariable ['TSL_editKey','shelfpatch_'+str _slot,true];_o setVariable ['TSL_editLabel','Shelf patch '+str (_slot+1),true];_o disableCollisionWith _l;_o hideObjectGlobal false;_objs pushBack _o;
 };} forEach (_c select 31);
};

{
 _x params ['_wall','_choice','_horizontal','_vertical'];private _def=TSL_photoWalls select _wall;private _dir=_def select 2;private _pos=(_def select 1) vectorAdd ((_dir vectorCrossProduct [0,0,1]) vectorMultiply _horizontal) vectorAdd [0,0,_vertical];
 private _o=createVehicle [(TSL_photos select _choice) select 1,getPosATL _l,[],0,'CAN_COLLIDE'];_o enableSimulationGlobal false;_o allowDamage false;[_o,_l,_pos,_dir] call TSL_fnc_placeDisplay;_o setVariable ['TSL_editKey','wallphoto_'+str _forEachIndex,true];_o setVariable ['TSL_editLabel','Wall photo '+str (_forEachIndex+1),true];_objs pushBack _o;
} forEach (_l getVariable ['TSL_wallPhotos',[]]);
_l setVariable ['TSL_decor',_objs];

[_l] call TSL_fnc_publishVisuals;

