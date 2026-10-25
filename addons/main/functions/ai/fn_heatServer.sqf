// ["list"|"reset", llamador, args] (servidor) — índice de sospecha para AA.II.
params ["_action", "_caller", ["_args", []]];
if (!isServer) exitWith {};
if !([_caller] call ADVSEC_fnc_srvCaller) exitWith {};
if !([_caller, "suspicionView"] call ADVSEC_fnc_perm) exitWith {[_caller, "consultar el índice de sospecha"] call ADVSEC_fnc_deny};
private _db = [] call ADVSEC_fnc_heatDB;
switch (_action) do {
    case "list": {
        private _thr = ["heatThreshold", 30] call ADVSEC_fnc_setting;
        private _rows = [];
        {
            private _e = [_x] call ADVSEC_fnc_heatGet;
            _e params ["_heat", "", "_events", "_name", "_case"];
            if (_heat > 0 || {_case isNotEqualTo ""}) then {
                private _ev = (_events select [(count _events - 15) max 0]) apply {
                    format ["<t color='#8C8C8C'>%1</t> · %2 <t color='#FF8040'>+%3</t>", _x select 0, [_x select 1] call ADVSEC_fnc_repEsc, _x select 2]
                };
                reverse _ev;
                private _detail = format ["<t size='1.2' font='RobotoCondensedBold'>%1</t><br/>SteamID: %2<br/>Índice actual: <t color='#FF8040'>%3</t> / umbral %4<br/>Expediente: %5<br/><br/><t font='RobotoCondensedBold'>Últimos eventos</t><br/>%6",
                    [_name] call ADVSEC_fnc_repEsc, _x, round _heat, _thr, ["ninguno", _case] select (_case isNotEqualTo ""), _ev joinString "<br/>"];
                private _col = switch (true) do {
                    case (_heat >= _thr): {[1, 0.3, 0.3, 1]};
                    case (_heat >= _thr / 2): {[1, 0.6, 0.2, 1]};
                    default {[]};
                };
                _rows pushBack [round _heat, [format ["%1 · %2 pts%3", _name, round _heat, [" · EXPEDIENTE " + _case, ""] select (_case isEqualTo "")], _x, _detail, _col, ADVSEC_icPol]];
            };
        } forEach (keys _db);
        _rows sort false;
        ["heat", format ["Agentes con indicios: <t font='RobotoCondensedBold'>%1</t> · umbral de expediente automático: %2 puntos", count _rows, _thr], _rows apply {_x select 1}] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
    };
    case "reset": {
        if !([_caller, "caseClose"] call ADVSEC_fnc_perm) exitWith {"Tu rango no permite archivar índices de sospecha." remoteExecCall ["hint", _caller]};
        _args params [["_uid", ""]];
        private _e = _db getOrDefault [_uid, []];
        if (_e isEqualTo []) exitWith {};
        _e set [0, 0];
        _e set [4, ""];
        (_e select 2) pushBack [call ADVSEC_fnc_now, format ["Índice archivado por %1", name _caller], 0];
        ["heat"] call ADVSEC_fnc_dbDirty;
        ["heatReset", _caller, [_uid, _e select 3]] call ADVSEC_fnc_logEvent;
        ["list", _caller] call ADVSEC_fnc_heatServer;
    };
};
