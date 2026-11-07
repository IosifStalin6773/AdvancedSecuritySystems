// Abre la base de datos de jugadores de la Policía Militar
if !([player, "playerDB"] call ADVSEC_fnc_perm) exitWith {hint ("STR_ADVSEC_your_rank_does_not_allow_6" call ADVSEC_fnc_L)};
if (isNull findDisplay 87700 && {!createDialog "ADVSEC_PlayerDB"}) exitWith {};
private _disp = findDisplay 87700;
ADVSEC_pdbRows = [];
ADVSEC_pdbShown = [];
ADVSEC_pdbRights = [false, false, false, 0, 0];
private _f = _disp displayCtrl 87703;
lbClear _f;
{_f lbAdd _x} forEach [("STR_ADVSEC_all" call ADVSEC_fnc_L), ("STR_ADVSEC_online_2" call ADVSEC_fnc_L), ("STR_ADVSEC_military_police" call ADVSEC_fnc_L), ("STR_ADVSEC_internal_affairs" call ADVSEC_fnc_L), ("STR_ADVSEC_with_global_rank" call ADVSEC_fnc_L)];
_f lbSetCurSel 0;
private _lvls = {
    params ["_names"];
    private _out = [[("STR_ADVSEC_from_the_mission_list" call ADVSEC_fnc_L), -1], [("STR_ADVSEC_no_rank" call ADVSEC_fnc_L), 0]];
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
(_disp displayCtrl 87706) ctrlSetStructuredText parseText ("STR_ADVSEC_querying_the_central_archive" call ADVSEC_fnc_L);
["refresh"] call ADVSEC_fnc_pdbAction;
