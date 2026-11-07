params ['_l','_p','_token','_before','_after'];
if (isRemoteExecuted && {remoteExecutedOwner!=2}) exitWith {};
if (isNull _l || {isNull _p} || {!local _p}) exitWith {};
private _ok=false;
private _restoreAmmo={
 params ['_unit','_load','_changed'];
 {
  private _index=_x;private _piece=_load select _index;
  if (_index in _changed && {_piece isEqualType []} && {count _piece==2} && {(_piece select 0)!=''}) then {
   private _container=[uniformContainer _unit,vestContainer _unit,backpackContainer _unit] select (_index-3);
   if (!isNull _container) then {
    clearMagazineCargoGlobal _container;
    {if (count _x==3 && {(_x select 0) isEqualType ''}) then {_container addMagazineAmmoCargo [_x select 0,_x select 1,_x select 2];};} forEach (_piece select 1);
   };
  };
 } forEach [3,4,5];
};
private _canon=TSL_fnc_canonLoadout;
private _journal=_l getVariable ['TSL_clientTransferJournal',createHashMap];private _id=str _token;
private _cached=_journal getOrDefault [_id,[]];
private _high=_l getVariable ['TSL_clientTransferHighWater',-1];
if (_token<_high && {_cached isEqualTo []}) exitWith {};
_l setVariable ['TSL_clientTransferHighWater',_token max _high];
private _beforeKey=str ([_before]call _canon);private _afterKey=str ([_after]call _canon);
if (_cached isNotEqualTo []) exitWith {
 if ((_cached select 0)==_beforeKey && {(_cached select 1)==_afterKey}) then {
  _p setVariable ['TSL_transferReceipt',[_l,_token,_cached select 2],2];
  [_l,_p,_token,_cached select 2]remoteExecCall['TSL_fnc_ack',2];
 };
};
private _now=getUnitLoadout _p;private _changed=[];
{if ((_before select _x)isNotEqualTo(_after select _x)) then {_changed pushBack _x;};}forEach [0,1,2,3,4,5,6,7,8,9];
private _matches={params ['_expected'];private _left=parseSimpleArray str _now;private _right=parseSimpleArray str _expected;{if !(_x in _changed) then {_left set [_x,[]];_right set [_x,[]];};}forEach [0,1,2,3,4,5,6,7,8,9];([_left]call _canon)isEqualTo([_right]call _canon)};
private _alreadyApplied=([_after]call _matches) && {_changed isNotEqualTo []};
_ok=([_before]call _matches) && {!isSwitchingWeapon _p} && {isNull findDisplay 602};

if (_ok) then {
 private _delta=[];_delta resize 10;private _changed=[];
 {if ((_before select _x) isNotEqualTo (_after select _x)) then {_delta set [_x,_after select _x];_changed pushBack _x;};} forEach [0,1,2,3,4,5,6,7,8,9];
 if ((_changed findIf {!(_x in [6,7,9])})==-1) then {
  if (6 in _changed) then {removeHeadgear _p;if ((_after select 6)!='') then {_p addHeadgear (_after select 6);};};
  if (7 in _changed) then {removeGoggles _p;if ((_after select 7)!='') then {_p addGoggles (_after select 7);};};
  if (9 in _changed) then {for '_i' from 0 to 5 do {private _old=(_before select 9) select _i;private _new=(_after select 9) select _i;if (_old!=_new) then {if (_old!='') then {_p unlinkItem _old;};if (_new!='') then {_p linkItem _new;};};};};
 } else {_p setUnitLoadout [_delta,false];[_p,_after,_changed] call _restoreAmmo;};
 _now=getUnitLoadout _p;_ok=[_after]call _matches;
 if (!_ok) then {private _rollback=[];_rollback resize 10;{_rollback set [_x,_before select _x];}forEach _changed;_p setUnitLoadout [_rollback,false];[_p,_before,_changed] call _restoreAmmo;};
};
if (_alreadyApplied) then {_ok=true;};
if (count _journal>64) then {private _ids=keys _journal;_ids=_ids apply {parseNumber _x};_ids sort true;for '_i' from 0 to (count _ids-49) do {_journal deleteAt str (_ids select _i);};};
_journal set [_id,[_beforeKey,_afterKey,_ok]];_l setVariable ['TSL_clientTransferJournal',_journal];
_p setVariable ['TSL_transferReceipt',[_l,_token,_ok],2];
if (!_ok) then {hint 'Equipment slot changed during transfer. Retry. / Слот изменился во время переноса. Повторите.';diag_log format ['[TS Lockers] Transfer rejected: token %1 locker %2 changed slots %3',_token,netId _l,_changed];};
[_l,_p,_token,_ok] remoteExecCall ['TSL_fnc_ack',2];
