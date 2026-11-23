// [herido] (cliente, 1.24): con la camilla, el herido va tumbado detrás del agente; otra vez para dejarlo
params ["_u"];
if ((attachedTo _u) isEqualTo player) exitWith {
    detach _u;
    _u setPosATL (player getRelPos [1.5, 180]);
    player forceWalk false;
};
_u attachTo [player, [0, -1.6, 0.25]];
[_u, 90] remoteExecCall ["setDir", _u];
[_u, "AinjPpneMstpSnonWnonDnon"] remoteExecCall ["switchMove", 0];
player forceWalk true;
