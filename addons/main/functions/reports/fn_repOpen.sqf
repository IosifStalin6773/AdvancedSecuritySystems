// ["PM"|"AI"|"BOTH"]
params [["_dept", "PM"]];
private _canPM = [player, "PM"] call ADVSEC_fnc_repAccess;
private _canAI = [player, "AI"] call ADVSEC_fnc_repAccess;
if (!_canPM && {!_canAI}) exitWith {hint ("STR_ADVSEC_you_need_a_military_police_2" call ADVSEC_fnc_L)};
if (!createDialog "ADVSEC_Reports") exitWith {};
private _disp = findDisplay 86600;
(_disp displayCtrl 86601) ctrlSetText ("STR_ADVSEC_report_registry_military_police_and" call ADVSEC_fnc_L);
ADVSEC_repCurrent = createHashMap;
ADVSEC_repSelect = "";

private _cb = _disp displayCtrl 86610;
private _opts = [];
if (_canPM && {_dept != "AI"}) then {_opts pushBack [("STR_ADVSEC_military_police" call ADVSEC_fnc_L), "PM"]};
if (_canAI && {_dept != "PM" || {!_canPM}}) then {_opts pushBack [("STR_ADVSEC_internal_affairs" call ADVSEC_fnc_L), "AI"]};
if (count _opts > 1) then {_opts pushBack [("STR_ADVSEC_all" call ADVSEC_fnc_L), "ALL"]};
if (_opts isEqualTo []) then {_opts = [[("STR_ADVSEC_internal_affairs" call ADVSEC_fnc_L), "AI"]]};
{
    private _i = _cb lbAdd (_x select 0);
    _cb lbSetData [_i, _x select 1];
} forEach _opts;
_cb lbSetCurSel 0;
["refresh"] call ADVSEC_fnc_repAction;
