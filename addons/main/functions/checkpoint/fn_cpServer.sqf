// ["show"|"refuse", llamador, vehículo] (servidor) — respuesta de un ocupante al control
params ["_a", "_caller", "_veh"];
if (!isServer || {isNull _veh}) exitWith {};
if !([_caller, _veh, 15] call ADVSEC_fnc_srvCaller) exitWith {};
if (!(_caller in crew _veh) || {!(_veh getVariable ["ADVSEC_cpHold", false])}) exitWith {};
private _var = ["ADVSEC_cpRefused", "ADVSEC_cpShown"] select (_a == "show");
private _l = _veh getVariable [_var, []];
_l pushBackUnique getPlayerUID _caller;
_veh setVariable [_var, _l];
