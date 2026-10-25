params ["_action"];
private _disp = [] call ADVSEC_fnc_repDisp;
if (isNull _disp) exitWith {};
private _pda = ctrlIDD _disp == 87200;
private _cb = _disp displayCtrl 86610;
private _dept = if (_pda) then {ADVSEC_pdaList select 0} else {_cb lbData (lbCurSel _cb)};
private _id = ADVSEC_repCurrent getOrDefault ["id", ""];
private _lists = configFile >> "ADVSEC_ReportLists";

switch (_action) do {
    case "refresh": {
        ["list", player, [_dept, ctrlText (_disp displayCtrl 86611), ["", ADVSEC_pdaList select 1] select _pda]] remoteExecCall ["ADVSEC_fnc_repServer", 2];
    };
    case "select": {
        private _row = (missionNamespace getVariable ["ADVSEC_repRows", []]) param [lbCurSel (_disp displayCtrl 86602), []];
        if (_row isEqualTo []) exitWith {};
        ADVSEC_repSelect = _row select 1;
        ["get", player, _row select 1] remoteExecCall ["ADVSEC_fnc_repServer", 2];
    };
    case "new": {[["PM", _dept] select (_dept in ["PM", "AI"])] call ADVSEC_fnc_repEditorOpen};
    case "note": {
        if (_id isEqualTo "") exitWith {hint "Selecciona un informe."};
        [format ["ANOTACIÓN · %1", _id], [["Texto", ""]], {
            params ["_v", "_id"];
            ["note", player, [_id, _v select 0]] remoteExecCall ["ADVSEC_fnc_repServer", 2];
        }, _id] call ADVSEC_fnc_zeusPrompt;
    };
    case "status": {
        if (_id isEqualTo "") exitWith {hint "Selecciona un informe."};
        [format ["ESTADO · %1", _id], [
            ["Estado", ADVSEC_repCurrent get "status", getArray (_lists >> "status")],
            ["Sanción", ADVSEC_repCurrent getOrDefault ["sanction", "Ninguna"], getArray (_lists >> "sanction")],
            ["Motivo", ""]
        ], {
            params ["_v", "_id"];
            ["status", player, [_id, _v select 0, _v select 1, _v select 2]] remoteExecCall ["ADVSEC_fnc_repServer", 2];
        }, _id] call ADVSEC_fnc_zeusPrompt;
    };
};
