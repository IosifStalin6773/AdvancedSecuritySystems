/*
    [acción, llamador, args] (servidor) — registro de vehículos por compartimentos
    "list" [veh] · "scan" [veh, zona] · "seize" [veh, zona, tipo, clase] · "stash" [veh, clase] (esconder en doble fondo)
    Zonas: "glove" guantera · "seats" bajo asientos · "trunk" maletero · "stash" bajos y rueda de repuesto (oculto, solo servidor)
*/
params ["_action", "_caller", ["_args", []]];
if (!isServer) exitWith {};
_args params [["_veh", objNull]];
if (isNull _veh || {!([_caller, _veh, 10] call ADVSEC_fnc_srvCaller)}) exitWith {};
private _say = {_this remoteExecCall ["hint", _caller]};
private _zones = createHashMapFromArray [["glove", ["Guantera", 3]], ["seats", ["Bajo los asientos", 4]], ["trunk", ["Maletero", 5]], ["stash", ["Bajos y rueda de repuesto", 10]]];
private _scanKey = netId _veh + getPlayerUID _caller;
private _scans = localNamespace getVariable ["ADVSEC_vehScan", createHashMap];
localNamespace setVariable ["ADVSEC_vehScan", _scans];
private _cfgOf = {
    params ["_c"];
    private _r = configNull;
    {if (isClass (configFile >> _x >> _c)) exitWith {_r = configFile >> _x >> _c}} forEach ["CfgWeapons", "CfgMagazines", "CfgVehicles", "CfgGlasses"];
    _r
};
// Contenido de cada compartimento: [[tipo, clase, cantidad], ...]
private _content = {
    params ["_z"];
    private _out = [];
    if (_z == "stash") exitWith {+(_veh getVariable ["ADVSEC_stash", []])};
    if (_z == "trunk") then {
        {_out pushBack ["W", _x, (getWeaponCargo _veh select 1) select _forEachIndex]} forEach (getWeaponCargo _veh select 0);
        {_out pushBack ["B", _x, (getBackpackCargo _veh select 1) select _forEachIndex]} forEach (getBackpackCargo _veh select 0);
    };
    if (_z == "seats") then {
        {_out pushBack ["M", _x, (getMagazineCargo _veh select 1) select _forEachIndex]} forEach (getMagazineCargo _veh select 0);
    };
    {
        private _small = getNumber (configFile >> "CfgWeapons" >> _x >> "ItemInfo" >> "mass") <= 10;
        if ((_z == "glove" && _small) || {_z == "trunk" && !_small}) then {_out pushBack ["I", _x, (getItemCargo _veh select 1) select _forEachIndex]};
    } forEach (getItemCargo _veh select 0);
    _out
};

switch (_action) do {
    case "list": {
        private _done = _scans getOrDefault [_scanKey, []];
        private _rows = [];
        {
            private _z = _x;
            (_zones get _z) params ["_label"];
            if !(_z in _done) then {
                _rows pushBack [format ["▸ %1 (sin registrar)", toUpper _label], [_z], "<t color='#8C8C8C'>Usa el botón de la zona para registrarla.</t>", [0.6, 0.6, 0.6, 1], ADVSEC_icSearch];
                continue;
            };
            _rows pushBack [format ["▾ %1", toUpper _label], [_z], "", [0.4, 0.8, 1, 1], ADVSEC_icSearch];
            private _c = [_z] call _content;
            if (_z == "stash") then {_c = _c select {(_x param [3, false])}};
            if (_c isEqualTo []) then {_rows pushBack ["    vacío", [_z], "", [], ""]};
            {
                _x params ["_k", "_class", "_n"];
                private _cfg = [_class] call _cfgOf;
                private _name = [_class, getText (_cfg >> "displayName")] select !isNull _cfg;
                private _illegal = _class in (["illegalItems", []] call ADVSEC_fnc_setting);
                _rows pushBack [format ["    %1 x%2%3", _name, _n, [" ", " · ILEGAL"] select _illegal], [_z, _k, _class],
                    format ["<t size='1.1' font='RobotoCondensedBold'>%1</t><br/>Compartimento: %2<br/>Clase: %3<br/>Cantidad: %4", _name, _label, _class, _n],
                    [[], [1, 0.3, 0.3, 1]] select _illegal, getText (_cfg >> "picture")];
            } forEach _c;
        } forEach ["glove", "seats", "trunk", "stash"];
        private _plate = getPlateNumber _veh;
        ["veh", format ["<t font='RobotoCondensedBold'>%1</t> · matrícula %2 · cuadrícula %3", getText (configOf _veh >> "displayName"), [_plate, "—"] select (_plate isEqualTo ""), mapGridPosition _veh], _rows] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
    };
    case "scan": {
        _args params ["", ["_z", ""]];
        if !(_z in _zones) exitWith {};
        if !([_caller, "vehicleSearch"] call ADVSEC_fnc_perm) exitWith {[_caller, "registrar un vehículo"] call ADVSEC_fnc_deny};
        if (_caller getVariable ["ADVSEC_vehBusy", false]) exitWith {"Ya estás registrando." call _say};
        if ((speed _veh) > 3) exitWith {"El vehículo debe estar detenido." call _say};
        _caller setVariable ["ADVSEC_vehBusy", true];
        (format ["Registrando: %1...", (_zones get _z) select 0]) call _say;
        [_caller, _veh, _z, (_zones get _z) select 1, _scanKey, _scans] spawn {
            params ["_caller", "_veh", "_z", "_secs", "_scanKey", "_scans"];
            sleep _secs;
            _caller setVariable ["ADVSEC_vehBusy", false];
            if (!alive _caller || {(_caller distance _veh) > 10}) exitWith {"Registro interrumpido." remoteExecCall ["hint", _caller]};
            if (_z == "stash") then {
                private _p = ["stashFindChance", 0.5] call ADVSEC_fnc_setting;
                {if (random 1 < _p) then {_x set [3, true]}} forEach (_veh getVariable ["ADVSEC_stash", []]);
            };
            private _done = _scans getOrDefault [_scanKey, []];
            _done pushBackUnique _z;
            _scans set [_scanKey, _done];
            ["print", _caller, [_veh]] call ADVSEC_fnc_evidenceServer;
            ["vehSearch", _caller, [typeOf _veh, getPlateNumber _veh, _z]] call ADVSEC_fnc_logEvent;
            "Compartimento registrado." remoteExecCall ["hint", _caller];
            ["list", _caller, [_veh]] call ADVSEC_fnc_vehServer;
        };
    };
    case "seize": {
        _args params ["", "_z", "_k", "_class"];
        if !([_caller, "seize"] call ADVSEC_fnc_perm) exitWith {[_caller, "incautar de un vehículo"] call ADVSEC_fnc_deny};
        if !(_z in (_scans getOrDefault [_scanKey, []])) exitWith {"Registra antes ese compartimento." call _say};
        private _ok = false;
        if (_z == "stash") then {
            private _s = _veh getVariable ["ADVSEC_stash", []];
            private _i = _s findIf {(_x select 1) == _class && {_x param [3, false]}};
            if (_i > -1) then {
                private _e = _s select _i;
                _e set [2, (_e select 2) - 1];
                if ((_e select 2) <= 0) then {_s deleteAt _i};
                _veh setVariable ["ADVSEC_stash", _s];
                _ok = true;
            };
        } else {
            private _cargo = switch (_k) do {case "W": {getWeaponCargo _veh}; case "M": {getMagazineCargo _veh}; case "B": {getBackpackCargo _veh}; default {getItemCargo _veh}};
            _cargo params ["_cls", "_cnt"];
            private _i = _cls find _class;
            if (_i < 0) exitWith {};
            _cnt set [_i, (_cnt select _i) - 1];
            switch (_k) do {
                case "W": {clearWeaponCargoGlobal _veh; {if ((_cnt select _forEachIndex) > 0) then {_veh addWeaponCargoGlobal [_x, _cnt select _forEachIndex]}} forEach _cls};
                case "M": {clearMagazineCargoGlobal _veh; {if ((_cnt select _forEachIndex) > 0) then {_veh addMagazineCargoGlobal [_x, _cnt select _forEachIndex]}} forEach _cls};
                case "B": {clearBackpackCargoGlobal _veh; {if ((_cnt select _forEachIndex) > 0) then {_veh addBackpackCargoGlobal [_x, _cnt select _forEachIndex]}} forEach _cls};
                default {clearItemCargoGlobal _veh; {if ((_cnt select _forEachIndex) > 0) then {_veh addItemCargoGlobal [_x, _cnt select _forEachIndex]}} forEach _cls};
            };
            _ok = true;
        };
        if (!_ok) exitWith {"Ese objeto ya no está." call _say};
        private _holder = (nearestObjects [_caller, ["GroundWeaponHolder"], 2]) param [0, objNull];
        if (isNull _holder) then {_holder = createVehicle ["GroundWeaponHolder", getPosATL _caller, [], 0.5, "CAN_COLLIDE"]};
        switch (_k) do {
            case "W": {_holder addWeaponCargoGlobal [_class, 1]};
            case "M": {_holder addMagazineCargoGlobal [_class, 1]};
            case "B": {_holder addBackpackCargoGlobal [_class, 1]};
            default {_holder addItemCargoGlobal [_class, 1]};
        };
        ["vehSeize", _caller, [typeOf _veh, getPlateNumber _veh, _z, _class]] call ADVSEC_fnc_logEvent;
        "Incautado: depositado en el suelo junto a ti." call _say;
        ["list", _caller, [_veh]] call ADVSEC_fnc_vehServer;
    };
    case "stash": {
        _args params ["", "_class"];
        if ((_caller distance _veh) > 5 || {!alive _veh}) exitWith {};
        private _mag = _class in magazines _caller;
        if (!_mag && {!(_class in items _caller)}) exitWith {};
        private _s = _veh getVariable ["ADVSEC_stash", []];
        if ((count _s) >= 4) exitWith {"El doble fondo está lleno." call _say};
        [_caller, _class] remoteExecCall [["removeItem", "removeMagazine"] select _mag, _caller];
        private _i = _s findIf {(_x select 1) == _class};
        if (_i > -1) then {(_s select _i) set [2, ((_s select _i) select 2) + 1]} else {_s pushBack [["I", "M"] select _mag, _class, 1, false]};
        _veh setVariable ["ADVSEC_stash", _s];
        "Objeto escondido en los bajos del vehículo." call _say;
    };
    case "unstash": {
        if ((_caller distance _veh) > 5) exitWith {};
        private _s = _veh getVariable ["ADVSEC_stash", []];
        if (_s isEqualTo []) exitWith {"No hay nada escondido." call _say};
        {
            _x params ["_k", "_class", "_n"];
            for "_j" from 1 to _n do {[_caller, _class] remoteExecCall [["addItem", "addMagazine"] select (_k == "M"), _caller]};
        } forEach _s;
        _veh setVariable ["ADVSEC_stash", []];
        "Recuperas lo que había escondido." call _say;
    };
};
