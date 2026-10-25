// [unidad, item, añadir] — local: añade o retira una bolsa de pruebas
params ["_unit", "_item", ["_add", true]];
if (!local _unit) exitWith {};
if (_add) then {_unit addItem _item} else {_unit removeItem _item};
