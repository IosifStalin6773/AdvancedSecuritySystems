// [objetivo, modo] — menú de acciones policiales (sin ACE o desde Zeus)
params ["_target", ["_mode", "unit"]];
if (isNull findDisplay 87100 && {!createDialog "ADVSEC_PoliceMenu"}) exitWith {};
private _disp = findDisplay 87100;
(_disp displayCtrl 87101) ctrlSetText ([format [" POLICÍA MILITAR · %1", [toUpper name _target, "SERVICIO"] select (_mode == "self")], " MI PERSONAJE"] select (_mode == "me"));
private _acts = if (_mode == "me") then {[player] call ADVSEC_fnc_selfChildren} else {[_target, player, _mode] call ADVSEC_fnc_policeChildren};
// Sin ACE no hay submenús: los grupos se aplanan como «Grupo · acción»
private _flat = [];
{
    private _sub = _x param [5, []];
    if (_sub isEqualTo []) then {_flat pushBack _x} else {
        private _g = _x select 1;
        {_flat pushBack [_x select 0, format ["%1 · %2", _g, _x select 1], _x select 2, _x select 3, _x param [4, []]]} forEach _sub;
    };
} forEach _acts;
_acts = _flat;
ADVSEC_pmMenu = [_target, _mode, _acts];
private _lb = _disp displayCtrl 87102;
lbClear _lb;
{
    private _i = _lb lbAdd (_x select 1);
    _lb lbSetPicture [_i, _x select 2];
} forEach _acts;
_lb lbSetCurSel 0;
