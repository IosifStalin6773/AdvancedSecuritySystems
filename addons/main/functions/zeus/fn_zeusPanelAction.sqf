params ["_action"];
private _disp = findDisplay 87000;
if (isNull _disp) exitWith {};
private _ref = [player, curatorCamera] select (!isNull curatorCamera);
private _ol = _disp displayCtrl 87010;
private _pl = _disp displayCtrl 87012;
(missionNamespace getVariable ["ADVSEC_zpObjs", []]) param [lbCurSel _ol, []] params [["_obj", objNull], ["_kind", ""], ["_label", ""], ["_data", []]];
private _unit = (missionNamespace getVariable ["ADVSEC_zpUnits", []]) param [lbCurSel _pl, objNull];
private _msg = {if (!isNull findDisplay 312) then {[objNull, _this] call BIS_fnc_showCuratorFeedbackMessage} else {hint _this}};
private _goto = {
    params ["_o"];
    if (isNull _o) exitWith {};
    closeDialog 0;
    if (isNull curatorCamera) exitWith {};
    curatorCamera setPosASL ((getPosASL _o) vectorAdd [0, -18, 14]);
    curatorCamera setVectorDirAndUp [vectorNormalized [0, 18, -14], vectorNormalized [0, 14, 18]];
};
private _needObj = {
    params ["_kinds"];
    if (isNull _obj) exitWith {"Selecciona un objeto de la lista." call _msg; false};
    if !(_kind in _kinds) exitWith {format ["Esta acción no se aplica a: %1.", ADVSEC_kindNames getOrDefault [_kind, _kind]] call _msg; false};
    true
};
private _needUnit = {
    if (isNull _unit) exitWith {"Selecciona un jugador." call _msg; false};
    true
};

switch (_action) do {
    case "refresh": {
        private _f = _disp displayCtrl 87014;
        private _filter = _f lbData (lbCurSel _f);
        private _objs = (missionNamespace getVariable ["ADVSEC_secObjects", []]) select {!isNull (_x select 0) && {_filter isEqualTo "" || {(_x select 1) == _filter}}};
        ADVSEC_zpObjs = [_objs, [], {(_x select 0) distance _ref}, "ASCEND"] call BIS_fnc_sortBy;
        lbClear _ol;
        {
            _x params ["_o", "_k", "_l"];
            private _i = _ol lbAdd format ["%1 · %2 · %3 m", ADVSEC_kindNames getOrDefault [_k, _k], _l, round (_o distance _ref)];
            _ol lbSetPicture [_i, ADVSEC_kindIcons getOrDefault [_k, ""]];
            if (_k == "alarm" && {_o getVariable ["ADVSEC_active", false]}) then {_ol lbSetColor [_i, [1, 0.302, 0.302, 1]]};
        } forEach ADVSEC_zpObjs;

        private _wanted = missionNamespace getVariable ["ADVSEC_wantedUIDs", []];
        ADVSEC_zpUnits = [(allPlayers - entities "HeadlessClient_F") select {alive _x}, [], {_x distance _ref}, "ASCEND"] call BIS_fnc_sortBy;
        lbClear _pl;
        {
            private _tags = [];
            if ((getPlayerUID _x) in _wanted) then {_tags pushBack "BUSCADO"};
            if (_x getVariable ["ADVSEC_jailUntil", 0] > serverTime) then {_tags pushBack "DETENIDO"};
            if ([_x] call ADVSEC_fnc_isRestrained) then {_tags pushBack "ESPOSADO"};
            private _i = _pl lbAdd format ["%1 %2 · %3 m%4", [_x] call ADVSEC_fnc_rankName, name _x, round (_x distance _ref), ["", "  [" + (_tags joinString ", ") + "]"] select (_tags isNotEqualTo [])];
            if (_tags isNotEqualTo []) then {_pl lbSetColor [_i, [1, 0.302, 0.302, 1]]};
        } forEach ADVSEC_zpUnits;
        if (lbCurSel _ol < 0 && {lbSize _ol > 0}) then {_ol lbSetCurSel 0};
        if (lbCurSel _pl < 0 && {lbSize _pl > 0}) then {_pl lbSetCurSel 0};
    };
    case "selObj": {
        if (isNull _obj) exitWith {};
        private _lines = [format ["<t font='RobotoCondensedBold' color='#D0A330'>%1</t> · %2 · %3", ADVSEC_kindNames getOrDefault [_kind, _kind], [_label] call ADVSEC_fnc_repEsc, mapGridPosition _obj]];
        switch (_kind) do {
            case "door": {
                _lines pushBack ((_data apply {format ["Puerta %1: %2", _x, ["abierta", "<t color='#ff7777'>cerrada</t>"] select (_obj getVariable [format ["ADVSEC_locked_%1", _x], false])]}) joinString " · ");
            };
            case "keypad": {
                private _d = _obj getVariable ["ADVSEC_kpDoors", []];
                _lines pushBack format ["%1 puertas · alarma: %2 · tarjeta: %3", count _d, [_obj getVariable ["ADVSEC_kpAlarm", ""]] param [0, ""], str (_obj getVariable ["ADVSEC_kpReq", []])];
            };
            case "alarm": {
                _lines pushBack format ["Zona: %1 · %2%3", _data, ["desarmada", "armada"] select (_obj getVariable ["ADVSEC_armed", false]),
                    ["", format [" · <t color='#FF4D4D'>DISPARADA: %1</t>", _obj getVariable ["ADVSEC_reason", ""]]] select (_obj getVariable ["ADVSEC_active", false])];
            };
            case "camera": {_lines pushBack format ["Red: %1", _data]};
            case "monitor": {_lines pushBack format ["Red: %1", _data]};
            case "jail": {_lines pushBack format ["Radio %1 m · detenidos: %2", _obj getVariable ["ADVSEC_jailRadius", 0], ({(_x getVariable ["ADVSEC_jailObj", objNull]) isEqualTo _obj} count allPlayers)]};
        };
        (_disp displayCtrl 87011) ctrlSetStructuredText parseText (_lines joinString "<br/>");
    };
    case "selUnit": {
        if (isNull _unit) exitWith {};
        private _docs = ([_unit] call ADVSEC_fnc_docGetAll) apply {getText (([_x get "type"] call ADVSEC_fnc_docTypeCfg) >> "displayName")};
        private _w = (missionNamespace getVariable ["ADVSEC_wanted", []]) select {(_x select 0) == getPlayerUID _unit};
        private _jail = (_unit getVariable ["ADVSEC_jailUntil", 0]) - serverTime;
        private _txt = format ["<t font='RobotoCondensedBold' color='#D0A330'>%1</t> · %2 · %3<br/><t color='#8C8C8C'>Documentos:</t> %4",
            [name _unit] call ADVSEC_fnc_repEsc, getPlayerUID _unit, groupId group _unit, ["ninguno", _docs joinString ", "] select (_docs isNotEqualTo [])];
        if (_w isNotEqualTo []) then {_txt = _txt + format ["<br/><t color='#FF4D4D'>BUSCADO (%1): %2</t>", (_w select 0) select 3, [(_w select 0) select 2] call ADVSEC_fnc_repEsc]};
        if (_jail > 0) then {_txt = _txt + format ["<br/><t color='#D96600'>Detenido: %1 min restantes</t>", ceil (_jail / 60)]};
        (_disp displayCtrl 87013) ctrlSetStructuredText parseText _txt;
    };
    case "goto": {[_obj] call _goto};
    case "gotoUnit": {[_unit] call _goto};
    case "doors": {
        if !([["door", "keypad"]] call _needObj) exitWith {};
        private _pairs = if (_kind == "door") then {_data apply {[_obj, _x]}} else {_obj getVariable ["ADVSEC_kpDoors", []]};
        if (_pairs isEqualTo []) exitWith {"No tiene puertas asignadas." call _msg};
        (_pairs select 0) params ["_b", "_i"];
        private _lock = !(_b getVariable [format ["ADVSEC_locked_%1", _i], false]);
        {_x params ["_b", "_i"]; [_b, _i, _lock] call ADVSEC_fnc_doorSet} forEach _pairs;
        (["Puertas abiertas.", "Puertas cerradas."] select _lock) call _msg;
        [] spawn {sleep 0.3; ["selObj"] call ADVSEC_fnc_zeusPanelAction};
    };
    case "pin": {
        if !([["keypad"]] call _needObj) exitWith {};
        [format ["CAMBIAR PIN · %1", _label], [["Nuevo PIN (solo cifras)", ""]], {
            params ["_v", "_kp"];
            private _pin = (_v select 0) select [0, 8];
            if (_pin isEqualTo "" || {(_pin splitString "0123456789") isNotEqualTo []}) exitWith {hint "PIN no válido."};
            ["pin", player, [_kp, _pin]] remoteExecCall ["ADVSEC_fnc_zeusServer", 2];
        }, _obj] call ADVSEC_fnc_zeusPrompt;
    };
    case "camera": {
        if !([["camera", "monitor"]] call _needObj) exitWith {};
        private _tmp = "Land_HelipadEmpty_F" createVehicleLocal [0, 0, 0];
        _tmp setVariable ["ADVSEC_cams", [_obj getVariable ["ADVSEC_cams", []], _data] select (_kind == "camera")];
        closeDialog 0;
        if (!isNull findDisplay 312) then {(findDisplay 312) closeDisplay 2};
        [_tmp] spawn {params ["_t"]; sleep 0.2; [_t] call ADVSEC_fnc_cameraView; sleep 1; deleteVehicle _t};
    };
    case "arm";
    case "disarm";
    case "trigger";
    case "silence": {
        if !([["alarm"]] call _needObj) exitWith {};
        [_obj, _action, "orden de Zeus"] call ADVSEC_fnc_alarmSet;
        [] spawn {sleep 0.3; ["selObj"] call ADVSEC_fnc_zeusPanelAction};
    };
    case "police": {
        if !(call _needUnit) exitWith {};
        closeDialog 0;
        [_unit, "zeus"] call ADVSEC_fnc_policeMenu;
    };
    case "jail": {if (call _needUnit) then {[_unit] call ADVSEC_fnc_jailPrompt}};
    case "release": {if (call _needUnit) then {["release", player, [_unit]] remoteExecCall ["ADVSEC_fnc_jailServer", 2]}};
    case "giveMP";
    case "giveIA": {
        if !(call _needUnit) exitWith {};
        private _uid = getPlayerUID _unit;
        private _t = ["IABadge", "MPBadge"] select (_action == "giveMP");
        [_unit, _t, [
            ["name", name _unit], ["uid", _uid],
            ["number", (["AI-", "PM-"] select (_action == "giveMP")) + (_uid select [(count _uid - 8) max 0])],
            ["issuer", "Mando (Zeus)"]
        ]] call ADVSEC_fnc_docCreate;
        format ["%1 entregada a %2.", getText (([_t] call ADVSEC_fnc_docTypeCfg) >> "displayName"), name _unit] call _msg;
    };
    case "giveMil": {
        if !(call _needUnit) exitWith {};
        [_unit, true] call ADVSEC_fnc_docAutoIssue;
        format ["ID militar emitido a %1.", name _unit] call _msg;
    };
    case "docs": {
        if !(call _needUnit) exitWith {};
        closeDialog 0;
        [_unit] call ADVSEC_fnc_docListOpen;
    };
    case "wanted": {
        if !(call _needUnit) exitWith {};
        private _uid = getPlayerUID _unit;
        if (_uid in (missionNamespace getVariable ["ADVSEC_wantedUIDs", []])) then {
            ["del", player, [_uid]] remoteExecCall ["ADVSEC_fnc_wantedServer", 2];
        } else {
            [_unit] call ADVSEC_fnc_wantedPrompt;
        };
        [] spawn {sleep 0.5; ["refresh"] call ADVSEC_fnc_zeusPanelAction};
    };
    case "report": {
        if !(call _needUnit) exitWith {};
        ["PM", format ["%1 [%2]", name _unit, getPlayerUID _unit]] call ADVSEC_fnc_repEditorOpen;
    };
};
