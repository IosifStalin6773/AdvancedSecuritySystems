/*
    [edificio, índices ([1,2] | "1,2" | "all"), requisito, bloqueadaInicial]
    requisito: ver ADVSEC_fnc_accessCheck, p.ej. [-1, [], "LLAVE_ALMACEN"] o [2, ["IDCard"], ""]
*/
params ["_building", ["_doors", "all"], ["_req", []], ["_locked", true]];
if (isServer && {!(call ADVSEC_fnc_trustedInit)}) exitWith {};
if (isNull _building) exitWith {};
_doors = [_building, _doors] call ADVSEC_fnc_doorList;
if (isServer) then {[_building, "door", getText (configOf _building >> "displayName"), _doors] call ADVSEC_fnc_register};
[_building, _doors] call ADVSEC_fnc_breachActions;
if (isServer) then {
    {
        _building setVariable [format ["ADVSEC_doorReq_%1", _x], _req];
        [_building, _x, _locked] call ADVSEC_fnc_doorSet;
    } forEach _doors;
};
if (_req isEqualTo []) exitWith {};

{
    [_building, format ["advsec_door_%1", _x], format ["Cerradura (puerta %1)", _x], ADVSEC_icKey,
        {
            _args params ["_i"];
            private _lock = !(_target getVariable [format ["ADVSEC_locked_%1", _i], false]);
            [_target, _i, _lock] call ADVSEC_fnc_doorSet;
            hint (["Puerta desbloqueada.", "Puerta bloqueada."] select _lock);
        },
        {[_player, _args select 1] call ADVSEC_fnc_accessCheck},
        "root", [_x, _req], 2.5, format ["Door_%1_trigger", _x]
    ] call ADVSEC_fnc_addInteraction;
} forEach _doors;
