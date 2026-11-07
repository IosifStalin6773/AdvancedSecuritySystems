// ["PM"|"AI"|""] — abre la PDA que lleve el jugador (AA.II. tiene prioridad si lleva las dos)
params [["_mode", ""]];
if (!alive player || {!isNull findDisplay 87200}) exitWith {};
private _inv = items player + assignedItems player;
if (_mode isEqualTo "") then {
    _mode = switch (true) do {
        case ("ADVSEC_PDA_AI" in _inv): {"AI"};
        case ("ADVSEC_PDA_PM" in _inv): {"PM"};
        default {""};
    };
};
// Sin PDA de PM/AA.II.: PDA de metopa (una abre su especialidad; varias, la lista)
if (_mode isEqualTo "") then {
    private _sp = (("true" configClasses (configFile >> "ADVSEC_Specialties")) apply {configName _x}) select {("ADVSEC_PDA_" + _x) in _inv};
    if (_sp isNotEqualTo []) then {_mode = ["#" + (_sp select 0), "#"] select (count _sp > 1)};
};
if (_mode isEqualTo "#") exitWith {[] call ADVSEC_fnc_specOpen};
if ((_mode select [0, 1]) isEqualTo "#") exitWith {[_mode select [1]] call ADVSEC_fnc_specPda};
if !(("ADVSEC_PDA_" + _mode) in _inv) exitWith {hint ("STR_ADVSEC_you_are_not_carrying_any_2" call ADVSEC_fnc_L)};
if !([player, _mode] call ADVSEC_fnc_repAccess) exitWith {
    hint ([("STR_ADVSEC_the_pda_is_locked_you" call ADVSEC_fnc_L), ("STR_ADVSEC_the_pda_is_locked_you_2" call ADVSEC_fnc_L)] select (_mode == "AI"));
};
if (!createDialog "ADVSEC_PDA") exitWith {};
private _disp = findDisplay 87200;
private _ai = _mode == "AI";
ADVSEC_pdaMode = _mode;
ADVSEC_pdaOpen = true;
ADVSEC_pdaList = [_mode, "!FPM02", ""];
ADVSEC_repCurrent = createHashMap;
ADVSEC_repSelect = "";

(_disp displayCtrl 87299) ctrlSetText format ["\x\advsec\addons\main\data\pda_frame_%1_ca.paa", toLower _mode];
(_disp displayCtrl 87201) ctrlSetText format ["%1  ·  PDA-%2", [("STR_ADVSEC_military_police_3" call ADVSEC_fnc_L), ("STR_ADVSEC_internal_affairs_2" call ADVSEC_fnc_L)] select _ai, (getPlayerUID player) select [((count getPlayerUID player) - 4) max 0]];
{(_disp displayCtrl (87210 + _forEachIndex)) ctrlSetText _x} forEach [("STR_ADVSEC_home" call ADVSEC_fnc_L), [("STR_ADVSEC_reports" call ADVSEC_fnc_L), ("STR_ADVSEC_case_files" call ADVSEC_fnc_L)] select _ai, ("STR_ADVSEC_complaints" call ADVSEC_fnc_L), ("STR_ADVSEC_wanted_2" call ADVSEC_fnc_L)];

private _tiles = if (_ai) then {
    [[("STR_ADVSEC_open_case_file" call ADVSEC_fnc_L), "documents", "newCase"], [("STR_ADVSEC_suspicion_index_2" call ADVSEC_fnc_L), "danger", "heat"], [("STR_ADVSEC_case_files" call ADVSEC_fnc_L), "intel", "listReports"],
     [("STR_ADVSEC_dispatch_query" call ADVSEC_fnc_L), "radio", "query"], [("STR_ADVSEC_evidence_log" call ADVSEC_fnc_L), "box", "evidence"], [("STR_ADVSEC_body_cameras" call ADVSEC_fnc_L), "scout", "bodycam"]]
} else {
    [[("STR_ADVSEC_dispatch_query" call ADVSEC_fnc_L), "radio", "query"], [("STR_ADVSEC_new_report" call ADVSEC_fnc_L), "documents", "newReport"], [("STR_ADVSEC_complaints" call ADVSEC_fnc_L), "talk", "listComplaints"],
     [("STR_ADVSEC_evidence_log" call ADVSEC_fnc_L), "box", "evidence"], [[("STR_ADVSEC_wanted_2" call ADVSEC_fnc_L), "target", "wanted"], [("STR_ADVSEC_body_cameras" call ADVSEC_fnc_L), "scout", "bodycam"]] select ([player, "bodycamView"] call ADVSEC_fnc_perm), [("STR_ADVSEC_my_documents" call ADVSEC_fnc_L), "meet", "docs"]]
};
ADVSEC_pdaTiles = _tiles apply {_x select 2};
{
    _x params ["_label", "_icon"];
    (_disp displayCtrl (87270 + _forEachIndex)) ctrlSetText format ["\A3\ui_f\data\igui\cfg\simpleTasks\types\%1_ca.paa", _icon];
    (_disp displayCtrl (87280 + _forEachIndex)) ctrlSetText _label;
} forEach _tiles;

(_disp displayCtrl 87231) ctrlSetStructuredText parseText format [
    ("STR_ADVSEC_credentials_verified_opens_and_closes" call ADVSEC_fnc_L),
    [[player] call ADVSEC_fnc_rankTitle, [player] call ADVSEC_fnc_rankName] select (([player] call ADVSEC_fnc_rankTitle) isEqualTo ""), [name player] call ADVSEC_fnc_repEsc, [groupId group player] call ADVSEC_fnc_repEsc,
    (["pda"] call ADVSEC_fnc_keyCurrent) call ADVSEC_fnc_keyName
];

[_disp] spawn {
    params ["_disp"];
    while {!isNull _disp} do {
        date params ["_y", "_m", "_d"];
        (_disp displayCtrl 87202) ctrlSetText format ["%1  ·  %2/%3/%4  ·  %5", mapGridPosition player, _d, _m, _y, [dayTime, "HH:MM"] call BIS_fnc_timeToString];
        sleep 1;
    };
};
playSound "FD_Start_F";
["tab", 0] call ADVSEC_fnc_pdaAction;
