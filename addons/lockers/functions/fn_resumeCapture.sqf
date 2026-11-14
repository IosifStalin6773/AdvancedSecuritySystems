// Bind each snapshot to the authenticated owner's pending operation and consume once.
params ['_l','_p','_nonce','_load'];
if (!isServer || {!isRemoteExecuted} || {isNull _l} || {isNull _p} || {remoteExecutedOwner!=owner _p}) exitWith {};
private _pending=_l getVariable ['TSL_capturePending',[]];
if (count _pending!=4 || {(_pending select 0)!=_nonce} || {(_pending select 1)!=_p}) exitWith {};
_l setVariable ['TSL_capturePending',nil];
if (!alive _p || {_p distance _l>3} || {(_l getVariable ['TSL_owner',''])!=getPlayerUID _p} || {_l getVariable ['TSL_busy',false]}) exitWith {['Locker request cancelled: player moved, died or locker changed. / Запрос отменён: изменилось состояние игрока или локера.']remoteExecCall ['TSL_fnc_notice',owner _p];};
if !(_load isEqualType [] && {count _load==10} && {count str _load<250000} && {(_load select 6)isEqualType ''} && {(_load select 7)isEqualType ''} && {(_load select 9)isEqualType []} && {count (_load select 9)==6} && {([0,1,2,3,4,5,8]findIf {!((_load select _x)isEqualType [])})<0}) exitWith {['Close inventory and finish switching weapons, then retry. / Закройте инвентарь и завершите смену оружия.']remoteExecCall ['TSL_fnc_notice',owner _p];};
_l setVariable ['TSL_requestSnapshot',[_p,_pending select 2,_pending select 3,parseSimpleArray str _load]];
[_l,_p,_pending select 2,_pending select 3]call TSL_fnc_request;
_l setVariable ['TSL_requestSnapshot',nil];
