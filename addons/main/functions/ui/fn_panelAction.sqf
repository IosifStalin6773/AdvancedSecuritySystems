// ["select" | "btn", índice] | ["refresh"]
params ["_action", ["_arg", 0]];
private _disp = findDisplay 87500;
if (isNull _disp) exitWith {};
private _i = lbCurSel (_disp displayCtrl 87503);
private _row = (missionNamespace getVariable ["ADVSEC_panelRows", []]) param [_i, []];
switch (_action) do {
    case "select": {
        private _v = _disp displayCtrl 87505;
        _v ctrlSetStructuredText parseText (_row param [2, ""]);
        _v ctrlSetPositionH ((ctrlTextHeight _v) max 0.59);
        _v ctrlCommit 0;
    };
    case "btn": {
        private _def = ADVSEC_panelButtons param [_arg, []];
        if (_def isEqualTo []) exitWith {};
        [_row param [1, nil], _i, ADVSEC_panelKey] call (_def select 1);
    };
    case "refresh": {call ADVSEC_panelRefresh};
};
