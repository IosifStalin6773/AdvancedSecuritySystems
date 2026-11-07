params ["_r"];
private _disp = [] call ADVSEC_fnc_repDisp;
if (isNull _disp) exitWith {};
private _ctrl = _disp displayCtrl 86603;
if (count _r == 0) exitWith {_ctrl ctrlSetStructuredText parseText ("STR_ADVSEC_no_reports_use_new_report" call ADVSEC_fnc_L)};

private _e = {[_this] call ADVSEC_fnc_repEsc};
private _row = {params ["_k", "_v"]; format ["<t color='#8C8C8C'>%1:</t> %2<br/>", _k, _v call _e]};
private _txt = format [
    "<t size='1.4' font='RobotoCondensedBold'>%1</t><br/><t color='#D0A330'>%2 · %3</t><br/><br/>",
    (_r get "id") call _e, (_r get "typeName") call _e, [("STR_ADVSEC_military_police_3" call ADVSEC_fnc_L), ("STR_ADVSEC_internal_affairs_2" call ADVSEC_fnc_L)] select ((_r get "dept") == "AI")
];
if (_r getOrDefault ["confidential", false]) then {_txt = _txt + ("STR_ADVSEC_confidential_ia_only" call ADVSEC_fnc_L)};
{_txt = _txt + (_x call _row)} forEach [
    [("STR_ADVSEC_subject" call ADVSEC_fnc_L), _r get "title"],
    [("STR_ADVSEC_status" call ADVSEC_fnc_L), (_r get "status" call ADVSEC_fnc_Lv)],
    [("STR_ADVSEC_severity" call ADVSEC_fnc_L), (_r get "gravity" call ADVSEC_fnc_Lv)],
    [("STR_ADVSEC_sanction" call ADVSEC_fnc_L), (_r getOrDefault ["sanction", "Ninguna"] call ADVSEC_fnc_Lv)],
    [("STR_ADVSEC_involved_2" call ADVSEC_fnc_L), (_r getOrDefault ["subjects", []]) joinString "; "],
    [("STR_ADVSEC_facts_date_place" call ADVSEC_fnc_L), _r getOrDefault ["place", ""]],
    [("STR_ADVSEC_evidence_witnesses" call ADVSEC_fnc_L), _r getOrDefault ["witnesses", ""]],
    [("STR_ADVSEC_logged_by" call ADVSEC_fnc_L), format ["%1 [%2]", _r get "author", _r get "authorUid"]],
    [("STR_ADVSEC_log" call ADVSEC_fnc_L), format ["%1 · %2", _r get "created", _r getOrDefault ["mission", ""]]],
    [("STR_ADVSEC_last_modified" call ADVSEC_fnc_L), _r get "updated"]
];
_txt = _txt + ("STR_ADVSEC_description" call ADVSEC_fnc_L) + ((_r getOrDefault ["body", ""]) call _e) + "<br/>";

private _notes = _r getOrDefault ["notes", []];
if (_notes isNotEqualTo []) then {
    _txt = _txt + ("STR_ADVSEC_notes_2" call ADVSEC_fnc_L);
    {
        _x params ["_ts", "_name", "_uid", "_note"];
        _txt = _txt + format ["<t color='#8C8C8C'>%1 · %2 [%3]</t><br/>%4<br/>", _ts, _name call _e, _uid, _note call _e];
    } forEach _notes;
};
private _access = _r getOrDefault ["access", []];
if (_access isNotEqualTo []) then {
    _txt = _txt + ("STR_ADVSEC_access_log" call ADVSEC_fnc_L);
    {_x params ["_ts", "_name", "_uid"]; _txt = _txt + format ["<t color='#8C8C8C' size='0.85'>%1 · %2 [%3]</t><br/>", _ts, _name call _e, _uid]} forEach (_access select [(count _access - 15) max 0]);
};

_ctrl ctrlSetStructuredText parseText _txt;
_ctrl ctrlSetPositionH ((ctrlTextHeight _ctrl) max (((ctrlPosition (_disp displayCtrl 86620)) select 3) - 0.01));
_ctrl ctrlCommit 0;
