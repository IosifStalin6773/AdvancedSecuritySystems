// -> bool (servidor): un init de objeto llega del propio servidor o de un Zeus/administrador (no de cualquier cliente)
if !(call ADVSEC_fnc_fromClient) exitWith {true};
private _o = remoteExecutedOwner;
private _ok = (allPlayers findIf {owner _x == _o && {[_x] call ADVSEC_fnc_isZeus}}) > -1;
if (!_ok) then {diag_log format [("STR_ADVSEC_advsec_object_init_rejected_client" call ADVSEC_fnc_L), _o]};
_ok
