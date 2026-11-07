params ['_l','_p','_token','_before','_after'];
if (!isServer || {isNull _l}) exitWith {};
_l setVariable ['TSL_transferPlan',[_token,_p,parseSimpleArray str _before,parseSimpleArray str _after]];
[_l,_p,_token,_before,_after] spawn {
 params ['_l','_p','_token','_before','_after'];private _next=diag_tickTime+3;
 while {!isNull _l && {_l getVariable ['TSL_busy',false]} && {((_l getVariable ['TSL_pending',[]]) param [0,-1])==_token}} do {
  private _receipt=if (isNull _p) then {[]} else {_p getVariable ['TSL_transferReceipt',[]]};
  if (count _receipt==3 && {(_receipt select 0)==_l} && {(_receipt select 1)==_token} && {(_receipt select 2)isEqualType true}) exitWith {[_l,_p,_token,_receipt select 2] call TSL_fnc_ack;};
  if (isNull _p || {!isPlayer _p} || {!alive _p}) exitWith {[_l] call TSL_fnc_reconcileTransfer;};
  if (diag_tickTime>=_next) then {
   // Same token and same plan: the client resends its receipt, never grants another copy.
   [_l,_p,_token,_before,_after] remoteExecCall ['TSL_fnc_applyTransfer',owner _p];_next=diag_tickTime+3;
  };
  sleep .2;
 };
};
