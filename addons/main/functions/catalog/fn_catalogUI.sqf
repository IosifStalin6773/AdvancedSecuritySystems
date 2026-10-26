// [pantalla, acción] — selector de catálogo: "cat" · "search" · "add" · "remove" · "pick" · "list" · "ok" · "cancel"
params ["_d", "_a"];
if (isNull _d) exitWith {};
(_d getVariable ["ADVSEC_cat", []]) params ["_kind", "_entries", "_ok", "_args"];
private _data = [_kind] call ADVSEC_fnc_catalogData;
private _name = {
    params ["_c"];
    private _r = "";
    {
        private _i = (_x select 1) findIf {(_x select 0) == _c};
        if (_i >= 0) exitWith {_r = ((_x select 1) select _i) select 1};
    } forEach _data;
    [_r, _c] select (_r isEqualTo "")
};
switch (_a) do {
    case "cat";
    case "search": {
        // 2º desplegable: lo que hay en la categoría elegida (filtrado por la búsqueda)
        private _cat = _data param [lbCurSel (_d displayCtrl 88102), ["", []]];
        private _q = toLower ctrlText (_d displayCtrl 88106);
        private _cb = _d displayCtrl 88103;
        lbClear _cb;
        {
            _x params ["_c", "_n", "_p"];
            if (_q isEqualTo "" || {(toLower _n) find _q >= 0} || {(toLower _c) find _q >= 0}) then {
                private _i = _cb lbAdd _n;
                _cb lbSetData [_i, _c];
                _cb lbSetPicture [_i, _p];
                _cb lbSetTooltip [_i, _c];
            };
        } forEach (_cat select 1);
        _cb lbSetCurSel 0;
    };
    case "add": {
        private _cb = _d displayCtrl 88103;
        if (lbCurSel _cb < 0) exitWith {};
        private _c = _cb lbData (lbCurSel _cb);
        private _p = round parseNumber ctrlText (_d displayCtrl 88104);
        if (_p <= 0) exitWith {(_d displayCtrl 88110) ctrlSetStructuredText parseText "<t color='#FF6655'>Pon un precio mayor que 0.</t>"};
        // Si ya estaba, se actualiza el precio
        private _i = _entries findIf {(_x select 0) == _c};
        if (_i >= 0) then {(_entries select _i) set [1, _p]} else {_entries pushBack [_c, _p]};
        [_d, "list"] call ADVSEC_fnc_catalogUI;
    };
    case "remove": {
        private _r = lbCurSel (_d displayCtrl 88105);
        if (_r < 0) exitWith {};
        _entries deleteAt _r;
        [_d, "list"] call ADVSEC_fnc_catalogUI;
    };
    case "pick": {
        // Al elegir en la lista se carga su precio para cambiarlo
        private _r = lbCurSel (_d displayCtrl 88105);
        if (_r < 0) exitWith {};
        (_d displayCtrl 88104) ctrlSetText str ((_entries select _r) select 1);
    };
    case "list": {
        private _lb = _d displayCtrl 88105;
        lbClear _lb;
        {
            _x params ["_c", "_p"];
            private _i = _lb lbAdd ([_c] call _name);
            _lb lbSetTextRight [_i, str _p];
            _lb lbSetTooltip [_i, _c];
            _lb lbSetPicture [_i, [[_c] call ADVSEC_fnc_ecoItemPic, getText (configFile >> "CfgVehicles" >> _c >> "picture")] select (_kind == "vehicles")];
        } forEach _entries;
        (_d displayCtrl 88110) ctrlSetStructuredText parseText format ["<t color='#8C8C8C' size='0.9'>%1 en venta. %2</t>", count _entries, ["Elige categoría y artículo, pon el precio y pulsa Añadir. Si lo dejas vacío se usa la lista por defecto.", "Selecciona uno de la lista para cambiar su precio o quitarlo."] select (_entries isNotEqualTo [])];
        if (lbSize (_d displayCtrl 88103) == 0) then {[_d, "cat"] call ADVSEC_fnc_catalogUI};
    };
    case "ok": {
        private _txt = (_entries apply {format ["%1:%2", _x select 0, _x select 1]}) joinString ", ";
        _d closeDisplay 1;
        [_txt, _args] call _ok;
    };
    case "cancel": {_d closeDisplay 2};
};
