params ["_action"];
private _disp = findDisplay 86700;
if (isNull _disp) exitWith {};
private _cb = _disp displayCtrl 86710;
private _class = _cb lbData (lbCurSel _cb);

switch (_action) do {
    case "format": {
        private _cfg = [_class] call ADVSEC_fnc_repTypeCfg;
        (_disp displayCtrl 86719) ctrlSetStructuredText parseText format ["<t color='#D0A330'>%1</t>", [getText (_cfg >> "hint")] call ADVSEC_fnc_repEsc];
    };
    case "addSubject": {
        private _sc = _disp displayCtrl 86713;
        private _s = _sc lbData (lbCurSel _sc);
        if (_s isEqualTo "") exitWith {};
        private _e = _disp displayCtrl 86714;
        private _cur = ctrlText _e;
        if (_s in _cur) exitWith {};
        _e ctrlSetText ([_cur + "; " + _s, _s] select (_cur isEqualTo ""));
    };
    case "save": {
        private _title = ctrlText (_disp displayCtrl 86715);
        private _body = ctrlText (_disp displayCtrl 86718);
        if (_title isEqualTo "" || {_body isEqualTo ""}) exitWith {hint "El asunto y la descripción son obligatorios."};
        private _subjects = ((ctrlText (_disp displayCtrl 86714)) splitString ";") apply {_x trim [" ", 0]} select {_x != ""};
        private _data = [
            ["type", _class],
            ["gravity", (_disp displayCtrl 86711) lbText lbCurSel (_disp displayCtrl 86711)],
            ["confidential", lbCurSel (_disp displayCtrl 86712) == 1],
            ["subjects", _subjects],
            ["title", _title],
            ["place", ctrlText (_disp displayCtrl 86716)],
            ["witnesses", ctrlText (_disp displayCtrl 86717)],
            ["body", _body],
            ["sanction", (_disp displayCtrl 86720) lbText lbCurSel (_disp displayCtrl 86720)]
        ];
        closeDialog 0;
        ["create", player, _data] remoteExecCall ["ADVSEC_fnc_repServer", 2];
    };
};
