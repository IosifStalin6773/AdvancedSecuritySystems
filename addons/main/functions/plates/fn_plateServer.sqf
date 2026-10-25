/*
    [acción, llamador, args] (servidor) — concesionario y registro de matrículas
    "dealer" [conc] · "buy" [conc, índice] · "mine" · "stolen" [matr] · "found" [matr] · "query" [matr] · "lock" [vehículo]
*/
params ["_action", "_caller", ["_args", []]];
if (!isServer) exitWith {};
if !([_caller] call ADVSEC_fnc_srvCaller) exitWith {};
private _db = [] call ADVSEC_fnc_plateDB;
if (isNil "ADVSEC_wantedDB") then {[] call ADVSEC_fnc_policeDBLoad};
private _say = {_this remoteExecCall ["hint", _caller]};
private _uid = getPlayerUID _caller;
private _cur = ["currency", "€"] call ADVSEC_fnc_setting;
private _vname = {params ["_c"]; getText (configFile >> "CfgVehicles" >> _c >> "displayName")};
private _vehOf = {params ["_p"]; private _v = objectFromNetId ((_db getOrDefault [_p, []]) param [5, ""]); [objNull, _v] select (alive _v && {(_v getVariable ["ADVSEC_plate", ""]) isEqualTo _p})};
switch (_action) do {
    case "dealer": {
        _args params [["_d", objNull]];
        if (isNull _d || {(_caller distance _d) > 10}) exitWith {};
        private _rows = [];
        {
            _x params ["_c", "_p"];
            _rows pushBack [format ["%1 · %2 %3", [_c] call _vname, _p, _cur], _forEachIndex, format ["<t size='1.15' font='RobotoCondensedBold'>%1</t><br/>Precio: %2 %3<br/>Se entrega matriculado a tu nombre y cerrado con llave.<br/><t color='#8C8C8C'>%4</t>", ([_c] call _vname) call ADVSEC_fnc_repEsc, _p, _cur, _c], [], getText (configFile >> "CfgVehicles" >> _c >> "picture")];
        } forEach (_d getVariable ["ADVSEC_dealer", ["", []]] select 1);
        ["dealer", format ["%1 · Efectivo y banco: %2 %3", (_d getVariable ["ADVSEC_dealer", ["Concesionario"]]) select 0, ([_caller] call ADVSEC_fnc_ecoCash) + (([_uid, name _caller] call ADVSEC_fnc_ecoAcc) select 1), _cur], _rows] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
    };
    case "buy": {
        _args params [["_d", objNull], ["_i", -1]];
        if (isNull _d || {(_caller distance _d) > 10}) exitWith {};
        private _it = (_d getVariable ["ADVSEC_dealer", ["", []]] select 1) param [_i, []];
        if (_it isEqualTo []) exitWith {};
        _it params ["_c", "_p"];
        private _air = _c isKindOf "Air";
        private _pos = (getPosATL _d) findEmptyPosition [8, [60, 200] select _air, _c];
        if (_pos isEqualTo []) exitWith {"No hay sitio libre para entregar el vehículo." call _say};
        if !([_caller, _p, format ["Compra de vehículo: %1", [_c] call _vname], (["shopToTreasury", 0] call ADVSEC_fnc_setting) isEqualTo 1] call ADVSEC_fnc_ecoCharge) exitWith {(format ["No te llega: cuesta %1 %2.", _p, _cur]) call _say};
        private _plate = "";
        while {_plate isEqualTo "" || {_plate in _db}} do {_plate = format ["%1-%2", ["platePrefix", "ET"] call ADVSEC_fnc_setting, 1000 + floor random 9000]};
        private _v = createVehicle [_c, _pos, [], 0, "NONE"];
        _v setDir getDir _d;
        _v setVariable ["ADVSEC_plate", _plate, true];
        _v setVariable ["ADVSEC_plateOwner", _uid, true];
        [_v, _plate] remoteExecCall ["setPlateNumber", 0, "ADVSEC_plate_" + netId _v];
        _v lock 2;
        _db set [_plate, [_c, _uid, name _caller, call ADVSEC_fnc_now, false, netId _v]];
        ["plates"] call ADVSEC_fnc_dbDirty;
        ["plateBuy", _caller, [_plate, _c, _p]] call ADVSEC_fnc_logEvent;
        (format ["Vehículo entregado: %1, matrícula %2. Está cerrado: ábrelo con la acción «Abrir / cerrar mi vehículo».", [_c] call _vname, _plate]) call _say;
    };
    case "mine": {
        private _rows = [];
        {
            _y params ["_c", "_o", "", "_date", "_st"];
            if (_o isEqualTo _uid) then {
                private _v = [_x] call _vehOf;
                _rows pushBack [format ["%1 · %2%3", _x, [_c] call _vname, ["", " · ROBADO"] select _st], _x,
                    format ["<t size='1.15' font='RobotoCondensedBold'>%1</t><br/>%2<br/>Matriculado: %3<br/>Estado: %4<br/>%5", _x, ([_c] call _vname) call ADVSEC_fnc_repEsc, _date, ["en regla", "DENUNCIADO COMO ROBADO"] select _st, ["Vehículo destruido o fuera de esta partida.", format ["Última posición: %1", mapGridPosition _v]] select !isNull _v], [[], [1, 0.4, 0.3, 1]] select _st, ""];
            };
        } forEach _db;
        ["plates", format ["Vehículos a tu nombre: %1", count _rows], _rows] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
    };
    case "stolen";
    case "found": {
        _args params [["_p", ""]];
        private _e = _db getOrDefault [_p, []];
        if (_e isEqualTo [] || {(_e select 1) isNotEqualTo _uid}) exitWith {};
        private _st = _action == "stolen";
        _e set [4, _st];
        ["plates"] call ADVSEC_fnc_dbDirty;
        if (_st) then {
            ["VEH:" + _p, format ["Vehículo %1 · %2", [_e select 0] call _vname, _p], format ["Denunciado como robado por %1", name _caller], "Media"] call ADVSEC_fnc_wantedSys;
            ["plateStolen", _caller, [_p, _e select 0]] call ADVSEC_fnc_logEvent;
        } else {
            ADVSEC_wantedDB deleteAt ("VEH:" + _p);
            ["wanted"] call ADVSEC_fnc_policeDBSave;
            ["plateFound", _caller, [_p]] call ADVSEC_fnc_logEvent;
        };
        ["mine", _caller] call ADVSEC_fnc_plateServer;
    };
    case "query": {
        if !([_caller, "plateQuery"] call ADVSEC_fnc_perm) exitWith {[_caller, "consultar matrículas"] call ADVSEC_fnc_deny};
        _args params [["_p", ""]];
        _p = toUpper (_p trim [" ", 0]);
        private _e = _db getOrDefault [_p, []];
        if (_e isEqualTo []) exitWith {(format ["Matrícula %1: SIN REGISTRO. Vehículo sin matricular o placa falsa.", _p]) call _say};
        _e params ["_c", "_o", "_n", "_date", "_st"];
        private _w = _o in ADVSEC_wantedDB;
        ["plateQuery", _caller, [_p]] call ADVSEC_fnc_logEvent;
        (parseText format ["<t size='1.2' font='RobotoCondensedBold'>MATRÍCULA %1</t><br/>%2<br/>Titular: %3<br/>Matriculado: %4<br/>%5%6", _p, [_c] call _vname, _n, _date,
            ["<t color='#66FF66'>Sin denuncia de robo</t>", "<t color='#FF4D4D'>VEHÍCULO ROBADO</t>"] select _st,
            ["", "<br/><t color='#FF4D4D'>TITULAR EN BUSCA Y CAPTURA</t>"] select _w]) remoteExecCall ["hint", _caller];
    };
    case "lock": {
        _args params [["_v", objNull]];
        if (isNull _v || {(_caller distance _v) > 10} || {(_v getVariable ["ADVSEC_plateOwner", ""]) isNotEqualTo _uid}) exitWith {};
        private _l = [2, 0] select ((locked _v) >= 2);
        [_v, _l] remoteExecCall ["lock", _v];
        (["Vehículo abierto.", "Vehículo cerrado."] select (_l == 2)) call _say;
    };
};
