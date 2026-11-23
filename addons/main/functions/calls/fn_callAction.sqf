/*
    [acción, llamador, [objetivo]] (servidor, 1.24) — acciones de los agentes sobre un aviso IA
    seize · inspect · treat · statement · sketch · negotiate · collect. Solo anotan en el aviso; fn_callServer lo resuelve.
*/
params ["_action", "_caller", ["_args", []]];
if (!isServer) exitWith {};
_args params [["_t", objNull]];
if (isNull _t || {!([_caller, _t, 16] call ADVSEC_fnc_srvCaller)}) exitWith {};
private _say = {_this remoteExecCall ["hint", _caller]};
private _calls = missionNamespace getVariable ["ADVSEC_aiCalls", createHashMap];
private _id = "";
{if (_t in (_y get "objs") || {_t in (_y get "units")}) exitWith {_id = _x}} forEach _calls;
if (_id isEqualTo "") exitWith {};
private _e = _calls get _id;
private _d = _e get "data";
// Socorrer a un herido no exige ser de la PM
if (_action != "treat" && {!([_caller, "PMC"] call ADVSEC_fnc_repAccess)}) exitWith {};
switch (_action) do {
    case "seize": {
        if (_d getOrDefault ["seized", false]) exitWith {};
        private _n = count (itemCargo _t) + count (magazineCargo _t) + count (weaponCargo _t);
        clearItemCargoGlobal _t; clearMagazineCargoGlobal _t; clearWeaponCargoGlobal _t;
        _d set ["seized", true];
        _d set ["by", _caller];
        (format [("STR_ADVSEC_bm_seized" call ADVSEC_fnc_L), _n]) call _say;
    };
    case "inspect": {
        if (_d getOrDefault ["inspected", false]) exitWith {};
        if !([_caller, "scene"] call ADVSEC_fnc_needItem) exitWith {};
        _d set ["inspected", true];
        _d set ["by", _caller];
        private _boq = (_e get "type") == "boq";
        (([["STR_ADVSEC_call_pkg_clean", "STR_ADVSEC_call_pkg_contra"], ["STR_ADVSEC_call_pkg_clean", "STR_ADVSEC_call_pkg_bomb"]] select _boq) select (_d get "contra")) call ADVSEC_fnc_L call _say;
        // Con contrabando, el sospechoso intenta escapar si la tensión está alta
        if ((_d get "contra") && {random 100 < (20 + (missionNamespace getVariable ["ADVSEC_unrest", 0]))}) then {
            private _u = (_e get "units") param [0, objNull];
            if (alive _u && {!([_u] call ADVSEC_fnc_isRestrained)}) then {
                _u enableAI "PATH";
                (group _u) addWaypoint [_u getPos [400, random 360], 0];
                _u setSpeedMode "FULL";
            };
        };
    };
    case "treat": {
        if (_d getOrDefault ["healed", false] || {!alive _t}) exitWith {};
        _d set ["healed", true];
        _d set ["by", _caller];
        _t setDamage 0;
        [_t, ""] remoteExecCall ["switchMove", 0];
        ("STR_ADVSEC_call_treated" call ADVSEC_fnc_L) call _say;
    };
    case "statement": {
        private _st = _d getOrDefault ["stmts", []];
        if (_t in _st) exitWith {("STR_ADVSEC_call_stmt_again" call ADVSEC_fnc_L) call _say};
        _st pushBack _t;
        _d set ["stmts", _st];
        // El testigo que miente culpa al otro vehículo
        private _f = _d get "fault";
        if (_t isEqualTo (_d get "liar")) then {_f = 3 - _f};
        (format [("STR_ADVSEC_call_stmt" call ADVSEC_fnc_L), name _t, _f]) call _say;
    };
    case "sketch": {
        if (_d getOrDefault ["sketch", false]) exitWith {};
        if !([_caller, "sketch"] call ADVSEC_fnc_needItem) exitWith {};
        _d set ["sketch", true];
        _d set ["by", _caller];
        (format [("STR_ADVSEC_call_sketch" call ADVSEC_fnc_L), round ((_e get "objs") select 0 distance ((_e get "objs") select 1))]) call _say;
    };
    case "negotiate": {
        if !(alive _t) exitWith {};
        private _n = (_d getOrDefault ["tries", 0]) + 1;
        _d set ["tries", _n];
        private _p = 0.25 + 0.1 * _n - (missionNamespace getVariable ["ADVSEC_unrest", 0]) / 400;
        if (random 1 < _p) then {
            removeAllWeapons _t;
            _t setCaptive true;
            _t enableAI "PATH";
            _t action ["Surrender", _t];
            _d set ["surrender", true];
            _d set ["by", _caller];
            ("STR_ADVSEC_call_surrender" call ADVSEC_fnc_L) call _say;
        } else {
            (format [("STR_ADVSEC_call_refuse" call ADVSEC_fnc_L), _n]) call _say;
        };
    };
    case "collect": {
        if (_d getOrDefault ["collected", false]) exitWith {};
        removeAllWeapons _t;
        _d set ["collected", true];
        _d set ["by", _caller];
        ("STR_ADVSEC_call_collected" call ADVSEC_fnc_L) call _say;
    };
};
