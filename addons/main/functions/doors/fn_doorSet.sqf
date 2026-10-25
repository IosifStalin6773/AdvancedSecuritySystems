// [edificio, índicePuerta, bloqueada, llamador] (servidor). Desde un cliente se valida: Zeus, requisito de la cerradura o PM para cerrar.
params ["_building", "_idx", "_locked", ["_caller", objNull]];
if (!isServer) exitWith {[_building, _idx, _locked, player] remoteExecCall ["ADVSEC_fnc_doorSet", 2]};
if (isNull _building) exitWith {};
if (call ADVSEC_fnc_fromClient) then {
    if !([_caller, _building, ((boundingBoxReal _building) select 2) + 5] call ADVSEC_fnc_srvCaller) exitWith {_locked = nil};
    if !(
        [_caller] call ADVSEC_fnc_isZeus
        || {[_caller, _building getVariable [format ["ADVSEC_doorReq_%1", _idx], []]] call ADVSEC_fnc_accessCheck}
        || {_locked && {[_caller, "PM"] call ADVSEC_fnc_repAccess}}
    ) then {[_caller, format ["cambiar la puerta %1 de %2", _idx, typeOf _building]] call ADVSEC_fnc_deny; _locked = nil};
};
if (isNil "_locked") exitWith {};
if (!isNull _caller && {isPlayer _caller}) then {["print", _caller, [_building]] call ADVSEC_fnc_evidenceServer};

private _v = [0, 1] select _locked;
_building setVariable [format ["bis_disabled_door_%1", _idx], _v, true];
if (_idx < 10) then {_building setVariable [format ["bis_disabled_door_0%1", _idx], _v, true]};
_building setVariable [format ["ADVSEC_locked_%1", _idx], _locked, true];

if (_locked) then {
    _building animateSource [format ["Door_%1_source", _idx], 0];
    _building animate [format ["Door_%1_rot", _idx], 0];
};
