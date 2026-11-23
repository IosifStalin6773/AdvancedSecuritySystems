if (!isServer) exitWith {};
TSL_registry = []; TSL_uidMap = createHashMap;
addMissionEventHandler ['PlayerDisconnected', {
 params ['_id','_uid'];private _l=TSL_uidMap getOrDefault [_uid,objNull];
 if (!isNull _l) then {[_l]call TSL_fnc_reconcileTransfer;[_l] call TSL_fnc_save;[_l] call TSL_fnc_clear;TSL_uidMap deleteAt _uid;};
}];
[] spawn {
 while {true} do {
  sleep 3;
  {if !(_x getVariable ['TSL_initialized',false]) then {[_x] call TSL_fnc_init;};} forEach (allMissionObjects 'Land_TS_Locker_F');
  {if (!isNull _x && {(_x getVariable ['TSL_owner',''])!=''} && {!(_x getVariable ['TSL_busy',false])}) then {[_x] call TSL_fnc_save;};} forEach TSL_registry;
  {if (!isNull _x) then {private _pose=[getPosWorld _x,vectorDir _x,vectorUp _x];if (_pose isNotEqualTo(_x getVariable ['TSL_lastPollPose',[]])) then {_x setVariable ['TSL_lastPollPose',_pose];[_x]call TSL_fnc_render;};};}forEach TSL_registry;
  TSL_registry=TSL_registry select {!isNull _x};
 };
};

// Commit the last stable state before changing mission or map on this server profile.
addMissionEventHandler ['Ended',{
 {if (!isNull _x) then {[_x]call TSL_fnc_reconcileTransfer;[_x]call TSL_fnc_save;};}forEach TSL_registry;
}];

// Handle remote players, listen-server host and reconnecting/JIP units uniformly.
[]spawn {
 private _seen=createHashMap;
 while {true} do {
  private _online=[];
  {private _uid=getPlayerUID _x;if (_uid!='') then {
   _online pushBack _uid;private _identity=[_x,owner _x];
   if (_identity isNotEqualTo(_seen getOrDefault [_uid,[]])) then {_seen set [_uid,_identity];[_x]call TSL_fnc_autoResume;};
  };}forEach allPlayers;
  {if !(_x in _online)then{_seen deleteAt _x;};}forEach keys _seen;
  sleep 1;
 };
};
