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
    _ctx ctrlSetText (["Remitir a AA.II.", "Abrir expediente"] select _ai);
    (_disp displayCtrl 87250) ctrlSetText (["Nuevo informe", "Nueva denuncia"] select (_type == "FPM02"));
    lbClear (_disp displayCtrl 86602);
    [createHashMap] call ADVSEC_fnc_repRender;
    ["refresh"] call ADVSEC_fnc_repAction;
};
private _reports = {[ADVSEC_pdaMode, "!FPM02", ["Informes de Policía Militar", "Expedientes de Asuntos Internos"] select _ai, 1] call _list};
private _complaints = {["PM", "FPM02", ["Denuncias y quejas", "Denuncias recibidas"] select _ai, 2] call _list};

switch (_action) do {
    case "tab": {
        switch (_arg) do {
            case 0: {
                (_disp displayCtrl 87240) ctrlShow false;
                (_disp displayCtrl 87230) ctrlShow true;
                [0] call _mark;
                (_disp displayCtrl 87232) ctrlSetStructuredText parseText "<t color='#8C8C8C'>Sincronizando con el archivo central...</t>";
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
            case "listPM": {["PM", "!FPM02", "Informes de Policía Militar", 1] call _list};
            case "wanted": {[] call ADVSEC_fnc_wantedOpen};
            case "query": {[] call ADVSEC_fnc_queryOpen};
            case "evidence": {[] call ADVSEC_fnc_evOpen};
            case "heat": {
                if !([player, "suspicionView"] call ADVSEC_fnc_perm) exitWith {hint "Tu rango no permite consultar el índice de sospecha."};
                [] call ADVSEC_fnc_heatOpen;
            };
            case "docs": {
                if (([player] call ADVSEC_fnc_docGetAll) isEqualTo []) exitWith {hint "No llevas documentos."};
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
        if (_id isEqualTo "" || {(_r getOrDefault ["type", ""]) != "FPM02"}) exitWith {hint "Selecciona una denuncia."};
        private _sanction = _r getOrDefault ["sanction", "Ninguna"];
        if (!_ai) exitWith {
            ["status", player, [_id, "Remitido a AA.II.", _sanction, "Remitida a Asuntos Internos desde la PDA."]] remoteExecCall ["ADVSEC_fnc_repServer", 2];
            hint format ["Denuncia %1 remitida a Asuntos Internos.", _id];
        };
        ["status", player, [_id, "Expediente abierto", _sanction, "Se abre expediente F-AI-01."]] remoteExecCall ["ADVSEC_fnc_repServer", 2];
        [
            "AI",
            (_r getOrDefault ["subjects", []]) joinString "; ",
            "Expediente: " + (_r getOrDefault ["title", ""]),
            format ["Origen: denuncia %1 (%2).\n\n%3", _id, _r getOrDefault ["created", ""], _r getOrDefault ["body", ""]],
            "FAI01"
        ] call ADVSEC_fnc_repEditorOpen;
    };
};
