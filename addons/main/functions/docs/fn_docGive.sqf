// [unidad, item, mensaje] — donde la unidad es local: entrega el item del documento si falta (salvo incautado)
params ["_unit", "_item", ["_msg", ""]];
if (!local _unit || {_item isEqualTo ""}) exitWith {};
if (!(_item in (items _unit + assignedItems _unit)) && {!(_item in (_unit getVariable ["ADVSEC_seized", []]))}) then {
    if (_unit canAdd _item) then {_unit addItem _item} else {_unit addItemToUniform _item};
};
if (_msg isNotEqualTo "" && {_unit isEqualTo player}) then {hint _msg};
