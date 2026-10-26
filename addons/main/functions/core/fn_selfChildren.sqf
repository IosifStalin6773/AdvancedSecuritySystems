/*
    Menú propio «Mi personaje» -> [[id, texto, icono, código, args, subhijos?], ...]
    Agrupa en submenús lo que antes eran entradas sueltas del menú de ACE.
*/
params ["_player"];
private _list = [];
private _add = {_list pushBack _this};
private _grp = {params ["_id", "_t", "_i", "_sub"]; if (_sub isNotEqualTo []) then {_list pushBack [_id, _t, _i, {}, [], _sub]}};
private _eco = [] call ADVSEC_fnc_ecoOn;
private _free = isNull objectParent _player && {!([_player] call ADVSEC_fnc_isRestrained)};

["advsec_me_112", "Llamar al 112", ADVSEC_icAlarm, {[] call ADVSEC_fnc_dspCall}, []] call _add;

private _docs = [_player, "review"] call ADVSEC_fnc_docChildren;
if (_docs isNotEqualTo []) then {
    ["advsec_me_docs", "Mis documentos", ADVSEC_icDoc, [["advsec_me_docall", "Ver todos", ADVSEC_icDoc, {[_player] call ADVSEC_fnc_docListOpen}, []]] + _docs] call _grp;
};

// Dinero y vehículos
private _money = [];
if (_eco) then {_money pushBack ["advsec_me_wallet", "Cartera y banco", ADVSEC_icDoc, {[] call ADVSEC_fnc_ecoOpen}, []]};
_money pushBack ["advsec_me_fines", "Mis multas", ADVSEC_icDoc, {[] call ADVSEC_fnc_fineOpen}, []];
if (_eco) then {
    private _l = (_player getVariable ["ADVSEC_jailUntil", 0]) - serverTime;
    if (_l > 0 && {_l < 1e6}) then {_money pushBack ["advsec_me_bail", "Pagar fianza", ADVSEC_icJail, {["bail", _player] remoteExecCall ["ADVSEC_fnc_licServer", 2]}, []]};
    _money pushBack ["advsec_me_veh", "Mis vehículos", ADVSEC_icCar, {[] call ADVSEC_fnc_plateMine}, []];
};
private _mine = (nearestObjects [_player, ["LandVehicle", "Air", "Ship"], 10]) select {(_x getVariable ["ADVSEC_plateOwner", ""]) isEqualTo getPlayerUID _player};
if (_mine isNotEqualTo []) then {
    _money pushBack ["advsec_me_lock", "Abrir / cerrar mi vehículo", ADVSEC_icKey, {["lock", _player, [_args select 0]] remoteExecCall ["ADVSEC_fnc_plateServer", 2]}, [_mine select 0]];
};
["advsec_me_money", ["Dinero y multas", "Dinero, multas y vehículos"] select _eco, ADVSEC_icDoc, _money] call _grp;

if (_free && {"ADVSEC_SpeedCamKit" in items _player}) then {
    ["advsec_me_radar", "Desplegar radar portátil", ADVSEC_icCar, {["deploy", _player] remoteExecCall ["ADVSEC_fnc_speedCamServer", 2]}, []] call _add;
};
["advsec_me_specs", "Especialidades (metopas)", ADVSEC_icDoc, {[] call ADVSEC_fnc_specOpen}, []] call _add;

// Esconder cosas (solo si se puede)
private _hide = [];
if (_free) then {
    _hide pushBack ["advsec_me_hide", "Ocultar objeto entre la ropa", ADVSEC_icSearch, {[] call ADVSEC_fnc_hideItem}, []];
    private _v = _player nearEntities [["Car", "Motorcycle", "Tank"], 5];
    if (_v isNotEqualTo []) then {_hide pushBack ["advsec_me_stash", "Doble fondo del vehículo", ADVSEC_icCar, {[_args select 0] call ADVSEC_fnc_vehStash}, [_v select 0]]};
};
["advsec_me_hidegrp", "Esconder", ADVSEC_icSearch, _hide] call _grp;
_list
