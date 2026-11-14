// ["refresh"|"filter"|"select"|"save"] — base de datos de jugadores
params ["_action"];
private _disp = findDisplay 87700;
if (isNull _disp) exitWith {};
private _lb = _disp displayCtrl 87704;
private _row = ADVSEC_pdbShown param [lbCurSel _lb, []];
private _esc = {[_this] call ADVSEC_fnc_repEsc};
switch (_action) do {
    case "refresh": {["list", player] remoteExecCall ["ADVSEC_fnc_pdbServer", 2]};
    case "filter": {
        private _q = toLower ctrlText (_disp displayCtrl 87702);
        private _f = lbCurSel (_disp displayCtrl 87703);
        private _selUid = _row param [0, ""];
        ADVSEC_pdbShown = ADVSEC_pdbRows select {
            _x params ["_uid", "_name", "_alias", "", "", "", "_pm", "_ai", "_glob", "", "", "", "_on", "_effPM", "_effAI"];
            (_q isEqualTo "" || {(toLower (([_name, _uid] + _alias) joinString " ")) find _q >= 0})
            && {switch (_f) do {
                case 1: {_on};
                case 2: {_pm > 0 || {_pm < 0 && {_effPM > 0}}};
                case 3: {_ai > 0 || {_ai < 0 && {_effAI > 0}}};
                case 4: {_glob > 0};
                default {true};
            }}
        };
        lbClear _lb;
        {
            _x params ["_uid", "_name", "", "", "", "", "_pm", "_ai", "_glob", "", "", "", "_on", "_effPM", "_effAI"];
            private _tags = [];
            if (_glob > 0) then {_tags pushBack ([7, _glob] call ADVSEC_fnc_pdbRankName)};
            private _p = [_pm, _effPM] select (_pm < 0);
            if (_p > 0) then {_tags pushBack format [("STR_ADVSEC_mp" call ADVSEC_fnc_L), [5, _p] call ADVSEC_fnc_pdbRankName]};
            private _a = [_ai, _effAI] select (_ai < 0);
            if (_a > 0) then {_tags pushBack format [("STR_ADVSEC_ia_2" call ADVSEC_fnc_L), [6, _a] call ADVSEC_fnc_pdbRankName]};
            private _i = _lb lbAdd format ["%1%2", _name, ["", "  ·  " + (_tags joinString " · ")] select (_tags isNotEqualTo [])];
            _lb lbSetPicture [_i, "\A3\ui_f\data\map\markers\military\dot_ca.paa"];
            _lb lbSetPictureColor [_i, [[0.45, 0.45, 0.45, 1], [0.3, 1, 0.3, 1]] select _on];
            if (_uid isEqualTo _selUid) then {_lb lbSetCurSel _i};
        } forEach ADVSEC_pdbShown;
        if (lbCurSel _lb < 0 && {ADVSEC_pdbShown isNotEqualTo []}) then {_lb lbSetCurSel 0};
        private _on = {_x select 12} count ADVSEC_pdbRows;
        (_disp displayCtrl 87706) ctrlSetStructuredText parseText format [("STR_ADVSEC_registered_online_shown" call ADVSEC_fnc_L), count ADVSEC_pdbRows, _on, count ADVSEC_pdbShown];
        if (ADVSEC_pdbShown isEqualTo []) then {["select"] call ADVSEC_fnc_pdbAction};
    };
    case "select": {
        ADVSEC_pdbRights params ["_canPM", "_canAI", "_canGlob", "_myPM", "_myAI"];
        private _view = _disp displayCtrl 87705;
        if (_row isEqualTo []) exitWith {
            _view ctrlSetStructuredText parseText ("STR_ADVSEC_no_results" call ADVSEC_fnc_L);
            {(_disp displayCtrl _x) ctrlEnable false} forEach [87710, 87711, 87712, 87713, 87720];
        };
        _row params ["_uid", "_name", "_alias", "_first", "_last", "_visits", "_pm", "_ai", "_glob", "_notes", "_hist", "_min", "_on", "_effPM", "_effAI"];
        private _h = +_hist;
        reverse _h;
        private _lvl = {
            params ["_set", "_eff", "_i"];
            if (_set >= 0) exitWith {[_i, _set] call ADVSEC_fnc_pdbRankName};
            format [("STR_ADVSEC_as_set_by_mission_2" call ADVSEC_fnc_L), [[("STR_ADVSEC_current" call ADVSEC_fnc_L) + ([_i, _eff] call ADVSEC_fnc_pdbRankName), "desconectado"] select (_eff < 0), ("STR_ADVSEC_no_badge" call ADVSEC_fnc_L)] select (_eff == 0)]
        };
        _view ctrlSetStructuredText parseText format [
            ("STR_ADVSEC_steamid_other_names_first_connection" call ADVSEC_fnc_L),
            _name call _esc, [("STR_ADVSEC_offline_2" call ADVSEC_fnc_L), ("STR_ADVSEC_online" call ADVSEC_fnc_L)] select _on, _uid,
            [(_alias apply {_x call _esc}) joinString ", ", "—"] select (_alias isEqualTo []),
            _first, _last, _visits, floor (_min / 60), _min mod 60,
            [7, _glob] call ADVSEC_fnc_pdbRankName, [_pm, _effPM, 5] call _lvl, [_ai, _effAI, 6] call _lvl,
            [(_h apply {format ["<t color='#8C8C8C'>%1 · %2:</t> %3", _x select 0, (_x select 1) call _esc, (_x select 2) call _esc]}) joinString "<br/>", ("STR_ADVSEC_no_recorded_changes" call ADVSEC_fnc_L)] select (_h isEqualTo [])
        ];
        _view ctrlSetPositionH ((ctrlTextHeight _view) max 0.39);
        _view ctrlCommit 0;
        {
            _x params ["_idc", "_val"];
            private _c = _disp displayCtrl _idc;
            for "_k" from 0 to (lbSize _c - 1) do {if ((_c lbValue _k) == _val) exitWith {_c lbSetCurSel _k}};
        } forEach [[87710, _pm], [87711, _ai], [87712, _glob]];
        (_disp displayCtrl 87713) ctrlSetText _notes;
        (_disp displayCtrl 87710) ctrlEnable _canPM;
        (_disp displayCtrl 87711) ctrlEnable _canAI;
        (_disp displayCtrl 87712) ctrlEnable _canGlob;
        (_disp displayCtrl 87713) ctrlEnable (_canPM || {_canAI} || {_canGlob});
        (_disp displayCtrl 87720) ctrlEnable (_canPM || {_canAI} || {_canGlob});
    };
    case "save": {
        if (_row isEqualTo []) exitWith {};
        private _v = {private _c = _disp displayCtrl _this; _c lbValue (lbCurSel _c)};
        ["set", player, [_row select 0, 87710 call _v, 87711 call _v, 87712 call _v, ctrlText (_disp displayCtrl 87713)]] remoteExecCall ["ADVSEC_fnc_pdbServer", 2];
    };
};
