if (!hasInterface) exitWith {};
// Contextual shortcut uses the real ACE menu and a numeric CBA default key.
// It remains usable beside this locker when another addon's key registration fails.
['[TS] Lockers','TSL_InteractLocker','Locker interaction (Windows)',{
 if (!alive player || {count (nearestObjects [player,['Land_TS_Locker_F'],3])==0}) exitWith {false};
 private _opened=[0] call ace_interact_menu_fnc_keyDown;
 missionNamespace setVariable ['TSL_lockerKeyActive',_opened];_opened
},{
 if !(missionNamespace getVariable ['TSL_lockerKeyActive',false]) exitWith {false};
 missionNamespace setVariable ['TSL_lockerKeyActive',false];
 [0,false] call ace_interact_menu_fnc_keyUp;true
},[219,[false,false,false]],false] call CBA_fnc_addKeybind;
TSL_attachInventoryHandlers = {
 params ['_unit'];if (_unit getVariable ['TSL_inventoryHandlers',false]) exitWith {};
 _unit setVariable ['TSL_inventoryHandlers',true];
 private _action=_unit addAction [format ['<t color="#D4C29B">%1</t>',['Open personal locker'] call TSL_fnc_localize],{
  params ['_target','_caller'];
  private _locker=_caller getVariable ['TSL_actionLocker',objNull];
  if (!isNull _locker && {_caller distance _locker<3}) then {[_locker] call TSL_fnc_openUI;};
 },nil,4,false,true,'','alive _this && {(missionNamespace getVariable ["ace_interact_menu_openedMenuType",-1])<0} && {private _locker=[] call TSL_fnc_actionTarget;_this setVariable ["TSL_actionLocker",_locker];!isNull _locker}',3,false,'',''];
 _unit setVariable ['TSL_openAction',_action];
 _unit addEventHandler ['InventoryOpened', {
  params ['_unit','_container'];private _l=_container getVariable ['TSL_locker',objNull];if (_container getVariable ['TSL_inventoryLocked',false]) exitWith {true};if (!isNull _l && {_container!=(_l getVariable ['TSL_crate',objNull])}) exitWith {true};
  if (!isNull _l && {(_l getVariable ['TSL_owner',''])!=getPlayerUID _unit}) exitWith {true};false
 }];
 _unit addEventHandler ['InventoryClosed', {
  params ['_unit','_container'];private _l=_container getVariable ['TSL_locker',objNull];if (!isNull _l) then {[_l,_unit,'save',[]] remoteExecCall ['TSL_fnc_request',2];};
 }];
};
[] spawn {waitUntil {!isNull player};[player] call TSL_attachInventoryHandlers;};
addMissionEventHandler ['EntityRespawned',{params ['_new'];if (local _new && {isPlayer _new}) then {[_new] call TSL_attachInventoryHandlers;};}];

[] spawn {
 waitUntil {!isNull player && {!isNil 'ace_interact_menu_fnc_createAction'}};
 while {true} do {
  {[_x] call TSL_fnc_register;} forEach (allMissionObjects 'Land_TS_Locker_F');
  sleep 2;
 };
};

// Poll public state outside the ACE frame loop, including late join and editor-created lockers.
[] spawn {
 waitUntil {!isNull player};private _known=[];
 while {true} do {
  {if (isNull (_x select 0)) then {{deleteVehicle _x;} forEach (_x select 1);};} forEach _known;
  _known=[];
  {if (_x distance player<100) then {[_x]call TSL_fnc_syncVisuals;};if (_x distance player<8) then {[_x]call TSL_fnc_gearActions;};_known pushBack [_x,_x getVariable ['TSL_clientVisuals',[]]];} forEach (allMissionObjects 'Land_TS_Locker_F');
  sleep .5;
 };
};
