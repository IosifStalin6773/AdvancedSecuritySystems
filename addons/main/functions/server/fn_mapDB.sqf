// [clave de perfil, variable] (servidor) -> hashmap persistido como pares [clave, valor] (lo crea si no existe)
params ["_k", "_var"];
private _h = localNamespace getVariable _var;
if (!isNil "_h") exitWith {_h};
if (isNil "ADVSEC_repKey") then {[] call ADVSEC_fnc_repLoad};
_h = createHashMap;
{if (_x isEqualType [] && {count _x == 2}) then {_h set [_x select 0, +(_x select 1)]}} forEach (profileNamespace getVariable [ADVSEC_repKey + "_" + _k, []]);
localNamespace setVariable [_var, _h];
_h
