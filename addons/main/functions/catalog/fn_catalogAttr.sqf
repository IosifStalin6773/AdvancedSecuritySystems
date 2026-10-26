// ["label"|"edit", botón] — atributo de Eden para tiendas y concesionarios: muestra cuántos hay y abre el selector
params ["_a", "_b"];
private _val = _b getVariable ["ADVSEC_val", ""];
private _kind = _b getVariable ["ADVSEC_kind", "items"];
switch (_a) do {
    case "label": {
        private _n = count ((_val splitString ",") select {_x find ":" > 0});
        _b ctrlSetText ([format ["Elegir del catálogo (%1 en venta)", _n], "Elegir del catálogo (vacío = lista por defecto)"] select (_n == 0));
        _b ctrlSetTooltip ([_val, "Sin artículos: se usa la lista por defecto de ADVSEC_Settings."] select (_n == 0));
    };
    case "edit": {
        [_kind, _val, {
            params ["_txt", "_b"];
            _b setVariable ["ADVSEC_val", _txt];
            ["label", _b] call ADVSEC_fnc_catalogAttr;
        }, _b, ["CATÁLOGO DE LA TIENDA", "VEHÍCULOS DEL CONCESIONARIO"] select (_kind == "vehicles"), ctrlParent _b] call ADVSEC_fnc_catalogOpen;
    };
};
