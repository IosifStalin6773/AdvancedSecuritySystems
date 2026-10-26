/*
    [acción, valor] — cámara corporal en directo (cliente, permiso bodycamView)
    "open" [SteamID opcional] · "list" · "select" · "step" [±1] · "frame" · "off"
*/
params ["_a", ["_v", ""]];
private _d = findDisplay 88000;
switch (_a) do {
    case "open": {
        if !([player, "bodycamView"] call ADVSEC_fnc_perm) exitWith {hint "Tu rango no permite ver las cámaras corporales."};
        if (isNull _d && {!createDialog "ADVSEC_BodyLive"}) exitWith {};
        ADVSEC_bodyLiveUid = _v;
        ADVSEC_bodyLiveTick = 0;
        (findDisplay 88000 displayCtrl 88006) ctrlSetStructuredText parseText (["<t color='#8C8C8C'>Imagen en directo de la cámara del agente. Cada visionado queda registrado.</t>", "<t color='#FF6655'>Activa «Imagen en imagen (PiP)» en Opciones › Vídeo para ver la señal.</t>"] select !isPiPEnabled);
        ["list"] call ADVSEC_fnc_bodyLive;
        if (isNil "ADVSEC_bodyLiveEH") then {ADVSEC_bodyLiveEH = addMissionEventHandler ["EachFrame", {["frame"] call ADVSEC_fnc_bodyLive}]};
    };
    case "list": {
        if (isNull _d) exitWith {};
        private _lb = _d displayCtrl 88002;
        private _units = (allPlayers select {alive _x && {_x getVariable ["ADVSEC_bodycam", false]}}) apply {[name _x, getPlayerUID _x]};
        _units sort true;
        if ((_units apply {_x select 1}) isEqualTo (missionNamespace getVariable ["ADVSEC_bodyLiveList", []]) && {lbSize _lb > 0}) exitWith {};
        ADVSEC_bodyLiveList = _units apply {_x select 1};
        lbClear _lb;
        private _sel = 0;
        {
            private _i = _lb lbAdd format ["● %1", _x select 0];
            _lb lbSetData [_i, _x select 1];
            _lb lbSetColor [_i, [0.45, 1, 0.45, 1]];
            if ((_x select 1) isEqualTo ADVSEC_bodyLiveUid) then {_sel = _i};
        } forEach _units;
        if (_units isEqualTo []) then {
            ADVSEC_bodyLiveUid = "";
            ["select"] call ADVSEC_fnc_bodyLive;
        } else {
            _lb lbSetCurSel _sel;
        };
    };
    case "select": {
        if (isNull _d) exitWith {};
        private _lb = _d displayCtrl 88002;
        private _r = lbCurSel _lb;
        private _uid = ["", _lb lbData _r] select (_r >= 0);
        if (_uid isNotEqualTo ADVSEC_bodyLiveUid && {_uid isNotEqualTo ""}) then {["watch", player, [_uid]] remoteExecCall ["ADVSEC_fnc_bodyServer", 2]};
        ADVSEC_bodyLiveUid = _uid;
        private _cam = missionNamespace getVariable ["ADVSEC_bodyLiveCam", objNull];
        if (_uid isNotEqualTo "" && {isNull _cam}) then {
            _cam = "camera" camCreate (ASLToAGL eyePos player);
            _cam cameraEffect ["internal", "back", "advsec_body"];
            _cam camSetFov 0.85;
            "advsec_body" setPiPEffect [0];
            ADVSEC_bodyLiveCam = _cam;
        };
        (_d displayCtrl 88003) ctrlSetText (["", "#(argb,512,512,1)r2t(advsec_body,1.0)"] select (_uid isNotEqualTo ""));
        ADVSEC_bodyLiveTick = 0;
    };
    case "step": {
        if (isNull _d) exitWith {};
        private _lb = _d displayCtrl 88002;
        if (lbSize _lb == 0) exitWith {};
        _lb lbSetCurSel (((lbCurSel _lb) + _v + lbSize _lb) mod (lbSize _lb));
    };
    case "frame": {
        if (isNull _d) exitWith {["off"] call ADVSEC_fnc_bodyLive};
        private _u = [objNull, [ADVSEC_bodyLiveUid] call ADVSEC_fnc_uidUnit] select (ADVSEC_bodyLiveUid isNotEqualTo "");
        private _ok = !isNull _u && {alive _u} && {_u getVariable ["ADVSEC_bodycam", false]};
        private _cam = missionNamespace getVariable ["ADVSEC_bodyLiveCam", objNull];
        // Cámara al pecho del agente, mirando hacia donde mira
        if (_ok && {!isNull _cam}) then {
            private _dir = eyeDirection _u;
            private _pos = (eyePos _u) vectorAdd (_dir vectorMultiply 0.25) vectorAdd [0, 0, -0.22];
            private _up = vectorNormalized ((_dir vectorCrossProduct [0, 0, 1]) vectorCrossProduct _dir);
            _cam setPosASL _pos;
            _cam setVectorDirAndUp [_dir, _up];
        };
        if (diag_tickTime < ADVSEC_bodyLiveTick) exitWith {};
        ADVSEC_bodyLiveTick = diag_tickTime + 0.5;
        (_d displayCtrl 88003) ctrlShow _ok;
        (_d displayCtrl 88005) ctrlSetStructuredText parseText (["<t align='center' size='1.6' font='RobotoCondensedBold' color='#FF5544'>SIN SEÑAL</t><br/><t align='center' color='#8C8C8C'>No hay ningún agente con la cámara encendida.</t>", ""] select _ok);
        if (_ok) then {
            date params ["_y", "_m", "_dd"];
            (_d displayCtrl 88004) ctrlSetStructuredText parseText format ["<t color='#FF4040' font='RobotoCondensedBold'>%1 REC</t>  CAM-%2  ·  %3  ·  %4/%5/%6 %7  ·  CUAD. %8",
                ["●", " "] select ((floor diag_tickTime) mod 2 == 1), ADVSEC_bodyLiveUid select [((count ADVSEC_bodyLiveUid) - 4) max 0], (name _u) call ADVSEC_fnc_repEsc, _dd, _m, _y, [dayTime, "HH:MM:SS"] call BIS_fnc_timeToString, mapGridPosition _u];
        } else {
            (_d displayCtrl 88004) ctrlSetStructuredText parseText "";
        };
        // La lista se refresca cada pocos segundos (agentes que encienden o apagan)
        if ((floor diag_tickTime) mod 3 == 0) then {["list"] call ADVSEC_fnc_bodyLive};
    };
    case "off": {
        if (!isNil "ADVSEC_bodyLiveEH") then {removeMissionEventHandler ["EachFrame", ADVSEC_bodyLiveEH]; ADVSEC_bodyLiveEH = nil};
        private _cam = missionNamespace getVariable ["ADVSEC_bodyLiveCam", objNull];
        if (!isNull _cam) then {_cam cameraEffect ["terminate", "back", "advsec_body"]; camDestroy _cam};
        ADVSEC_bodyLiveCam = objNull;
        ADVSEC_bodyLiveList = [];
    };
};
