if (!createDialog "ADVSEC_ZeusPanel") exitWith {};
private _f = (findDisplay 87000) displayCtrl 87014;
{
    private _i = _f lbAdd (_x select 0);
    _f lbSetData [_i, _x select 1];
    if ((_x select 1) != "") then {_f lbSetPicture [_i, ADVSEC_kindIcons getOrDefault [_x select 1, ""]]};
} forEach ([["Todos", ""]] + (ADVSEC_kindOrder apply {[ADVSEC_kindNames get _x, _x]}));
_f lbSetCurSel 0;
["refresh"] call ADVSEC_fnc_zeusPanelAction;
