// Abre la base de datos de jugadores de la Policía Militar
if !([player, "playerDB"] call ADVSEC_fnc_perm) exitWith {hint "Tu rango no permite consultar la base de datos de jugadores."};
if (isNull findDisplay 87700 && {!createDialog "ADVSEC_PlayerDB"}) exitWith {};
private _disp = findDisplay 87700;
ADVSEC_pdbRows = [];
ADVSEC_pdbShown = [];
ADVSEC_pdbRights = [false, false, false, 0, 0];
private _f = _disp displayCtrl 87703;
lbClear _f;
{_f lbAdd _x} forEach ["Todos", "En línea", "Policía Militar", "Asuntos Internos", "Con rango global"];
_f lbSetCurSel 0;
private _lvls = {
    params ["_names"];
    private _out = [["Según lista de la misión", -1], ["Sin rango", 0]];
    {_out pushBack [format ["%1 · %2", _forEachIndex + 1, _x], _forEachIndex + 1]} forEach _names;
    _out
};
private _glob = [];
{_glob pushBack [_x, _forEachIndex]} forEach (["ranksGlobal", []] call ADVSEC_fnc_setting);
{
    _x params ["_idc", "_names"];
    private _c = _disp displayCtrl _idc;
    lbClear _c;
    {_c lbSetValue [_c lbAdd (_x select 0), _x select 1]} forEach _names;
} forEach [
    [87710, [["ranksPM", []] call ADVSEC_fnc_setting] call _lvls],
    [87711, [["ranksAI", []] call ADVSEC_fnc_setting] call _lvls],
    [87712, _glob]
];
(_disp displayCtrl 87706) ctrlSetStructuredText parseText "<t color='#8C8C8C'>Consultando el archivo central...</t>";
["refresh"] call ADVSEC_fnc_pdbAction;
