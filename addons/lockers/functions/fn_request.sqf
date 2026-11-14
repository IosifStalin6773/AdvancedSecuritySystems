params ['_l','_p','_op',['_a',[]]];
if (!isServer || {isNull _l} || {isNull _p} || {!(_l isKindOf 'Land_TS_Locker_F')} || {!isPlayer _p}) exitWith {};
if (isRemoteExecuted && {remoteExecutedOwner!=owner _p}) exitWith {};
private _automatic=_op=='claim' && {!isRemoteExecuted} && {(_l getVariable ['TSL_autoClaimUID',''])==getPlayerUID _p};
if ((_p distance _l>3 && {!_automatic}) || {!alive _p}) exitWith {['Move closer to your locker and remain alive. / Подойдите ближе к своему локеру.']remoteExecCall ['TSL_fnc_notice',owner _p];};
private _uid=getPlayerUID _p;if (_uid=='') exitWith {};
// ADVSEC: quién puede tener taquilla, bloqueo a detenidos y registro de eventos
if (!isNil 'ADVSEC_fnc_lockerGate' && {!([_l,_p,_op] call ADVSEC_fnc_lockerGate)}) exitWith {};
[_uid]call TSL_fnc_migrateLegacy;
private _msg={params ['_text'];[_text] remoteExecCall ['TSL_fnc_notice',owner _p];};
if (_op=='claim') exitWith {
 if ((_l getVariable ['TSL_owner',''])!='') exitWith {['Locker already occupied'] call _msg;};
 private _previous=TSL_uidMap getOrDefault [_uid,objNull];if (!isNull _previous) exitWith {['You already own a locker'] call _msg;};
 _l setVariable ['TSL_owner',_uid,true];TSL_uidMap set [_uid,_l];
 private _saved=profileNamespace getVariable [([_uid]call TSL_fnc_scenarioKey)+'_Kit',profileNamespace getVariable ['TS_Locker_v1_'+_uid,[]]];
 _saved=parseSimpleArray str _saved;
 private _hasEquipment=false;
 if (_saved isEqualType [] && {count _saved>=6}) then {
  _hasEquipment=((_saved select 1)findIf{count _x>0})>=0 || {!((_saved select 5)isEqualTo [[[],[]],[],[],[]])} || {((_saved param [7,[-1,-1,-1,-1]])findIf{_x>=0})>=0};
 };
 if (isNil{profileNamespace getVariable ('TS_Locker_backup_'+_uid)} && {_hasEquipment}) then {profileNamespace setVariable ['TS_Locker_backup_'+_uid,parseSimpleArray str _saved];saveProfileNamespace;};
 _l setVariable ['TSL_savedSnapshot',profileNamespace getVariable ['TS_Locker_backup_'+_uid,_saved]];
 // Prefer this scenario snapshot; retain the established UID save as the legacy fallback.
 // Restore the last authoritative inventory instead of silently creating an empty locker.
 private _data=if (_saved isEqualType [] && {count _saved>=6}) then {parseSimpleArray str _saved} else {[]};
 if (count _data>=6) then {
  _l setVariable ['TSL_gear',_data select 1,true];
  _l setVariable ['TSL_adjust',_data select 4,true];
  _l setVariable ['TSL_holderAdjust',_data param [6,[0,0]],true];
 };
 private _decorData=_saved;
 _l setVariable ['TSL_editorPoses',_saved param [10,[]],true];_l setVariable ['TSL_editorAdded',_saved param [11,[]],true];_l setVariable ['TSL_editorRevision',0,true];_l setVariable ['TSL_gearHomes',_saved param [12,[]],true];_l setVariable ['TSL_gearPayloads',_saved param [13,[]]];
 if (count _decorData>=6) then {
  _l setVariable ['TSL_wallPhotos',_decorData param [9,[]],true];
  _l setVariable ['TSL_custom',_decorData param [8,TSL_customDefault],true];
  private _patch=+(_decorData select 2);if ((_decorData select 0)<5) then {_patch=_patch apply {if (_x>=12) then {-1} else {_x}};};_l setVariable ['TSL_patch',_patch,true];_l setVariable ['TSL_photo',_decorData select 3,true];
  _l setVariable ['TSL_panelLayout',_decorData param [7,_l getVariable ['TSL_panelLayout',[-1,-1,-1,-1]]],true];
 };
 _l enableDynamicSimulation false;_l enableSimulationGlobal true;_l setVelocity [0,0,0];
 private _crate=createVehicle ['TSL_Storage',[0,0,-1000],[],0,'CAN_COLLIDE'];_crate enableSimulationGlobal false;_crate hideObjectGlobal true;_crate disableCollisionWith _l;_crate attachTo [_l,[-.30,-.25,.30]];_crate allowDamage false;
 _crate setVariable ['TSL_locker',_l,true];_l setVariable ['TSL_crate',_crate,true];
 if (count _data>=6) then {
 [_crate,_data select 5] call TSL_fnc_restoreCargo;
 // A restored kit must not remain available as a second manual restore.
 private _containsGear=((_data select 1) findIf {count _x>0})>=0;
 if ((_data select 0)>=7 || {_containsGear} || {(_data select 5)isNotEqualTo [[[],[]],[],[],[]]}) then {
  _l setVariable ['TSL_savedSnapshot',[]];profileNamespace setVariable ['TS_Locker_backup_'+_uid,nil];
 };
} else {clearItemCargoGlobal _crate;clearMagazineCargoGlobal _crate;clearWeaponCargoGlobal _crate;clearBackpackCargoGlobal _crate;};
 [_l] call TSL_fnc_render;[_l] call TSL_fnc_save;['Locker claimed. Changes save automatically.'] call _msg;
};
if ((_l getVariable ['TSL_owner',''])!=_uid) exitWith {['Claim your own locker first. / Сначала займите свой локер.']call _msg;};
if (_l getVariable ['TSL_busy',false]) exitWith {['Finish the previous transfer first'] call _msg;};
// Obtain the inventory from its owner, not a potentially delayed remote-unit snapshot.
private _requestLoadout=[];
private _capture=_l getVariable ['TSL_requestSnapshot',[]];
private _captured=count _capture==4 && {(_capture select 0)==_p} && {(_capture select 1)==_op} && {(_capture select 2)isEqualTo _a};
if (_captured) then {_requestLoadout=_capture select 3;_l setVariable ['TSL_requestSnapshot',nil];};
if (!_captured && {(_l getVariable ['TSL_capturePending',[]])isNotEqualTo []} && {_op!='save'}) exitWith {['Inventory synchronisation is pending. Please wait. / Ожидается ответ инвентаря.']call _msg;};
if (_op in ['put','take','putBackpack','putAll','takeAll','editorGear','editorReturn','stackTransfer'] && {!_captured}) exitWith {[_l,_p,_op,_a]call TSL_fnc_beginCapture;};

if (_op=='stackTransfer') exitWith {
 if !(_a isEqualType [] && {count _a==2}) exitWith {};
 _a params [['_key',''],['_action','']];if !(_key isEqualType '' && {_action in ['take','return']}) exitWith {};
 private _state=[_l,_key] call TSL_fnc_stackState;if (_state isEqualTo []) exitWith {};
 private _rows=_state select (if (_action=='take') then {2} else {3});if (_rows isEqualTo []) exitWith {};
 private _member=(_rows select (count _rows-1)) select 0;
 if (_action=='take') then {[_l,_p,[_member,'take'],_requestLoadout] call TSL_fnc_gearTransfer;} else {[_l,_p,[_member],_requestLoadout] call TSL_fnc_gearReturn;};
};
if (_op=='editorReturn') exitWith {[_l,_p,_a,_requestLoadout] call TSL_fnc_gearReturn;};
if (_op=='editorForget') exitWith {private _key=_a param [0,''];if (((_l getVariable ['TSL_editorAdded',[]]) findIf {(_x select 0)==_key})>=0) exitWith {};_l setVariable ['TSL_gearHomes',(_l getVariable ['TSL_gearHomes',[]]) select {(_x select 0)!=_key},true];_l setVariable ['TSL_gearPayloads',(_l getVariable ['TSL_gearPayloads',[]]) select {(_x select 0)!=_key}];[_l] call TSL_fnc_save;};
if (_op=='editorGear') exitWith {[_l,_p,_a,_requestLoadout] call TSL_fnc_gearTransfer;};
if ((_op select [0,6])=='preset') exitWith {[_l,_p,_op,_a] call TSL_fnc_presetServer;};
if (_op=='editorApply') exitWith {[_l,_p,_a] call TSL_fnc_editorCommit;};
if (_l getVariable ['TSL_busy',false]) exitWith {['Finish the previous transfer first'] call _msg;};
if (_op in ['sourceDetail','rifleSource','pistolSource']) exitWith {
 private _v=[_l getVariable ['TSL_custom',TSL_customDefault]] call TSL_fnc_normalizeCustom;
 if (_op=='sourceDetail') then {_a params ['_index','_item','_on'];if !(_index in [15,17] && {_item isEqualType 0} && {_on isEqualType true} && {_item>=0} && {_item<count (_v select _index)}) exitWith {};private _list=+(_v select _index);_list set [_item,_on];_v set [_index,_list];} else {
 _a params ['_slot','_position'];private _idx=if (_op=='rifleSource') then {21} else {22};private _limit=if (_idx==21) then {5} else {1};private _slots=if (_idx==21) then {TSL_rifleSlots} else {[3,4]};if !(_slot isEqualType 0 && {_slot>=0 && {_slot<count _slots}} && {_position isEqualType 0} && {_position>=0 && {_position<=_limit}}) exitWith {};private _list=+(_v select _idx);private _gear=_l getVariable ['TSL_gear',[]];private _occupied=false;{if (_forEachIndex!=_slot && {(_list select _forEachIndex)==_position} && {count (_gear param [_x,[]])>0}) then {_occupied=true;};} forEach _slots;if (_position>0 && {_occupied}) exitWith {['That display position is occupied'] call _msg;};_list set [_slot,_position];_v set [_idx,_list];private _adjust=_l getVariable ['TSL_adjust',TSL_slots apply {[0,0,0,0]}];_adjust set [_slots select _slot,[0,0,0,0]];_l setVariable ['TSL_adjust',_adjust,true];if (_idx==21 && {_position==5}) then {_v set [3,true];_v set [19,1];};
 };
 _l setVariable ['TSL_custom',_v,true];[_l] call TSL_fnc_render;[_l] call TSL_fnc_save;
};
if (_op in ['shelfPanel','shelfPatch']) exitWith {
 private _c=[_l getVariable ['TSL_custom',TSL_customDefault]] call TSL_fnc_normalizeCustom;private _ok=true;
 if (_op=='shelfPanel') then {private _on=_a param [0,false];if !(_on isEqualType true) then {_ok=false;} else {_c set [33,_on];};} else {
  _a params ['_slot','_choice'];if !(_slot in [0,1,2,3] && {_choice>=-1} && {_choice<count TSL_patches}) then {_ok=false;} else {private _values=+(_c select 31);_values set [_slot,_choice];_c set [31,_values];_c set [33,true];};
 };
 if (!_ok) exitWith {};_l setVariable ['TSL_custom',_c,true];[_l] call TSL_fnc_renderDecor;[_l] call TSL_fnc_save;
};
if (_op=='shelfShift') exitWith {
 _a params ['_slot','_delta'];if !(_slot in [0,1,2,3] && {_delta in [-.01,.01,0]}) exitWith {};
 private _c=[_l getVariable ['TSL_custom',TSL_customDefault]] call TSL_fnc_normalizeCustom;private _offsets=+(_c select 34);
 _offsets set [_slot,if (_delta==0) then {0} else {((_offsets select _slot)+_delta) max -.3 min .3}];_c set [34,_offsets];
 _l setVariable ['TSL_custom',_c,true];[_l] call TSL_fnc_renderDecor;[_l] call TSL_fnc_save;
};
if (_op in ['patchRotate','shelfRotate']) exitWith {
 _a params ['_slot','_delta'];if !(_slot in [0,1,2,3] && {_delta in [-15,-5,5,15,90,180,0]}) exitWith {};
 private _c=[_l getVariable ['TSL_custom',TSL_customDefault]] call TSL_fnc_normalizeCustom;private _angleIndex=if (_op=='shelfRotate') then {32} else {30};private _angles=+(_c select _angleIndex);
 _angles set [_slot,if (_delta==0) then {0} else {(((_angles select _slot)+_delta) mod 360+360) mod 360}];_c set [_angleIndex,_angles];
 _l setVariable ['TSL_custom',_c,true];[_l] call TSL_fnc_renderDecor;[_l] call TSL_fnc_save;
};
if (_op in ['hookChoice','waterStep']) exitWith {
 private _v=[_l getVariable ['TSL_custom',TSL_customDefault]] call TSL_fnc_normalizeCustom;
 private _ok=true;
 if (_op=='hookChoice') then {
  _a params ['_hook','_choice'];
  if !(_hook in [0,1] && {_choice in [0,1,2]}) then {_ok=false;} else {
   _v set [if (_hook==0) then {18} else {16},_choice==1];
   _v set [if (_hook==0) then {27} else {28},_choice==2];
  };
 } else {private _step=_a param [0,0];if !(_step in [-1,1]) then {_ok=false;} else {_v set [29,((_v select 29)+_step) max 0 min count TSL_waterModels];};};
 if (!_ok) exitWith {};
 _l setVariable ['TSL_custom',_v,true];[_l] call TSL_fnc_render;[_l] call TSL_fnc_save;
};
if (_op=='custom') exitWith {
 _a params ['_index','_value'];private _v=[_l getVariable ['TSL_custom',TSL_customDefault]] call TSL_fnc_normalizeCustom;
 private _ok=switch _index do {case 0:{_value isEqualType 0 && {_value>=-1 && {_value<count TSL_nameCodes}}};case 1:{_value in [0,1]};case 2:{_value in [1,2]};case 3;case 9;case 10;case 11;case 12;case 16;case 18;case 23;case 26;case 27;case 28:{_value isEqualType true};case 4:{_value in [0,1]};case 24:{_value in [0,1]};case 25:{_value in [0,3,4]};case 29:{_value in [0,1,2,3]};case 7;case 13:{_value in [0,1,2,3]};case 8;case 14:{_value in [0,1,2,3,4]};case 19:{_value in [0,1]};default {false};};
 if (!_ok) exitWith {};
 if (_value isEqualTo true) then {switch _index do {case 16:{_v set [28,false];};case 18:{_v set [27,false];};case 27:{_v set [18,false];};case 28:{_v set [16,false];};};};
 if (_index in [7,13] && {_value in [1,3]}) then {private _slot=if (_index==7) then {6} else {13};private _otherSlot=if (_slot==6) then {13} else {6};private _gear=_l getVariable ['TSL_gear',[]];private _test=parseSimpleArray str _v;_test set [_index,_value];if ([_test,_gear,_slot] call TSL_bagUsesRoof && {[_test,_gear,_otherSlot] call TSL_bagUsesRoof} && {count (_gear param [_otherSlot,[]])>0}) then {['That display position is occupied'] call _msg;_ok=false;};};if (!_ok) exitWith {};
 if (_value isEqualTo true) then {switch _index do {case 16:{_v set [28,false];};case 18:{_v set [27,false];};case 27:{_v set [18,false];};case 28:{_v set [16,false];};};};
 if (_index in [7,13] && {_value==3}) then {private _other=if (_index==7) then {13} else {7};private _otherSlot=if (_index==7) then {13} else {6};if ((_v select _other)==3 && {count ((_l getVariable ['TSL_gear',[]]) param [_otherSlot,[]])>0}) exitWith {['That display position is occupied'] call _msg;_ok=false;};_v set [3,true];_v set [19,1];};if (!_ok) exitWith {};
 if (_index==19) then {_v set [3,true];};
 private _topOccupied=false;{if (((_v select 21) select _forEachIndex)==5 && {count ((_l getVariable ['TSL_gear',[]]) param [_x,[]])>0}) then {_topOccupied=true;};} forEach TSL_rifleSlots;
 if (((_index==3 && {!_value}) || {_index==19 && {_value==0}}) && {_topOccupied}) exitWith {['Remove the weapon from the top case first'] call _msg;};
 if ((_index==3 && {!_value}) || {_index==19 && {_value==0}}) then {{if ((_v select _x)==3) then {_v set [_x,1];};} forEach [7,13];private _rifles=+(_v select 21);{if (_x==5) then {_rifles set [_forEachIndex,4];};} forEach +_rifles;_v set [21,_rifles];};
 while {count _v<count TSL_customDefault} do {_v pushBack (TSL_customDefault select (count _v));};_v set [_index,_value];_l setVariable ['TSL_custom',_v,true];[_l] call TSL_fnc_render;[_l] call TSL_fnc_save;
};
if (_op in ['panelShift','riflePosition']) exitWith {
 _a params ['_index','_value'];private _v=[_l getVariable ['TSL_custom',TSL_customDefault]] call TSL_fnc_normalizeCustom;
 if (_op=='panelShift') then {
  if !(_index in [0,1,2,3] && {_value isEqualType 0 && {abs _value<=.02}}) exitWith {};
  private _sh=+(_v select 6);_sh set [_index,((_sh select _index)+_value) max -.12 min .12];_v set [6,_sh];
 } else {
  if !(_index in [0,1] && {_value in [0,1,2,3]}) exitWith {};
  private _source=+(_v select 21);_source set [_index,0];_v set [21,_source];private _m=+(_v select 5);if (_value==3 && {(_m select (1-_index))==3}) exitWith {['The front mount is occupied by the other rifle'] call _msg;};_m set [_index,_value];_v set [5,_m];
 };
 _l setVariable ['TSL_custom',_v,true];[_l] call TSL_fnc_render;[_l] call TSL_fnc_save;
};
if (_op=='panel') exitWith {
 _a params ['_slot','_where'];if !(_slot in [0,1,2,3] && {_where>=-1 && {_where<count TSL_panelDefs}}) exitWith {};
 if (_where==6) exitWith {private _c=[_l getVariable ['TSL_custom',TSL_customDefault]] call TSL_fnc_normalizeCustom;_c set [33,true];_l setVariable ['TSL_custom',_c,true];[_l] call TSL_fnc_renderDecor;[_l] call TSL_fnc_save;};
  private _layout=+(_l getVariable ['TSL_panelLayout',[-1,-1,-1,-1]]);
 if (_where>=0 && {_where!=6} && {_where in _layout} && {(_layout select _slot)!=_where}) exitWith {['This panel position is already occupied'] call _msg;};
 _layout set [_slot,_where];_l setVariable ['TSL_panelLayout',_layout,true];[_l] call TSL_fnc_renderDecor;[_l] call TSL_fnc_save;
};
if (_op=='restore') exitWith {
 private _data=_l getVariable ['TSL_savedSnapshot',[]];
 if (count _data<6) exitWith {['No saved equipment available'] call _msg;};
 if (((_l getVariable ['TSL_gear',[]]) findIf {count _x>0})>=0) exitWith {['Empty equipment slots before restoring'] call _msg;};
 private _crate=_l getVariable ['TSL_crate',objNull];
 if (!isNull _crate && {!(([_crate] call TSL_fnc_cargo) isEqualTo [[[],[]],[],[],[]])}) exitWith {['Empty general storage before restoring'] call _msg;};
 _l setVariable ['TSL_panelLayout',_data param [7,if (getNumber (configFile>>'CfgVehicles'>>typeOf _l>>'TSL_hasVelcro')==1) then {[0,1,2,3]} else {[-1,-1,-1,-1]}],true];_l setVariable ['TSL_gear',_data select 1,true];private _patch=+(_data select 2);if ((_data select 0)<5) then {_patch=_patch apply {if (_x>=12) then {-1} else {_x}};};_l setVariable ['TSL_patch',_patch,true];_l setVariable ['TSL_photo',_data select 3,true];
 _l setVariable ['TSL_wallPhotos',_data param [9,[]],true];
 _l setVariable ['TSL_custom',_data param [8,TSL_customDefault],true];_l setVariable ['TSL_adjust',_data select 4,true];_l setVariable ['TSL_holderAdjust',_data param [6,[0,0]],true];
 [_l getVariable ['TSL_crate',objNull],_data select 5] call TSL_fnc_restoreCargo;[_l] call TSL_fnc_render;[_l] call TSL_fnc_save;_l setVariable ['TSL_savedSnapshot',[]];profileNamespace setVariable ['TS_Locker_backup_'+_uid,nil];saveProfileNamespace;['Saved equipment restored'] call _msg;
};
if (_op in ['save','release','reset']) exitWith {
 [_l] call TSL_fnc_save;
 if (_op!='save') then {if (_op=='reset') then {private _scenario=[_uid]call TSL_fnc_scenarioKey;profileNamespace setVariable [_scenario+'_Kit',nil];profileNamespace setVariable [_scenario+'_Locker',nil];profileNamespace setVariable ['TS_Locker_v1_'+_uid,nil];profileNamespace setVariable ['TS_Locker_backup_'+_uid,nil];_l setVariable ['TSL_savedSnapshot',[]];saveProfileNamespace;};[_l] call TSL_fnc_clear;TSL_uidMap deleteAt _uid;};
 ['Locker data updated'] call _msg;
};
if (_op in ['photoAdd','photoMove','photoDelete']) exitWith {
 private _list=parseSimpleArray str (_l getVariable ['TSL_wallPhotos',[]]);
 if (_op=='photoAdd') then {_a params ['_wall','_choice'];if !(_wall isEqualType 0 && {_wall>=0 && {_wall<count TSL_photoWalls}} && {_choice isEqualType 0 && {_choice>=0 && {_choice<count TSL_photos}}}) exitWith {};private _n={(_x select 0)==_wall} count _list;_list pushBack [_wall,_choice,((_n mod 3)-1)*.10,-(floor (_n/3) mod 7)*.11];};
 if (_op=='photoDelete') then {private _i=_a param [0,-1];if (_i>=0 && {_i<count _list}) then {_list deleteAt _i;};};
 if (_op=='photoMove') then {_a params ['_i','_axis','_delta'];if !(_i>=0 && {_i<count _list} && {_axis in [2,3]} && {_delta isEqualType 0 && {abs _delta<=.02}}) exitWith {};private _v=+(_list select _i);_v set [_axis,((_v select _axis)+_delta) max -.8 min .8];_list set [_i,_v];};
 _l setVariable ['TSL_wallPhotos',_list,true];[_l] call TSL_fnc_renderDecor;[_l] call TSL_fnc_save;
};
if (_op in ['patch','photo']) exitWith {
 if (_op=='patch' && {((_l getVariable ['TSL_panelLayout',[-1,-1,-1,-1]]) select (_a param [0,0]))<0}) exitWith {['Add a velcro panel for this slot first'] call _msg;};
 _a params ['_slot','_choice'];private _catalog=if (_op=='patch') then {TSL_patches} else {TSL_photos};private _max=if (_op=='patch') then {4} else {3};
 if (_slot<0 || {_slot>=_max} || {_choice < -1} || {_choice>=count _catalog}) exitWith {};
 private _list=+(_l getVariable ['TSL_'+_op,[]]);_list set [_slot,_choice];_l setVariable ['TSL_'+_op,_list,true];[_l] call TSL_fnc_renderDecor;[_l] call TSL_fnc_save;
};
if (_op=='holder') exitWith {
 _a params ['_index','_delta'];if !(_index in [0,1] && {abs _delta<=.05}) exitWith {};
 private _values=+(_l getVariable ['TSL_holderAdjust',[0,0]]);_values set [_index,((_values select _index)+_delta) max -.4 min .4];_l setVariable ['TSL_holderAdjust',_values,true];[_l] call TSL_fnc_renderClamps;[_l] call TSL_fnc_save;
};
if (_op=='adjust') exitWith {
 _a params ['_slot','_axis','_delta'];if (_slot<0 || {_slot>=count TSL_slots} || {_axis<0} || {_axis>3} || {abs _delta>15}) exitWith {};
 private _list=+(_l getVariable ['TSL_adjust',[]]);private _v=+(_list select _slot);_v set [_axis,((_v select _axis)+_delta) max (if (_axis==3) then {-180} else {-.3}) min (if (_axis==3) then {180} else {.3})];_list set [_slot,_v];_l setVariable ['TSL_adjust',_list,true];[_l] call TSL_fnc_render;[_l] call TSL_fnc_save;
};
if (_op in ['putAll','takeAll']) exitWith {
 // ADVSEC: equipo completo. Cada pieza entra en su hueco de la taquilla (o sale de él) en un solo traspaso.
 private _L={params ['_key','_en'];if (isNil 'ADVSEC_fnc_L') then {_en} else {_key call ADVSEC_fnc_L}};
 private _loadout=parseSimpleArray str _requestLoadout;if (count _loadout!=10) exitWith {['Inventory snapshot unavailable. Retry.']call _msg;};
 private _before=parseSimpleArray str _loadout;
 private _stored=+(_l getVariable ['TSL_gear',[]]);while {count _stored<count TSL_slots} do {_stored pushBack [];};
 private _free={count (_stored select _this)==0};
 private _has={if (_this isEqualType '') then {_this!=''} else {count _this>0 && {(_this select 0)!=''}}};
 private _moved=0;private _left=0;
 if (_op=='putAll') then {
  // La documentación ADVSEC del chaleco y la mochila pasa al uniforme, que se queda puesto.
  private _u=_loadout select 3;
  if (count _u==2 && {(_u select 0)!=''}) then {
   {
    private _c=_loadout select _x;
    if (count _c==2) then {
     private _keep=(_c select 1) select {private _v=_x select 0;private _n=if (_v isEqualType '') then {_v} else {_v param [0,'']};(_n isEqualType '') && {(toUpper (_n select [0,7]))=='ADVSEC_'}};
     if (_keep isNotEqualTo []) then {(_u select 1) append _keep;_c set [1,(_c select 1) select {!(_x in _keep)}];};
    };
   } forEach [4,5];
  };
  // [índice del equipo, huecos posibles por orden]; el tercer hueco de mochila es solo para la Eagle
  private _bagCls=(_loadout select 5) param [0,''];
  private _bags=TSL_backpackSlots select {_x!=17 || {((toLower getText (configFile>>'CfgVehicles'>>_bagCls>>'model')) find 'eagle')>=0}};
  {
   _x params ['_idx','_slots'];private _piece=_loadout select _idx;
   if (_piece call _has) then {
    private _i=_slots findIf {_x call _free};
    if (_i<0) then {_left=_left+1;} else {_stored set [_slots select _i,[_piece]];_loadout set [_idx,['',[]] select (_piece isEqualType [])];_moved=_moved+1;};
   };
  } forEach [[6,[0]],[0,TSL_rifleSlots],[1,[11]],[2,[3,4]],[4,[5]],[5,_bags],[7,[10]],[8,[12]]];
  // Las gafas de visión nocturna van sobre el casco (hueco NVG 1) o, si está ocupado, al NVG 2
  private _hmd=(_loadout select 9) select 5;
  if (_hmd!='') then {private _i=[8,9] findIf {_x call _free};if (_i<0) then {_left=_left+1;} else {_stored set [[8,9] select _i,[_hmd]];(_loadout select 9) set [5,''];_moved=_moved+1;};};
 } else {
  {
   _x params ['_idx','_slots'];
   if !((_loadout select _idx) call _has) then {
    private _i=_slots findIf {!(_x call _free)};
    if (_i>=0) then {private _s=_slots select _i;_loadout set [_idx,(_stored select _s) select 0];_stored set [_s,[]];_moved=_moved+1;};
   };
  } forEach [[6,[0]],[0,TSL_rifleSlots],[1,[11]],[2,[3,4]],[3,[7]],[4,[5]],[5,TSL_backpackSlots],[7,[10]],[8,[12]]];
  if (((_loadout select 9) select 5)=='') then {private _i=[8,9] findIf {!(_x call _free)};if (_i>=0) then {private _s=[8,9] select _i;(_loadout select 9) set [5,(_stored select _s) select 0];_stored set [_s,[]];_moved=_moved+1;};};
 };
 if (_moved==0) exitWith {
  [(if (_op=='takeAll') then {['STR_ADVSEC_lkit_slots_empty','Nothing to take: the slots are empty or you already wear those pieces.']} else {if (_left>0) then {['STR_ADVSEC_lkit_slots_full','The locker slots for your gear are occupied.']} else {['STR_ADVSEC_lkit_nothing','You are not carrying anything to store.']}}) call _L] call _msg;
 };
 private _token=(_l getVariable ['TSL_token',0])+1;_l setVariable ['TSL_token',_token];_l setVariable ['TSL_busy',true,true];_l setVariable ['TSL_pending',[_token,_p,_stored]];
 [_l,_p,_token,_before,_loadout] remoteExecCall ['TSL_fnc_applyTransfer',owner _p];
 [_l,_p,_token,_before,_loadout] call TSL_fnc_watchTransfer;
 private _text=format [(if (_op=='putAll') then {['STR_ADVSEC_lkit_slots_saved','%1 pieces placed in their locker slots. You keep your uniform and your documents.']} else {['STR_ADVSEC_lkit_slots_loaded','%1 pieces taken from the locker slots.']}) call _L,_moved];
 if (_left>0) then {_text=_text+' '+format [(['STR_ADVSEC_lkit_slots_left','%1 pieces stay with you: their slot is occupied.'] call _L),_left];};
 [_text] call _msg;
};
if (_op=='putBackpack') then {private _bags=_l getVariable ['TSL_gear',[]];private _free=TSL_backpackSlots select {count (_bags param [_x,[]])==0};if (count _free>0) then {_op='put';_a=[_free select 0];};};
if (_op=='putBackpack') exitWith {['All backpack slots are occupied'] call _msg;};
if !(_op in ['put','take']) exitWith {};
private _slot=_a param [0,-1];if (_slot<0 || {_slot>=count TSL_slots}) exitWith {};
private _idx=(TSL_slots select _slot) select 1;private _type=(TSL_slots select _slot) select 3;
private _loadout=parseSimpleArray str _requestLoadout;if (count _loadout!=10) exitWith {['Inventory snapshot unavailable. Retry.']call _msg;};private _before=parseSimpleArray str _loadout;private _piece=if (_type=='nvg') then {(_loadout select 9) param [5,'']} else {_loadout select _idx};
private _stored=+(_l getVariable ['TSL_gear',[]]);while {count _stored<count TSL_slots} do {_stored pushBack [];};private _old=_stored select _slot;
private _empty=if (_type in ['item','face','nvg']) then {''} else {[]};
private _has=if (_piece isEqualType '') then {_piece!=''} else {count _piece>0 && {(_piece select 0)!=''}};
if (_slot==0 && {_op=='put'} && {hmd _p!=''} && {count (_stored select 8)>0}) exitWith {['Store your NVG in the second slot first'] call _msg;};
if (_slot==0 && {_op=='take'} && {count (_stored select 8)>0} && {hmd _p!=''}) exitWith {['Remove your equipped NVG first'] call _msg;};
if (_slot==17 && {_op=='put'}) then {private _m=toLower getText (configFile>>'CfgVehicles'>>(_piece param [0,''])>>'model');if ((_m find 'eagle')<0) exitWith {['The third backpack slot is for Eagle BATP'] call _msg;_has=false;};};
if (_op=='put') then {
 if (count _old>0 || {!_has}) exitWith {};
 _stored set [_slot,[_piece]];if (_type=='nvg') then {(_loadout select 9) set [5,''];} else {_loadout set [_idx,_empty];};
 if (_slot==0 && {hmd _p!=''}) then {_stored set [8,[hmd _p]];(_loadout select 9) set [5,''];};
} else {
 if (count _old==0 || {_has}) exitWith {};
 if (_type=='nvg') then {(_loadout select 9) set [5,_old select 0];} else {_loadout set [_idx,_old select 0];};_stored set [_slot,[]];
 if (_slot==0 && {count (_stored select 8)>0}) then {(_loadout select 9) set [5,(_stored select 8) select 0];_stored set [8,[]];};
};
if (_before isEqualTo _loadout) exitWith {['Slot is occupied or equipment is missing'] call _msg;};
private _token=(_l getVariable ['TSL_token',0])+1;_l setVariable ['TSL_token',_token];_l setVariable ['TSL_busy',true,true];_l setVariable ['TSL_pending',[_token,_p,_stored]];
[_l,_p,_token,_before,_loadout] remoteExecCall ['TSL_fnc_applyTransfer',owner _p];
[_l,_p,_token,_before,_loadout] call TSL_fnc_watchTransfer;
