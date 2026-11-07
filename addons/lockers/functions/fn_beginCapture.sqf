// Server-only, one outstanding capture per locker; no shared global transfer lock.
params ['_l','_p','_op','_args'];
if (!isServer || {isNull _l} || {isNull _p} || {_l getVariable ['TSL_busy',false]}) exitWith {};
private _nonce=(_l getVariable ['TSL_captureToken',0])+1;
_l setVariable ['TSL_captureToken',_nonce];
_l setVariable ['TSL_capturePending',[_nonce,_p,_op,parseSimpleArray str _args]];
[_l,_p,_nonce]remoteExecCall ['TSL_fnc_captureInventory',owner _p];
[_l,_p,_nonce]spawn {
 params ['_l','_p','_nonce'];private _deadline=diag_tickTime+20;
 while {!isNull _l && {((_l getVariable ['TSL_capturePending',[]])param [0,-1])==_nonce}} do {
  sleep 4;
  if (isNull _l || {((_l getVariable ['TSL_capturePending',[]])param [0,-1])!=_nonce}) exitWith {};
  if (diag_tickTime>=_deadline || {isNull _p} || {!alive _p}) exitWith {
   _l setVariable ['TSL_capturePending',nil];
   if (!isNull _p) then {['Locker inventory request timed out. Check that the server and client use the same addon. / Локер не получил ответ. Проверьте версии мода.']remoteExecCall ['TSL_fnc_notice',owner _p];};
   diag_log format ['[TS Lockers] Inventory capture timeout: locker %1 token %2',netId _l,_nonce];
  };
  if (((_l getVariable ['TSL_capturePending',[]])param [0,-1])==_nonce) then {[_l,_p,_nonce]remoteExecCall ['TSL_fnc_captureInventory',owner _p];};
 };
};
