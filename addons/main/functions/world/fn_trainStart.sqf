/*
    (cliente, 1.24) instrucción guiada para reclutas: pasos con marcador en el mapa y lista en pantalla.
    Al terminar, el servidor comprueba lo que puede comprobar y da los méritos de trainMerit.
*/
if (!isNil "ADVSEC_trainH" && {!scriptDone ADVSEC_trainH}) exitWith {terminate ADVSEC_trainH; hintSilent ""; deleteMarkerLocal "advsec_train"; hint ("STR_ADVSEC_tr_stop" call ADVSEC_fnc_L)};
ADVSEC_trainH = [] spawn {
    private _near = {
        // [lista de objetos] -> el más cercano o objNull
        params ["_l"];
        _l = _l select {!isNull _x};
        if (_l isEqualTo []) exitWith {objNull};
        ([_l, [], {_x distance player}, "ASCEND"] call BIS_fnc_sortBy) select 0
    };
    private _reg = {params ["_k"]; (missionNamespace getVariable ["ADVSEC_secObjects", []]) select {(_x select 1) == _k} apply {_x select 0}};
    // [texto, objetivo (código -> objeto/posición o objNull), hecho (código)]
    private _steps = [
        ["STR_ADVSEC_tr_s1", {objNull}, {"ADVSEC_MPBadge" in (items player + assignedItems player) || {[player, "PM"] call ADVSEC_fnc_repAccess}}],
        ["STR_ADVSEC_tr_s2", {[["duty"] call _reg] call _near}, {player getVariable ["ADVSEC_onDuty", false]}],
        ["STR_ADVSEC_tr_s3", {[["school"] call _reg] call _near}, {private _o = [["school"] call _reg] call _near; isNull _o || {player distance _o < 8}}],
        ["STR_ADVSEC_tr_s4", {[["mpcrate"] call _reg] call _near}, {private _o = [["mpcrate"] call _reg] call _near; isNull _o || {player distance _o < 6}}],
        ["STR_ADVSEC_tr_s5", {[missionNamespace getVariable ["ADVSEC_jails", []]] call _near}, {private _o = [missionNamespace getVariable ["ADVSEC_jails", []]] call _near; isNull _o || {player distance _o < 12}}],
        ["STR_ADVSEC_tr_s6", {[["phone"] call _reg] call _near}, {private _o = [["phone"] call _reg] call _near; isNull _o || {player distance _o < 5}}],
        ["STR_ADVSEC_tr_s7", {objNull}, {player getVariable ["ADVSEC_trainRep", false]}]
    ];
    private _i = 0;
    while {_i < count _steps} do {
        (_steps select _i) params ["_k", "_tgt", "_done"];
        private _o = call _tgt;
        deleteMarkerLocal "advsec_train";
        if (!isNull _o) then {
            private _m = createMarkerLocal ["advsec_train", getPosATL _o];
            _m setMarkerTypeLocal "mil_objective";
            _m setMarkerColorLocal "ColorYellow";
            _m setMarkerTextLocal format ["%1 %2", "STR_ADVSEC_tr_title" call ADVSEC_fnc_L, _i + 1];
        };
        private _t = format ["<t font='PuristaBold' size='1.1'>%1</t><br/><br/>", "STR_ADVSEC_tr_title" call ADVSEC_fnc_L];
        {
            private _col = if (_forEachIndex < _i) then {"#66DD66"} else {["#888888", "#FFD24D"] select (_forEachIndex == _i)};
            _t = _t + format ["<t color='%1'>%2. %3</t><br/>", _col, _forEachIndex + 1, (_x select 0) call ADVSEC_fnc_L];
        } forEach _steps;
        if (!isNull _o) then {_t = _t + format ["<br/>%1", format [("STR_ADVSEC_tr_dist" call ADVSEC_fnc_L), round (player distance _o)]]};
        hintSilent parseText _t;
        if (call _done) then {_i = _i + 1; playSound "FD_Finish_F"};
        sleep 2;
    };
    deleteMarkerLocal "advsec_train";
    hintSilent "";
    ["trainDone", player, []] remoteExecCall ["ADVSEC_fnc_trainServer", 2];
};
