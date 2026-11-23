/*
    [acción, llamador, args] (servidor) — expedientes de caso (1.22)
    "new" [título] · "addEv" [caso, idEvidencia] · "addPerson" [caso, uid, nombre] · "lineup" [caso, testigo, sospechoso, resultado]
    "links" [caso] — personas que aparecen en más de un caso (tablero de conexiones)
    "warrant" [unidad, horas] — orden de registro: permite el registro sin sospecha durante el plazo
*/
params ["_action", ["_caller", objNull], ["_args", []]];
if (!isServer) exitWith {};
if !([_caller] call ADVSEC_fnc_srvCaller) exitWith {};
private _cases = ["cases", "ADVSEC_caseDB"] call ADVSEC_fnc_mapDB;
private _say = {_this remoteExecCall ["hint", _caller]};
if !([_caller, "caseClose"] call ADVSEC_fnc_perm) exitWith {[_caller, ("STR_ADVSEC_m_case_do" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
switch (_action) do {
    case "new": {
        _args params [["_t", ""]];
        private _n = (localNamespace getVariable ["ADVSEC_caseSeq", 0]) + 1;
        localNamespace setVariable ["ADVSEC_caseSeq", _n];
        private _id = format ["CASO-%1", _n];
        _cases set [_id, [_t select [0, 60], [], [], call ADVSEC_fnc_now]];
        ["cases"] call ADVSEC_fnc_dbDirty;
        (format [("STR_ADVSEC_m_case_new" call ADVSEC_fnc_L), _id]) call _say;
    };
    case "addEv": {
        _args params [["_id", ""], ["_ev", ""]];
        private _c = _cases getOrDefault [_id, []];
        if (_c isEqualTo []) exitWith {("STR_ADVSEC_m_case_none" call ADVSEC_fnc_L) call _say};
        (_c select 1) pushBackUnique _ev;
        ["cases"] call ADVSEC_fnc_dbDirty;
        ["ev"] call ADVSEC_fnc_dbDirty;
    };
    case "addPerson": {
        _args params [["_id", ""], ["_uid", ""], ["_name", ""]];
        private _c = _cases getOrDefault [_id, []];
        if (_c isEqualTo []) exitWith {("STR_ADVSEC_m_case_none" call ADVSEC_fnc_L) call _say};
        (_c select 2) pushBackUnique [_uid, _name];
        ["cases"] call ADVSEC_fnc_dbDirty;
    };
    case "lineup": {
        _args params [["_id", ""], ["_wit", ""], ["_sus", ""], ["_res", ""]];
        private _c = _cases getOrDefault [_id, []];
        if (_c isEqualTo []) exitWith {("STR_ADVSEC_m_case_none" call ADVSEC_fnc_L) call _say};
        private _lu = _c param [4, []];
        _lu pushBack [call ADVSEC_fnc_now, _wit, _sus, _res, name _caller];
        _c set [4, _lu];
        ["cases"] call ADVSEC_fnc_dbDirty;
        ("STR_ADVSEC_m_lineup_saved" call ADVSEC_fnc_L) call _say;
    };
    case "links": {
        _args params [["_id", ""]];
        private _seen = createHashMap;
        {
            private _caseId = _x;
            {
                _x params ["_uid", "_nm"];
                private _e = _seen getOrDefault [_uid, [_nm, []]];
                (_e select 1) pushBackUnique _caseId;
                _seen set [_uid, _e];
            } forEach (_y select 2);
        } forEach _cases;
        private _rows = [];
        {
            _y params ["_nm", "_list"];
            if (count _list > 1) then {_rows pushBack [format ["%1 · %2 casos", _nm, count _list], _x, _list joinString ", ", [], ""]};
        } forEach _seen;
        ["links", format [("STR_ADVSEC_m_links_head" call ADVSEC_fnc_L), count _rows], _rows] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
    };
    case "warrant": {
        _args params [["_u", objNull], ["_hours", 12]];
        if (isNull _u) exitWith {};
        private _w = ["warrants", "ADVSEC_warrantDB"] call ADVSEC_fnc_mapDB;
        _w set [getPlayerUID _u, (call ADVSEC_fnc_utcMin) + (_hours max 1) * 60];
        ["warrants"] call ADVSEC_fnc_dbDirty;
        ["warrant", _caller, [name _u, _hours]] call ADVSEC_fnc_logEvent;
        (format [("STR_ADVSEC_m_warrant_ok" call ADVSEC_fnc_L), name _u, _hours]) call _say;
    };
};
