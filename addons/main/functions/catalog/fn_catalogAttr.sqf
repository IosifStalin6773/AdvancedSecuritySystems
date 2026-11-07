// ["label"|"edit", botón] — atributo de Eden para tiendas y concesionarios: muestra cuántos hay y abre el selector
params ["_a", "_b"];
private _val = _b getVariable ["ADVSEC_val", ""];
private _kind = _b getVariable ["ADVSEC_kind", "items"];
switch (_a) do {
    case "label": {
        private _n = count ((_val splitString ",") select {_x find ":" > 0});
        _b ctrlSetText ([format [("STR_ADVSEC_choose_from_catalog_for_sale" call ADVSEC_fnc_L), _n], ("STR_ADVSEC_choose_from_catalog_empty_default" call ADVSEC_fnc_L)] select (_n == 0));
        _b ctrlSetTooltip ([_val, ("STR_ADVSEC_no_items_the_default_list" call ADVSEC_fnc_L)] select (_n == 0));
    };
    case "edit": {
        [_kind, _val, {
            params ["_txt", "_b"];
            _b setVariable ["ADVSEC_val", _txt];
            ["label", _b] call ADVSEC_fnc_catalogAttr;
        }, _b, [("STR_ADVSEC_shop_catalog" call ADVSEC_fnc_L), ("STR_ADVSEC_dealer_vehicles" call ADVSEC_fnc_L)] select (_kind == "vehicles"), ctrlParent _b] call ADVSEC_fnc_catalogOpen;
    };
};
