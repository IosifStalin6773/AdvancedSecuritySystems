// Only the server may request a local inventory snapshot.
params ['_l','_p','_nonce'];
if (!isRemoteExecuted || {remoteExecutedOwner!=2} || {isNull _l} || {isNull _p} || {!local _p} || {_p!=player}) exitWith {};
private _ready=alive _p && {!isSwitchingWeapon _p} && {isNull findDisplay 602};
[_l,_p,_nonce,if (_ready) then {getUnitLoadout _p} else {[]}]remoteExecCall ['TSL_fnc_resumeCapture',2];
