// Documentos válidos: el item físico debe estar en el inventario.
// En el servidor se lee el almacén (fuente de verdad); en los clientes, la copia publicada en la unidad (solo interfaz).
params ["_unit"];
private _items = (items _unit) + (assignedItems _unit);
private _docs = if (isServer) then {
    ([] call ADVSEC_fnc_docStore) getOrDefault [[_unit] call ADVSEC_fnc_docKey, []]
} else {
    (_unit getVariable ["ADVSEC_docs", []]) apply {createHashMapFromArray _x}
};
_docs select {(getText (([_x get "type"] call ADVSEC_fnc_docTypeCfg) >> "item")) in _items}
