/*
    [unidad, uso] -> bool (1.24). Con pmItemsRequired = 1, el uso (pmItemUse) necesita llevar uno de sus objetos.
    En el cliente avisa con un hint de qué falta.
*/
params ["_unit", "_use"];
if ((["pmItemsRequired", 0] call ADVSEC_fnc_setting) isNotEqualTo 1) exitWith {true};
private _need = ((["pmItemUse", []] call ADVSEC_fnc_setting) select {(_x select 0) == _use}) param [0, ["", []]] select 1;
if (_need isEqualTo []) exitWith {true};
private _have = (items _unit) + (assignedItems _unit);
if (_need findIf {_x in _have} >= 0) exitWith {true};
if (hasInterface && {_unit == player}) then {
    hint format [("STR_ADVSEC_item_needed" call ADVSEC_fnc_L), (_need select {isClass (configFile >> "CfgWeapons" >> _x) || {isClass (configFile >> "CfgMagazines" >> _x)}}) apply {[_x] call ADVSEC_fnc_ecoItemName} joinString " / "];
};
false
