// ["label"|"edit", botón] — atributo de Eden «Diálogo (ADVSEC)»: muestra cuántos nodos tiene y abre el editor por nodos
params ["_a", "_b"];
switch (_a) do {
    case "label": {
        private _d = ["parse", _b getVariable ["ADVSEC_val", ""]] call ADVSEC_fnc_dlgData;
        private _n = count (_d param [1, []]);
        _b ctrlSetText ([format [("STR_ADVSEC_dlg_attr_n" call ADVSEC_fnc_L), _n], ("STR_ADVSEC_dlg_attr_none" call ADVSEC_fnc_L)] select (_n == 0));
        _b ctrlSetTooltip ("STR_ADVSEC_dlg_attr_tip" call ADVSEC_fnc_L);
    };
    case "edit": {["open", [_b]] call ADVSEC_fnc_dlgEditor};
};
