params ['_l'];if (!isServer || {isNull _l}) exitWith {};
// Keep the locker awake so attached holders and their equipment proxies update in MP.
_l enableDynamicSimulation false;
_l enableSimulationGlobal true;
private _migrated=count (_l getVariable ['TSL_custom',TSL_customDefault])<26;private _custom=[_l getVariable ['TSL_custom',TSL_customDefault]] call TSL_fnc_normalizeCustom;_l setVariable ['TSL_custom',_custom,true];private _gear=_l getVariable ['TSL_gear',[]];private _adjust=_l getVariable ['TSL_adjust',[]];
if (count _gear<count TSL_slots) then {while {count _gear<count TSL_slots} do {_gear pushBack [];};_l setVariable ['TSL_gear',_gear,true];};if (count _adjust<count TSL_slots) then {while {count _adjust<count TSL_slots} do {_adjust pushBack [0,0,0,0];};_l setVariable ['TSL_adjust',_adjust,true];};
if (_migrated) then {{_adjust set [_x,[0,0,0,0]];} forEach [1,2,3,4];_l setVariable ['TSL_adjust',_adjust,true];};
// The roof and top-case placement share the same physical display space.
if (count (_gear select 6)>0 && {count (_gear select 13)>0} && {[_custom,_gear,6] call TSL_bagUsesRoof} && {[_custom,_gear,13] call TSL_bagUsesRoof}) then {_custom set [13,2];_l setVariable ['TSL_custom',_custom,true];};
private _objects=_l getVariable ['TSL_slotObjects',TSL_slots apply {objNull}];
private _keys=_l getVariable ['TSL_slotKeys',TSL_slots apply {''}];while {count _objects<count TSL_slots} do {_objects pushBack objNull;};while {count _keys<count TSL_slots} do {_keys pushBack '';};
{
 private _slot=_forEachIndex;private _rifleIndex=TSL_rifleSlots find _slot;private _entry=_x;private _old=_objects select _slot;
 private _key=str [_custom,_entry,_adjust select _slot,if (_slot in [6,8,9,13,17]) then {[_gear select 0,_gear select 8,_gear select 9,_adjust select 0,_objects select 0,getPosWorld _l,vectorDir _l,vectorUp _l]} else {[]}];
 if (_key!=(_keys select _slot) || {isNull _old && {count _entry>0}}) then {
  if (!isNull _old) then {deleteVehicle _old;};_objects set [_slot,objNull];_keys set [_slot,_key];
  if (count _entry>0 && {_slot!=7}) then {
   private _piece=_entry select 0;(TSL_slots select _slot) params ['_label','_idx','_pos','_type'];
   private _class=if (_piece isEqualType '') then {_piece} else {_piece select 0};
   private _helmetNvgSlot=if (count (_gear select 8)>0) then {8} else {9};
   private _canMountNvg=(_custom select 4)==0 && {count (_gear select 0)>0} && {!isNull (_objects select 0)};
   private _mounted=_slot in [8,9] && {_slot==_helmetNvgSlot} && {_canMountNvg};
   private _bagPosition=_custom param [([_slot] call TSL_backpackSettings) select 0,if (_slot==13) then {1} else {0}];private _bagOverrideIndex=([_slot] call TSL_backpackSettings) select 1;private _backpackVariant=0;if (_slot in TSL_backpackSlots) then {private _m=toLower getText (configFile>>'CfgVehicles'>>_class>>'model');if ((_m find 'bsqdn_backpacks')>=0) then {if ((_m find '6500')>=0) then {_backpackVariant=1;};if ((_m find 'satl')>=0) then {_backpackVariant=2;};if ((_m find 'eagle_c')>=0) then {_backpackVariant=4;} else {if ((_m find 'eagle.p3d')>=0) then {_backpackVariant=3;};};};private _override=_custom param [_bagOverrideIndex,0];if (_override>0) then {_backpackVariant=_override;};};if (_bagPosition==3 && {_backpackVariant!=1}) then {_bagPosition=0;};private _backpackReference=_slot in TSL_backpackSlots && {_backpackVariant>0};
   private _shelf=_slot in [8,9] && {!_mounted};private _obj=objNull;private _direct=_slot==8 || _mounted || _slot in [0,3,4,6,10,12,13,17];private _cfg=configNull;
   if (_backpackReference) then {_obj=createVehicle [format ['TSL_Backpack%1_Pos%2',_backpackVariant,_bagPosition],[0,0,-1000],[],0,'CAN_COLLIDE'];_obj enableSimulationGlobal false;_obj allowDamage false;private _bagCfg=configFile>>'CfgVehicles'>>_class;private _bagTex=getArray (_bagCfg>>'hiddenSelectionsTextures');{_obj setObjectTextureGlobal [_forEachIndex,_x];} forEach _bagTex;private _bagMat=getArray (_bagCfg>>'hiddenSelectionsMaterials');{_obj setObjectMaterialGlobal [_forEachIndex,_x];} forEach _bagMat;} else {
   if (_shelf) then {_obj=createSimpleObject ['\TS_Lockers\TSL_NVGReference.p3d',[0,0,-1000],true];} else {
   if (_direct) then {
    _cfg=configFile>>(if (_slot in TSL_backpackSlots) then {'CfgVehicles'} else {if (_slot==10) then {'CfgGlasses'} else {'CfgWeapons'}})>>_class;
    private _model=if (_slot in [0,5,8,9]) then {getText (_cfg>>'ItemInfo'>>'uniformModel')} else {getText (_cfg>>'model')};
    if (_model=='' || {_model=='-'}) then {_model=getText (_cfg>>'model');};
    if (_model!='' && {_model!='-'}) then {
     private _modelKey=toLower _model;while {(_modelKey select [0,1])=='\'} do {_modelKey=_modelKey select [1];};if ((_modelKey select [(count _modelKey)-4])!='.p3d') then {_modelKey=_modelKey+'.p3d';};private _sections=getArray (_cfg>>'hiddenSelections');if (count _sections==0) then {_sections=getArray (_cfg>>'ItemInfo'>>'hiddenSelections');};_sections=_sections apply {toLower _x};
     private _wrapper=TSL_equipmentDisplays findIf {(_x select 0)==_modelKey && {(_x select 1) isEqualTo _sections}};if (_wrapper<0) then {_wrapper=TSL_equipmentDisplays findIf {(_x select 0)==_modelKey};};
     if (_slot in TSL_backpackSlots) then {_obj=createVehicle [_class,[0,0,-1000],[],0,'CAN_COLLIDE'];} else {if (_slot==10 && {_wrapper>=0}) then {_obj=createVehicle [(TSL_equipmentDisplays select _wrapper) select 2,[0,0,-1000],[],0,'CAN_COLLIDE'];} else {_obj=createSimpleObject [_model,[0,0,-1000],true];};};_obj enableSimulationGlobal false;_obj allowDamage false;
    };
   } else {
    _obj=createVehicle [if (_slot in TSL_rifleSlots && {((_custom select 21) select _rifleIndex)>0 || {((_custom select 5) select _rifleIndex) in [0,3]}}) then {'TSL_WeaponDisplayHolder'} else {if (_slot==5) then {'TSL_VestDisplayHolder'} else {'GroundWeaponHolder_Scripted'}},[0,0,-1000],[],0,'CAN_COLLIDE'];
    _obj hideObjectGlobal true;clearWeaponCargoGlobal _obj;clearMagazineCargoGlobal _obj;clearItemCargoGlobal _obj;clearBackpackCargoGlobal _obj;[_obj] remoteExecCall ['TSL_fnc_lockDisplay',0,_obj];
    switch _type do {case 'weapon':{_obj addWeaponWithAttachmentsCargoGlobal [_piece,1];diag_log format ['[TS Lockers] weapon display slot %1 type %2 immediate cargo %3',_slot,typeOf _obj,weaponsItemsCargo _obj];};case 'container':{_obj addItemCargoGlobal [_class,1];};default {_obj addItemCargoGlobal [_class,1];};};
   };
   };};
   if (!isNull _obj) then {
    _obj hideObjectGlobal true;
    private _adj=_adjust select _slot;
    if (_backpackReference) then {private _caseLift=if (_bagPosition==1 && {_backpackVariant in [1,2]} && {_custom select 3} && {(_custom select 19)==1}) then {.233} else {0};[_obj,_l,[0,0,_caseLift],[0,1,0]] call TSL_fnc_placeDisplay;} else {
    if (_shelf) then {private _off=[0,0,0];if (_slot==9 && {count (_gear select 8)>0} && {!_canMountNvg}) then {_off=[0,.14,0];};[_obj,_l,_off,[0,1,0]] call TSL_fnc_placeDisplay;} else {
    if (_direct) then {
     private _names=getArray (_cfg>>'hiddenSelections');private _textures=getArray (_cfg>>'hiddenSelectionsTextures');if (count _names==0) then {_names=getArray (_cfg>>'ItemInfo'>>'hiddenSelections');};if (count _textures==0) then {_textures=getArray (_cfg>>'ItemInfo'>>'hiddenSelectionsTextures');};
     if (_slot in [0,8] && {count _names==0}) then {_names=getArray (_cfg>>'ItemInfo'>>'hiddenSelections');};
     {if (_slot in [6,10,13,17] && {_forEachIndex<count _names}) then {_obj setObjectTextureGlobal [_forEachIndex,_x];};} forEach _textures;
     private _materials=getArray (_cfg>>'hiddenSelectionsMaterials');{if (_slot in [6,10,13,17] && {_forEachIndex<count _names}) then {_obj setObjectMaterialGlobal [_forEachIndex,_x];};} forEach _materials;
     if (_mounted) then {
      private _parent=_objects select 0;private _off=[_adj select 0,_adj select 1,_adj select 2];private _d=[sin (_adj select 3),cos (_adj select 3),0];
      _obj attachTo [_parent,_off];_obj setVectorDirAndUp [_d,[0,0,1]];
     } else {
     if (_slot in [3,4]) then {
      {private _name=toLower _x;if ((_name find 'zasleh')>=0 || {(_name find 'muzzle_flash')>=0} || {(_name find 'muzzleflash')>=0}) then {_obj hideSelection [_x,true];};} forEach selectionNames _obj;
      _obj hideSelection ['zasleh',true];_obj hideSelection ['zasleh2',true];
     };
     private _bounds=if (_slot in [3,4]) then {boundingBoxReal [_obj,'Geometry']} else {0 boundingBoxReal _obj};
     if (_slot in [3,4] && {(toLower ((getModelInfo _obj) select 1) find 'avalon_pistols\model\m9a3.p3d')>=0}) then {
      _bounds=[[-.10614151,-.04700503,-.10517504],[.10922748,-.00861802,.03683496]];
     };private _probeExtent=(_bounds select 1) vectorDiff (_bounds select 0);if ((_probeExtent select 0) max (_probeExtent select 1) max (_probeExtent select 2)<.15) then {_bounds=0 boundingBoxReal _obj;};private _min=_bounds select 0;private _max=_bounds select 1;
     private _anchor=switch _slot do {case 0:{[-.494,-.242,1.415]};case 3:{[.07,-.33,1.466]};case 4:{[.28,-.33,1.466]};case 5:{[-.303,-.27,.86]};case 6:{[-.303,-.27,.028]};case 13:{[.11,-.27,.65]};case 8:{[-.3001,-.4549,1.4362]};case 9:{[-.3001,-.4549,1.4362]};case 12:{[-.29,-.30,1.438]};default {[-.15,-.265,1.46]};};
     private _extent=_max vectorDiff _min;private _thin=2;if ((_extent select 1)<(_extent select _thin)) then {_thin=1;};if ((_extent select 0)<(_extent select _thin)) then {_thin=0;};
     private _yaw=_adj select 3;private _dir=if (_slot in [8,9]) then {[0,1,0]} else {if (_slot==10 && {_thin==1}) then {[0,0,-1]} else {[sin _yaw,cos _yaw,0]}};
     private _muzzle=_obj selectionPosition ['usti hlavne','Memory'];private _breech=_obj selectionPosition ['konec hlavne','Memory'];private _pistolSign=if ((_muzzle select 0)<=(_breech select 0)) then {1} else {-1};
     private _up=if (_slot in [8,9]) then {[0,0,1]} else {if (_slot==10 && {_thin==1}) then {[sin _yaw,cos _yaw,0]} else {if (_slot in [3,4]) then {[cos _yaw*_pistolSign,-sin _yaw*_pistolSign,0]} else {if (_slot==10 && {_thin==0}) then {[-cos _yaw,sin _yaw,0]} else {[0,0,1]}}}};private _right=_dir vectorCrossProduct _up;
     private _corners=[];
     {private _xCoord=_x;{private _yCoord=_x;{_corners pushBack ((_right vectorMultiply _xCoord) vectorAdd (_dir vectorMultiply _yCoord) vectorAdd (_up vectorMultiply _x));} forEach [_min select 2,_max select 2];} forEach [_min select 1,_max select 1];} forEach [_min select 0,_max select 0];
     private _lo=[1e9,1e9,1e9];private _hi=[-1e9,-1e9,-1e9];{private _corner=_x;for '_i' from 0 to 2 do {_lo set [_i,(_lo select _i) min (_corner select _i)];_hi set [_i,(_hi select _i) max (_corner select _i)];};} forEach _corners;
     private _shift=[((_lo select 0)+(_hi select 0))*.5,((_lo select 1)+(_hi select 1))*.5,_lo select 2];
     private _offset=(_anchor vectorDiff _shift) vectorAdd [_adj select 0,_adj select 1,_adj select 2];
     _obj attachTo [_l,_offset];_obj setVectorDirAndUp [_dir,_up];
     };
    } else {
     private _selection=TSL_slotSelections select _slot;private _pose=TSL_slotPoses select _slot;
     private _offset=+(_pose select 0);private _rot=+(_pose select 1);
     {if ((_x select 0)==_class && {(_x select 1)==_selection}) exitWith {_offset=+(_x select 2);_rot=+(_x select 3);};} forEach TSL_visualOffsets;
     if (_slot in TSL_rifleSlots) then {private _mode=(_custom select 5) select _rifleIndex;if (_mode in [1,2]) then {_selection='';_offset=if (_mode==1) then {[-.5064,-.60,.4402]} else {[.3059,-.60,.43]};_rot=[-1,7,-90];};if (_mode==0) then {_rot=[-1,0,-90];};if (_mode==3) then {_selection='';_offset=[-.125,-.64,1.65];_rot=[180,0,0];};};
     _offset=_offset vectorAdd [_adj select 0,_adj select 1,_adj select 2];_rot set [2,(_rot select 2)+(_adj select 3)];
     _obj attachTo [_l,_offset,_selection];_rot params ['_yaw','_pitch','_roll'];
     _obj setVectorDirAndUp [[sin _yaw*cos _pitch,cos _yaw*cos _pitch,sin _pitch],[[sin _roll,-sin _pitch,cos _roll*cos _pitch],-_yaw] call BIS_fnc_rotateVector2D];
     _obj allowDamage false;_obj enableSimulationGlobal false;
     if (_slot in TSL_rifleSlots && {((_custom select 5) select _rifleIndex) in [1,2] && {((_custom select 21) select _rifleIndex)==0}}) then {private _d=[sin _yaw*cos _pitch,cos _yaw*cos _pitch,sin _pitch];private _u=[[sin _roll,-sin _pitch,cos _roll*cos _pitch],-_yaw] call BIS_fnc_rotateVector2D;[_obj,_l,+_offset,_d,_u] call TSL_fnc_groundRifle;};
     private _dir=[sin _yaw*cos _pitch,cos _yaw*cos _pitch,sin _pitch];private _up=[[sin _roll,-sin _pitch,cos _roll*cos _pitch],-_yaw] call BIS_fnc_rotateVector2D;
     _obj attachTo [_l,_offset,_selection];_obj setVectorDirAndUp [_dir,_up];
     if (_slot in TSL_rifleSlots && {((_custom select 21) select _rifleIndex)>0 || {((_custom select 5) select _rifleIndex) in [0,3]}}) then {[_obj,_l,+_offset,_selection,_dir,_up,_slot,(_custom select 5) select _rifleIndex,+_adj] call TSL_fnc_fitRifle;};
    };
    };};
    if (_slot in [3,4] && {((_custom select 22) select (_slot-3))>0}) then {[_obj,_l,+_adj] call TSL_fnc_renderSourcePistol;};
    _obj disableCollisionWith _l;_obj hideObjectGlobal false;_objects set [_slot,_obj];
    diag_log format ['[TS Lockers] visual slot %1 preserves class %2, model %3',_slot,_class,getModelInfo _obj];
   } else {diag_log format ['[TS Lockers] No display model for slot %1 class %2. Stored class preserved.',_slot,_class];};
  };
 };
} forEach _gear;
_l setVariable ['TSL_slotObjects',_objects];_l setVariable ['TSL_slotKeys',_keys];_l setVariable ['TSL_visuals',_objects select {!isNull _x}];
[_l] call TSL_fnc_renderExtras;[_l] call TSL_fnc_renderClamps;[_l] call TSL_fnc_renderDecor;

[_l] call TSL_fnc_editorRender;
[_l] call TSL_fnc_publishVisuals;

