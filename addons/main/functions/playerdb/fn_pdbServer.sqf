/*
    ["list"|"set", llamador, args] (servidor) — base de datos de jugadores de la Policía Militar
    set: [SteamID, rangoPM, rangoAI, rangoGlobal, notas]  (nil en un campo = no cambiarlo)
*/
params ["_action", "_caller", ["_args", []]];
if (!isServer) exitWith {};
if !([_caller] call ADVSEC_fnc_srvCaller) exitWith {};
if !([_caller, "playerDB"] call ADVSEC_fnc_perm) exitWith {[_caller, "consultar la base de datos de jugadores"] call ADVSEC_fnc_deny};
private _db = [] call ADVSEC_fnc_pdbDB;
private _zeus = [_caller] call ADVSEC_fnc_isZeus;
// Nivel propio para limitar a quién puede ascender un mando (Zeus/admin sin límite)
private _myPM = [[_caller, "PM"] call ADVSEC_fnc_rankLevel, 99] select _zeus;
private _myAI = [[_caller, "AI"] call ADVSEC_fnc_rankLevel, 99] select _zeus;
private _canPM = [_caller, "rankPM"] call ADVSEC_fnc_perm;
private _canAI = [_caller, "rankAI"] call ADVSEC_fnc_perm;
private _canGlob = [_caller, "rankGlobal"] call ADVSEC_fnc_perm;
private _online = createHashMap;
{_online set [getPlayerUID _x, _x]} forEach allPlayers;

switch (_action) do {
    case "list": {
        private _rows = [];
        {
            _y params ["_name", "_alias", "_first", "_last", "_visits", "_pm", "_ai", "_glob", "_notes", "_hist", "_min"];
            private _u = _online getOrDefault [_x, objNull];
            private _effPM = [-1, [_u, "PM"] call ADVSEC_fnc_rankLevel] select !isNull _u;
            private _effAI = [-1, [_u, "AI"] call ADVSEC_fnc_rankLevel] select !isNull _u;
            private _since = (localNamespace getVariable ["ADVSEC_pdbSince", createHashMap]) getOrDefault [_x, -1];
            if (_since >= 0) then {_min = _min + round ((diag_tickTime - _since) / 60)};
            _rows pushBack [_x, _name, _alias, _first, _last, _visits, _pm, _ai, _glob, _notes, _hist select [(count _hist - 12) max 0], _min, !isNull _u, _effPM, _effAI];
        } forEach _db;
        // En línea primero; después por última conexión
        private _order = [];
        {_order pushBack [[0, 1] select (_x select 12), _x select 4, _x select 0, _forEachIndex]} forEach _rows;
        _order sort false;
        [_order apply {_rows select (_x select 3)}, [_canPM, _canAI, _canGlob, _myPM, _myAI]] remoteExecCall ["ADVSEC_fnc_pdbSet", _caller];
    };
    case "set": {
        _args params [["_uid", ""], "_pm", "_ai", "_glob", "_notes"];
        private _e = _db getOrDefault [_uid, []];
        if (_e isEqualTo []) exitWith {"Ese jugador no está en la base de datos." remoteExecCall ["hint", _caller]};
        private _u = _online getOrDefault [_uid, objNull];
        private _changes = [];
        private _err = "";
        private _maxG = count (["ranksGlobal", []] call ADVSEC_fnc_setting) - 1;
        // [valor, índice en la ficha, puede, nivelPropio, nombre]
        {
            _x params ["_v", "_i", "_can", "_mine", "_label", "_max"];
            if (isNil "_v" || {!(_v isEqualType 0)} || {_v == (_e select _i)}) then {continue};
            _v = round _v;
            if (_v < -1 || {_v > _max}) then {_err = "Valor de rango no válido."; continue};
            if (!_can) then {_err = format ["Tu rango no permite cambiar el rango %1.", _label]; continue};
            private _old = _e select _i;
            if (_old < 0 && {_i != 7} && {!isNull _u}) then {_old = [_u, ["PM", "AI"] select (_i == 6)] call ADVSEC_fnc_rankLevel};
            if (_i != 7 && {!_zeus} && {_v >= _mine || {_old >= _mine}}) then {
                _err = format ["Solo puedes gestionar rangos %1 inferiores al tuyo.", _label]; continue
            };
            if (_i != 7 && {!_zeus} && {_uid isEqualTo getPlayerUID _caller}) then {_err = "No puedes cambiar tu propio rango."; continue};
            _changes pushBack format ["%1: %2 → %3", _label, [_i, _e select _i] call ADVSEC_fnc_pdbRankName, [_i, _v] call ADVSEC_fnc_pdbRankName];
            _e set [_i, _v];
        } forEach [[_pm, 5, _canPM, _myPM, "PM", 5], [_ai, 6, _canAI, _myAI, "AA.II.", 5], [_glob, 7, _canGlob, 99, "global", _maxG]];
        if (!isNil "_notes" && {_notes isEqualType ""} && {_notes isNotEqualTo (_e select 8)}) then {
            if (_canPM || {_canAI} || {_canGlob}) then {
                _e set [8, _notes select [0, 1000]];
                _changes pushBack "Notas actualizadas";
            } else {_err = "Tu rango no permite editar notas."};
        };
        if (_changes isNotEqualTo []) then {
            {(_e select 9) pushBack [call ADVSEC_fnc_now, name _caller, _x]} forEach _changes;
            if (count (_e select 9) > 40) then {(_e select 9) deleteRange [0, count (_e select 9) - 40]};
            ["players"] call ADVSEC_fnc_dbDirty;
            ["rankChange", _caller, [_uid, _e select 0, _changes]] call ADVSEC_fnc_logEvent;
            if (!isNull _u) then {
                [_u] call ADVSEC_fnc_pdbApply;
                (format ["Tu ficha ha sido actualizada por %1:\n%2", name _caller, _changes joinString "\n"]) remoteExecCall ["hint", _u];
            };
        };
        if (_err isNotEqualTo "") then {_err remoteExecCall ["hint", _caller]} else {
            if (_changes isNotEqualTo []) then {(format ["Ficha de %1 guardada.", _e select 0]) remoteExecCall ["hint", _caller]};
        };
        ["list", _caller] call ADVSEC_fnc_pdbServer;
    };
};
