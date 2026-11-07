params ["_action", "_data"];
private _disp = [] call ADVSEC_fnc_repDisp;
switch (_action) do {
    case "list": {
        ADVSEC_repRows = _data;
        if (isNull _disp) exitWith {};
        private _lb = _disp displayCtrl 86602;
        lbClear _lb;
        {
            _x params ["_created", "_id", "_status", "_gravity", "_title"];
            private _i = _lb lbAdd format ["%1  ·  %2  ·  %3", _id, _status, _title];
            _lb lbSetTooltip [_i, format ["%1 · %2", _created, _gravity]];
            _lb lbSetColor [_i, switch (_gravity) do {
                case "Muy grave": {[1, 0.302, 0.302, 1]};
                case "Grave": {[0.851, 0.4, 0, 1]};
                default {[0.9, 0.9, 0.9, 1]};
            }];
        } forEach _data;
        private _sel = ADVSEC_repRows findIf {(_x select 1) isEqualTo (missionNamespace getVariable ["ADVSEC_repSelect", ""])};
        if (_sel > -1) then {_lb lbSetCurSel _sel};
        if (_data isEqualTo []) then {[createHashMap] call ADVSEC_fnc_repRender};
        if (ctrlIDD _disp == 87200) then {(_disp displayCtrl 87241) ctrlSetText format ["%1  ·  %2", ADVSEC_pdaList select 2, count _data]};
    };
    case "stats": {
        _data params ["_open", "_sent", "_reports", "_cases", "_mine", "_jailed"];
        if (isNull findDisplay 87200) exitWith {};
        private _row = {params ["_n", "_t", ["_c", "#EBEBEB"]]; format ["<t size='1.6' font='RobotoCondensedBold' color='%3'>%1</t>  <t color='#8C8C8C'>%2</t><br/>", _n, _t, _c]};
        private _rows = if (ADVSEC_pdaMode == "AI") then {
            [[_sent, ("STR_ADVSEC_complaints_referred_to_ia_pending" call ADVSEC_fnc_L), "#D0A330"], [_cases, ("STR_ADVSEC_open_case_files" call ADVSEC_fnc_L)], [_open, ("STR_ADVSEC_unresolved_complaints_total" call ADVSEC_fnc_L)], [_mine, ("STR_ADVSEC_records_signed_by_you" call ADVSEC_fnc_L)]]
        } else {
            [[_open, ("STR_ADVSEC_pending_complaints" call ADVSEC_fnc_L), "#D0A330"], [_reports, ("STR_ADVSEC_military_police_reports" call ADVSEC_fnc_L)], [_jailed, ("STR_ADVSEC_detainees_in_the_cell" call ADVSEC_fnc_L)], [count ADVSEC_wanted, ("STR_ADVSEC_wanted_people" call ADVSEC_fnc_L), "#FF4D4D"], [_mine, ("STR_ADVSEC_records_signed_by_you" call ADVSEC_fnc_L)]]
        };
        ((findDisplay 87200) displayCtrl 87232) ctrlSetStructuredText parseText ((_rows apply {_x call _row}) joinString "");
    };
    case "report": {
        ADVSEC_repCurrent = createHashMapFromArray _data;
        if (!isNull _disp) then {[ADVSEC_repCurrent] call ADVSEC_fnc_repRender};
    };
    case "created": {
        hint format [("STR_ADVSEC_report_logged" call ADVSEC_fnc_L), _data];
        ADVSEC_repSelect = _data;
        if (!isNull _disp) then {["refresh"] call ADVSEC_fnc_repAction};
    };
    case "msg": {hint _data};
};
