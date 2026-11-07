params ['_p'];if (!isServer || {isRemoteExecuted} || {isNull _p}) exitWith {};
[_p] spawn {
 params ['_p'];private _deadline=diag_tickTime+120;
 waitUntil {sleep .25;isNull _p || {!isPlayer _p} || {alive _p && {getPlayerUID _p!=''}} || {diag_tickTime>_deadline}};
 if (isNull _p || {!isPlayer _p} || {!alive _p}) exitWith {};
 private _uid=getPlayerUID _p;if (_uid=='' || {!isNull(TSL_uidMap getOrDefault [_uid,objNull])}) exitWith {};
 private _key=[_uid]call TSL_fnc_scenarioKey;private _binding=profileNamespace getVariable [_key+'_Locker',[]];
 if !(count _binding==6 && {(_binding select 0)==1}) exitWith {};
 _binding params ['_version','_class','_name','_position','_dir','_up'];
 if !(_class in ['Land_TS_Locker_F','Land_TS_Locker_Velcro_F','Land_TS_Locker_Decorated_F']) exitWith {};
 // Let scenario scripts finish creating their lockers before considering a replacement.
 sleep 3;
 private _locker=objNull;
 if (_name!='') then {private _named=missionNamespace getVariable [_name,objNull];if (_named isEqualType objNull && {!isNull _named} && {_named isKindOf 'Land_TS_Locker_F'}) then {_locker=_named;};};
 if (isNull _locker) then {
  private _near=(allMissionObjects 'Land_TS_Locker_F') select {(getPosWorld _x)distance _position<.75};
  if (_near isNotEqualTo []) then {private _distance=1e10;{private _d=(getPosWorld _x)distance _position;if (_d<_distance) then {_distance=_d;_locker=_x;};}forEach _near;};
 };
 if (!isNull _locker && {(_locker getVariable ['TSL_owner',''])!=''} && {(_locker getVariable ['TSL_owner',''])!=_uid}) exitWith {['Your previous locker is occupied. Claim another free locker.']remoteExecCall['TSL_fnc_notice',owner _p];};
 if (isNull _locker) then {
  _locker=createVehicle [_class,ASLToAGL _position,[],0,'CAN_COLLIDE'];
  _locker setVectorDirAndUp [_dir,_up];_locker setPosWorld _position;
  if (_name!='' && {isNil{missionNamespace getVariable _name}}) then {_locker setVehicleVarName _name;missionNamespace setVariable [_name,_locker,true];};
 };
 [_locker]call TSL_fnc_init;private _until=diag_tickTime+15;
 waitUntil {sleep .1;isNull _locker || {_locker getVariable ['TSL_ready',false]} || {diag_tickTime>_until}};
 if (isNull _locker || {!(_locker getVariable ['TSL_ready',false])} || {isNull _p} || {!isPlayer _p} || {!alive _p}) exitWith {};
 // Only this server-side path may claim at login without a distance check.
 _locker setVariable ['TSL_autoClaimUID',_uid];[_locker,_p,'claim',[]]call TSL_fnc_request;_locker setVariable ['TSL_autoClaimUID',nil];
};
