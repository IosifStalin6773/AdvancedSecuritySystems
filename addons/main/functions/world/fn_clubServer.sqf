/*
    [acción, llamador, args] (servidor, 1.24) — club de suboficiales
    "drink" (quita la fatiga; a la tercera, visión borrosa) · "cards" [club, apuesta] (gana el 45 %, cobra el doble)
    "darts" (tirada de 3 dardos; guarda el récord) · "board" (récords de dardos)
*/
params ["_action", "_caller", ["_args", []]];
if (!isServer) exitWith {};
_args params [["_obj", objNull]];
if !([_caller, _obj, 6] call ADVSEC_fnc_srvCaller) exitWith {};
if (_action != "board" && {(_caller getVariable ["ADVSEC_globalRankIdx", 0]) < (["clubMinRank", 0] call ADVSEC_fnc_setting)}) exitWith {[_caller, ("STR_ADVSEC_club" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
private _cur = ["currency", "€"] call ADVSEC_fnc_setting;
private _say = {_this remoteExecCall ["hint", _caller]};
private _best = missionNamespace getVariable ["ADVSEC_clubDarts", createHashMap];
ADVSEC_clubDarts = _best;
switch (_action) do {
    case "drink": {
        private _p = ["clubDrinkPrice", 5] call ADVSEC_fnc_setting;
        if ([] call ADVSEC_fnc_ecoOn && {!([_caller, _p, "STR_ADVSEC_club_drink" call ADVSEC_fnc_L, false] call ADVSEC_fnc_ecoCharge)}) exitWith {("STR_ADVSEC_club_nomoney" call ADVSEC_fnc_L) call _say};
        private _n = (_caller getVariable ["ADVSEC_clubDrinks", 0]) + 1;
        _caller setVariable ["ADVSEC_clubDrinks", _n];
        [_caller, 0] remoteExecCall ["setFatigue", _caller];
        if (_n >= 3) then {
            [] remoteExecCall ["ADVSEC_fnc_clubDrunk", _caller];
            _caller setVariable ["ADVSEC_clubDrinks", 0];
        };
        ((["STR_ADVSEC_club_drink_ok", "STR_ADVSEC_club_drink_much"] select (_n >= 3)) call ADVSEC_fnc_L) call _say;
    };
    case "cards": {
        private _bet = ((_args param [1, 10]) max 10) min 200;
        if !([] call ADVSEC_fnc_ecoOn) exitWith {};
        if !([_caller, _bet, "STR_ADVSEC_club_cards" call ADVSEC_fnc_L, true] call ADVSEC_fnc_ecoCharge) exitWith {("STR_ADVSEC_club_nomoney" call ADVSEC_fnc_L) call _say};
        if (random 1 < 0.45) then {
            private _a = [getPlayerUID _caller, name _caller] call ADVSEC_fnc_ecoAcc;
            _a set [1, (_a select 1) + 2 * _bet];
            _caller setVariable ["ADVSEC_bank", _a select 1, true];
            [_a, "STR_ADVSEC_club_cards" call ADVSEC_fnc_L, 2 * _bet] call ADVSEC_fnc_ecoHist;
            [-2 * _bet, "STR_ADVSEC_club_cards" call ADVSEC_fnc_L] call ADVSEC_fnc_ecoTreasury;
            (format [("STR_ADVSEC_club_win" call ADVSEC_fnc_L), 2 * _bet, _cur]) call _say;
        } else {
            (format [("STR_ADVSEC_club_lose" call ADVSEC_fnc_L), _bet, _cur]) call _say;
        };
    };
    case "darts": {
        private _last = _caller getVariable ["ADVSEC_clubDartsT", -60];
        if (serverTime - _last < 20) exitWith {};
        _caller setVariable ["ADVSEC_clubDartsT", serverTime];
        // Tres dardos: segmento 1-20 y a veces doble o triple
        private _s = 0;
        private _det = [];
        for "_i" from 1 to 3 do {
            private _seg = 1 + floor random 20;
            private _m = selectRandomWeighted [1, 0.75, 2, 0.15, 3, 0.1];
            _s = _s + _seg * _m;
            _det pushBack (["", "D", "T"] select (_m - 1)) + str _seg;
        };
        private _uid = getPlayerUID _caller;
        private _old = (_best getOrDefault [_uid, [0, ""]]) select 0;
        if (_s > _old) then {_best set [_uid, [_s, name _caller]]};
        (format [("STR_ADVSEC_club_darts_res" call ADVSEC_fnc_L), _det joinString " · ", _s, [_old, _s] select (_s > _old)]) call _say;
        if (_s >= 100) then {(format [("STR_ADVSEC_club_darts_ton" call ADVSEC_fnc_L), name _caller, _s]) remoteExecCall ["systemChat", allPlayers select {_x distance _obj < 30}]};
    };
    case "board": {
        private _l = (values _best) apply {[_x select 0, _x select 1]};
        _l sort false;
        private _t = format ["<t font='PuristaBold'>%1</t><br/><br/>", "STR_ADVSEC_club_board" call ADVSEC_fnc_L];
        {_t = _t + format ["%1. %2 · %3<br/>", _forEachIndex + 1, (_x select 1) call ADVSEC_fnc_repEsc, _x select 0]} forEach (_l select [0, 10]);
        if (_l isEqualTo []) then {_t = _t + ("STR_ADVSEC_club_board_empty" call ADVSEC_fnc_L)};
        [_t, "STR_ADVSEC_club_board" call ADVSEC_fnc_L] remoteExecCall ["ADVSEC_fnc_carShow", _caller];
    };
};
