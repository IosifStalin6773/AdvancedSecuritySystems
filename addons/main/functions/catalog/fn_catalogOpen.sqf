/*
    [tipo, catálogoActual, alAceptar, args, título, pantallaPadre]
    Selector de catálogo con dos desplegables (categoría -> objeto o vehículo) y precio.
    tipo: "items" | "vehicles" · catálogoActual: "clase:precio, ..." · alAceptar recibe [texto, args]
*/
params [["_kind", "items"], ["_cur", ""], ["_ok", {}], ["_args", []], ["_title", "CATÁLOGO"], ["_parent", displayNull]];
private _d = if (isNull _parent) then {createDialog "ADVSEC_CatalogDlg"; findDisplay 88100} else {_parent createDisplay "ADVSEC_CatalogDlg"};
if (isNull _d) exitWith {};
private _entries = ((_cur splitString ",") apply {(_x splitString ":") apply {_x trim [" ", 0]}}) select {count _x == 2} apply {[_x select 0, parseNumber (_x select 1)]};
_d setVariable ["ADVSEC_cat", [_kind, _entries, _ok, _args]];
(_d displayCtrl 88101) ctrlSetText (" " + _title);
(_d displayCtrl 88110) ctrlSetStructuredText parseText "<t color='#8C8C8C' size='0.9'>Cargando lista...</t>";
private _cats = _d displayCtrl 88102;
{_cats lbAdd format ["%1 (%2)", _x select 0, count (_x select 1)]} forEach ([_kind] call ADVSEC_fnc_catalogData);
_cats lbSetCurSel 0;
(_d displayCtrl 88104) ctrlSetText (["100", "5000"] select (_kind == "vehicles"));
[_d, "list"] call ADVSEC_fnc_catalogUI;
