// Resolve before disconnect/mission-end saving. Never silently unlock an applied transfer.
params ['_l'];if (!isServer || {isNull _l} || {!(_l getVariable ['TSL_busy',false])}) exitWith {};
private _pending=_l getVariable ['TSL_pending',[]];private _plan=_l getVariable ['TSL_transferPlan',[]];
if (count _pending<3 || {count _plan!=4} || {(_pending select 0)!=(_plan select 0)}) exitWith {};
_plan params ['_token','_p','_before','_after'];private _ok=false;private _resolved=false;
if (!isNull _p) then {
 private _receipt=_p getVariable ['TSL_transferReceipt',[]];
 if (count _receipt==3 && {(_receipt select 0)==_l} && {(_receipt select 1)==_token} && {(_receipt select 2)isEqualType true}) then {_ok=_receipt select 2;_resolved=true;};
 if (!_resolved) then {
  private _now=[getUnitLoadout _p]call TSL_fnc_canonLoadout;
  if (_now isEqualTo ([_after]call TSL_fnc_canonLoadout)) then {_ok=true;_resolved=true;};
  if (_now isEqualTo ([_before]call TSL_fnc_canonLoadout)) then {_ok=false;_resolved=true;};
 };
};
if (!_resolved) then {
 // Keep a recovery record; do not expose an uncertain taken weapon as available again.
 private _take=if (count _pending>3) then {(_pending select 3)=='editorGear'} else {
  private _oldCount={count _x>0}count(_l getVariable ['TSL_gear',[]]);private _newCount={count _x>0}count(_pending select 2);_newCount<_oldCount
 };
 _ok=_take;private _uid=_l getVariable ['TSL_owner',''];
 if (_uid!='') then {profileNamespace setVariable ['TSL_TransferRecovery_'+_uid,[systemTimeUTC,_pending select [3],_before,_after]];saveProfileNamespace;};
 diag_log '[TS Lockers] Interrupted transfer retained in owner recovery record';
};
[_l,_p,_token,_ok]call TSL_fnc_ack;
