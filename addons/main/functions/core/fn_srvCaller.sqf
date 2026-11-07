/*
    [llamador, objeto, distanciaMáx] -> bool (servidor)
    Valida una petición remota: el llamador debe ser la unidad del cliente que la envía y, si se indica, estar cerca del objeto.
    Las llamadas del propio servidor o anfitrión siempre pasan.
*/
params ["_caller", ["_obj", objNull], ["_dist", -1]];
if !(call ADVSEC_fnc_fromClient) exitWith {true};
if (isNull _caller || {!alive _caller} || {remoteExecutedOwner != owner _caller}) exitWith {
    diag_log format [("STR_ADVSEC_advsec_request_rejected_caller_does" call ADVSEC_fnc_L), _caller, remoteExecutedOwner];
    false
};
if (_dist > 0 && {!isNull _obj} && {(_caller distance _obj) > _dist} && {!([_caller] call ADVSEC_fnc_isZeus)}) exitWith {false};
true
