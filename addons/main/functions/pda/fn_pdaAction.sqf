params ["_action", ["_arg", 0]];
private _disp = findDisplay 87200;
if (isNull _disp) exitWith {};
private _ai = ADVSEC_pdaMode == "AI";

private _mark = {
    params ["_i"];
    private _m = _disp displayCtrl 87219;
    _m ctrlSetPositionX (0.03 + 0.145 * _i);
    _m ctrlCommit 0.1;
    {(_disp displayCtrl (87210 + _x)) ctrlSetTextColor ([[0.667, 0.667, 0.667, 1], [0.922, 0.922, 0.922, 1]] select (_x == _i))} forEach [0, 1, 2, 3];
};
private _list = {
    params ["_dept", "_type", "_label", "_tab"];
    ADVSEC_pdaList = [_dept, _type, _label];
    ADVSEC_repCurrent = createHashMap;
    ADVSEC_repSelect = "";
    (_disp displayCtrl 87230) ctrlShow false;
    (_disp displayCtrl 87240) ctrlShow true;
    [_tab] call _mark;
    (_disp displayCtrl 87241) ctrlSetText _label;
    (_disp displayCtrl 86611) ctrlSetText "";
    private _ctx = _disp displayCtrl 87253;
    _ctx ctrlShow (_type == "FPM02");
    _ctx ctrlSetText ([("STR_ADVSEC_refer_to_ia" call ADVSEC_fnc_L), ("STR_ADVSEC_open_case_file" call ADVSEC_fnc_L)] select _ai);
    (_disp displayCtrl 87250) ctrlSetText ([("STR_ADVSEC_new_report" call ADVSEC_fnc_L), ("STR_ADVSEC_new_complaint" call ADVSEC_fnc_L)] select (_type == "FPM02"));
    lbClear (_disp displayCtrl 86602);
    [createHashMap] call ADVSEC_fnc_repRender;
    ["refresh"] call ADVSEC_fnc_repAction;
};
private _reports = {[ADVSEC_pdaMode, "!FPM02", [("STR_ADVSEC_military_police_reports_2" call ADVSEC_fnc_L), ("STR_ADVSEC_internal_affairs_case_files" call ADVSEC_fnc_L)] select _ai, 1] call _list};
private _complaints = {["PM", "FPM02", [("STR_ADVSEC_complaints_and_grievances" call ADVSEC_fnc_L), ("STR_ADVSEC_complaints_received" call ADVSEC_fnc_L)] select _ai, 2] call _list};

switch (_action) do {
    case "tab": {
        switch (_arg) do {
            case 0: {
                (_disp displayCtrl 87240) ctrlShow false;
                (_disp displayCtrl 87230) ctrlShow true;
                [0] call _mark;
                (_disp displayCtrl 87232) ctrlSetStructuredText parseText ("STR_ADVSEC_syncing_with_the_central_archive" call ADVSEC_fnc_L);
                ["stats", player] remoteExecCall ["ADVSEC_fnc_repServer", 2];
            };
            case 1: {call _reports};
            case 2: {call _complaints};
            case 3: {[] call ADVSEC_fnc_wantedOpen};
        };
    };
    case "tile": {
        switch (ADVSEC_pdaTiles param [_arg, ""]) do {
            case "newComplaint": {["PM", "", "", "", "FPM02"] call ADVSEC_fnc_repEditorOpen};
            case "newReport": {["PM"] call ADVSEC_fnc_repEditorOpen};
            case "newCase": {["AI", "", "", "", "FAI01"] call ADVSEC_fnc_repEditorOpen};
            case "listComplaints": {call _complaints};
            case "listReports": {call _reports};
            case "listPM": {["PM", "!FPM02", ("STR_ADVSEC_military_police_reports_2" call ADVSEC_fnc_L), 1] call _list};
            case "wanted": {[] call ADVSEC_fnc_wantedOpen};
            case "bodycam": {["open"] call ADVSEC_fnc_bodyLive};
            case "query": {[] call ADVSEC_fnc_queryOpen};
            case "evidence": {[] call ADVSEC_fnc_evOpen};
            case "heat": {
                if !([player, "suspicionView"] call ADVSEC_fnc_perm) exitWith {hint ("STR_ADVSEC_your_rank_does_not_allow_14" call ADVSEC_fnc_L)};
                [] call ADVSEC_fnc_heatOpen;
            };
            case "docs": {
                if (([player] call ADVSEC_fnc_docGetAll) isEqualTo []) exitWith {hint ("STR_ADVSEC_you_carry_no_documents" call ADVSEC_fnc_L)};
                [player] call ADVSEC_fnc_docListOpen;
            };
        };
    };
    case "new": {
        ADVSEC_pdaList params ["_dept", "_type"];
        if (_type == "FPM02") exitWith {["PM", "", "", "", "FPM02"] call ADVSEC_fnc_repEditorOpen};
        [_dept] call ADVSEC_fnc_repEditorOpen;
    };
    case "context": {
        private _r = ADVSEC_repCurrent;
        private _id = _r getOrDefault ["id", ""];
        if (_id isEqualTo "" || {(_r getOrDefault ["type", ""]) != "FPM02"}) exitWith {hint ("STR_ADVSEC_select_a_complaint" call ADVSEC_fnc_L)};
        private _sanction = _r getOrDefault ["sanction", "Ninguna"];
        if (!_ai) exitWith {
            ["status", player, [_id, "Remitido a AA.II.", _sanction, ("STR_ADVSEC_referred_to_internal_affairs_from" call ADVSEC_fnc_L)]] remoteExecCall ["ADVSEC_fnc_repServer", 2];
            hint format [("STR_ADVSEC_complaint_referred_to_internal_affairs" call ADVSEC_fnc_L), _id];
        };
        ["status", player, [_id, "Expediente abierto", _sanction, ("STR_ADVSEC_an_f_ai_01_case" call ADVSEC_fnc_L)]] remoteExecCall ["ADVSEC_fnc_repServer", 2];
        [
            "AI",
            (_r getOrDefault ["subjects", []]) joinString "; ",
            ("STR_ADVSEC_case_file_2" call ADVSEC_fnc_L) + (_r getOrDefault ["title", ""]),
            format ["Origen: denuncia %1 (%2).\n\n%3", _id, _r getOrDefault ["created", ""], _r getOrDefault ["body", ""]],
            "FAI01"
        ] call ADVSEC_fnc_repEditorOpen;
    };
};
