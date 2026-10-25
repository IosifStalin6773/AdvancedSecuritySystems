// [objetivo, modo] — menú de acciones policiales (sin ACE o desde Zeus)
params ["_target", ["_mode", "unit"]];
if (isNull findDisplay 87100 && {!createDialog "ADVSEC_PoliceMenu"}) exitWith {};
private _disp = findDisplay 87100;
(_disp displayCtrl 87101) ctrlSetText format [" POLICÍA MILITAR · %1", [toUpper name _target, "SERVICIO"] select (_mode == "self")];
private _acts = [_target, player, _mode] call ADVSEC_fnc_policeChildren;
ADVSEC_pmMenu = [_target, _mode, _acts];
private _lb = _disp displayCtrl 87102;
lbClear _lb;
{
    private _i = _lb lbAdd (_x select 1);
    _lb lbSetPicture [_i, _x select 2];
} forEach _acts;
_lb lbSetCurSel 0;
