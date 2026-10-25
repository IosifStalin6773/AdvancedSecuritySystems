params ["_action"];
private _disp = findDisplay 86900;
if (isNull _disp) exitWith {};
private _lb = _disp displayCtrl 86901;
private _e = (missionNamespace getVariable ["ADVSEC_wantedRows", []]) param [lbCurSel _lb, []];
private _lvlCol = {
    switch (_this) do {
        case "Extrema": {[1, 0.302, 0.302, 1]};
        case "Alta": {[0.851, 0.4, 0, 1]};
        case "Media": {[0.851, 0.639, 0, 1]};
        default {[0.498, 0.851, 0, 1]};
    }
};

switch (_action) do {
    case "fill": {
        ADVSEC_wantedRows = missionNamespace getVariable ["ADVSEC_wanted", []];
        lbClear _lb;
        {
            _x params ["_uid", "_name", "_reason", "_level"];
            private _online = allPlayers findIf {getPlayerUID _x == _uid} > -1;
            private _i = _lb lbAdd format ["%1 · %2 · %3%4", toUpper _level, _name, _reason, ["", "  (conectado)"] select _online];
            _lb lbSetColor [_i, _level call _lvlCol];
        } forEach ADVSEC_wantedRows;
        if (ADVSEC_wantedRows isEqualTo []) then {
            (_disp displayCtrl 86902) ctrlSetStructuredText parseText "<t color='#8C8C8C'>No hay nadie en la lista de buscados.</t>";
        } else {
            _lb lbSetCurSel 0;
        };
    };
    case "select": {
        if (_e isEqualTo []) exitWith {};
        _e params ["_uid", "_name", "_reason", "_level", "_by", "_date"];
        private _u = allPlayers select {getPlayerUID _x == _uid};
        (_disp displayCtrl 86902) ctrlSetStructuredText parseText format [
            "<t font='RobotoCondensedBold' size='1.1'>%1</t> <t color='#8C8C8C'>[%2]</t><br/><t color='#8C8C8C'>Motivo:</t> %3<br/><t color='#8C8C8C'>Peligrosidad:</t> %4 · <t color='#8C8C8C'>Alta:</t> %5 por %6<br/>%7",
            [_name] call ADVSEC_fnc_repEsc, _uid, [_reason] call ADVSEC_fnc_repEsc, _level, _date, [_by] call ADVSEC_fnc_repEsc,
            if (_u isEqualTo []) then {"<t color='#8C8C8C'>No conectado.</t>"} else {format ["<t color='#D96600'>Conectado · última posición: cuadrícula %1</t>", mapGridPosition (_u select 0)]}
        ];
    };
    case "add": {[] call ADVSEC_fnc_wantedPrompt};
    case "del": {
        if (_e isEqualTo []) exitWith {hint "Selecciona una entrada."};
        ["del", player, [_e select 0]] remoteExecCall ["ADVSEC_fnc_wantedServer", 2];
    };
    case "report": {
        if (_e isEqualTo []) exitWith {hint "Selecciona una entrada."};
        closeDialog 0;
        ["PM", format ["%1 [%2]", _e select 1, _e select 0], format ["Requisitoria · %1", _e select 1], format ["Motivo de la requisitoria: %1", _e select 2]] call ADVSEC_fnc_repEditorOpen;
    };
};
