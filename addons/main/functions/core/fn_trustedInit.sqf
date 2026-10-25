// -> bool (servidor): un init de objeto llega del propio servidor o de un Zeus/administrador (no de cualquier cliente)
if !(call ADVSEC_fnc_fromClient) exitWith {true};
private _o = remoteExecutedOwner;
private _ok = (allPlayers findIf {owner _x == _o && {[_x] call ADVSEC_fnc_isZeus}}) > -1;
if (!_ok) then {diag_log format ["[ADVSEC] Init de objeto rechazado: el cliente %1 no es Zeus ni administrador", _o]};
_ok
