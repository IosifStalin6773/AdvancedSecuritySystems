params ['_l','_p','_args',['_requestLoadout',[]]];if (!isServer || {isNull _l} || {isNull _p} || {!isPlayer _p} || {!alive _p} || {_p distance _l>3} || {(_l getVariable ['TSL_owner',''])!=getPlayerUID _p} || {isRemoteExecuted && {remoteExecutedOwner!=owner _p}} || {_l getVariable ['TSL_busy',false]}) exitWith {};
_args params [['_key',''],['_op','']];if !(_key isEqualType '' && {_op in ['take','equip']}) exitWith {};
private _added=_l getVariable ['TSL_editorAdded',[]];private _i=_added findIf {(_x select 0)==_key};if (_i<0) exitWith {};
private _ref=(_added select _i) select 1;private _info=[_ref] call TSL_fnc_gearInfo;if (_info isEqualTo []) exitWith {};
private _poses=_l getVariable ['TSL_editorPoses',[]];private _pi=_poses findIf {(_x select 0)==_key};if (_pi>=0 && {(_poses select _pi) param [2,false]}) exitWith {};
_info params ['_root','_class','_kind','_index'];private _before=if (count _requestLoadout==10) then {parseSimpleArray str _requestLoadout} else {getUnitLoadout _p};private _after=parseSimpleArray str _before;private _ok=false;private _msg='No space. Free an inventory or equipment slot first. / Освободите место или слот снаряжения.';

private _stored=[];private _payloads=_l getVariable ['TSL_gearPayloads',[]];private _si=_payloads findIf {(_x select 0)==_key};private _storedWeapon=[];private _storedContainer=[];private _ammo=-1;
if (_si>=0) then {
 _stored=(_payloads select _si) select 1;_stored params ['_source','_value'];private _actual='';
 if (_source=='cargo') then {private _v=_value select 0;_actual=if (_v isEqualType '') then {_v} else {_v param [0,'']};if (_kind=='weapon' && {_v isEqualType []}) then {_storedWeapon=_v;};if (_kind=='magazine') then {_ammo=_value param [2,-1];};} else {_actual=if (_value isEqualType '') then {_value} else {_value param [0,'']};if (_kind=='weapon') then {_storedWeapon=_value;};if (_kind in ['uniform','vest','backpack']) then {_storedContainer=_value;};};
 if ([_actual,_class] call TSL_fnc_gearClassMatch) then {_class=_actual;} else {_storedWeapon=[];_storedContainer=[];_ammo=-1;};
};
// Large equipment and weapons go into their real slot; never replace an occupied slot.
if (_op=='equip' || {_kind in ['weapon','backpack'] || {_storedContainer isNotEqualTo []}}) then {
 if (_index>=0) then {
  if (_kind in ['nvg','linked']) then {private _assigned=_info param [5,5];if (((_after select 9) select _assigned)=='') then {(_after select 9) set [_assigned,_class];_ok=true;};} else {
   private _old=_after select _index;private _empty=if (_old isEqualType '') then {_old==''} else {_old isEqualTo [] || {(_old param [0,''])==''}};
   if (_empty) then {_after set [_index,switch _kind do {case 'headgear';case 'face':{_class};case 'weapon':{if (_storedWeapon isEqualTo []) then {[_class,'','','',[],[],'']} else {_storedWeapon}};default {if (_storedContainer isEqualTo []) then {[_class,[]]} else {_storedContainer}};}];_ok=true;};
  };
 };
} else {
 private _container=-1;
 if (_p canAddItemToUniform _class) then {_container=3;} else {if (_p canAddItemToVest _class) then {_container=4;} else {if (_p canAddItemToBackpack _class) then {_container=5;};};};
 if (_container>=0) then {private _piece=_after select _container;private _row=if (_kind=='magazine') then {[_class,1,if (_ammo>=0) then {_ammo} else {getNumber (configFile>>'CfgMagazines'>>_class>>'count')}]} else {[_class,1]};(_piece select 1) pushBack _row;_ok=true;};
};
if (!_ok) exitWith {[_msg] remoteExecCall ['TSL_fnc_notice',owner _p];};
private _token=(_l getVariable ['TSL_token',0])+1;_l setVariable ['TSL_token',_token];_l setVariable ['TSL_busy',true,true];
_l setVariable ['TSL_pending',[_token,_p,_l getVariable ['TSL_gear',[]],'editorGear',_key,_ref,_l getVariable ['TSL_editorRevision',0]]];
[_l,_p,_token,_before,_after] remoteExecCall ['TSL_fnc_applyTransfer',owner _p];
[_l,_p,_token,_before,_after] call TSL_fnc_watchTransfer;
