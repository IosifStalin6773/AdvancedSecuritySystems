// [acción, llamador, args] (servidor) — cámaras corporales: "list" · "view" [SteamID] · "watch" [SteamID] (permiso bodycamView)
params ["_action", "_caller", ["_args", []]];
if (!isServer) exitWith {};
if !([_caller] call ADVSEC_fnc_srvCaller) exitWith {};
if !([_caller, "bodycamView"] call ADVSEC_fnc_perm) exitWith {[_caller, ("STR_ADVSEC_review_body_cameras" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
private _db = [] call ADVSEC_fnc_bodyDB;
switch (_action) do {
    case "list": {
        private _rows = [];
        {
            private _u = [_x] call ADVSEC_fnc_uidUnit;
            private _on = !isNull _u && {_u getVariable ["ADVSEC_bodycam", false]};
            _rows pushBack [format [("STR_ADVSEC_entries" call ADVSEC_fnc_L), ["", "● "] select _on, _y select 0, count (_y select 1)], _x, format ["<t font='RobotoCondensedBold'>%1</t><br/>SteamID: %2<br/>%3", (_y select 0) call ADVSEC_fnc_repEsc, _x, [("STR_ADVSEC_camera_off_or_off_duty" call ADVSEC_fnc_L), ("STR_ADVSEC_recording" call ADVSEC_fnc_L)] select _on], [[], [0.45, 1, 0.45, 1]] select _on, ""];
        } forEach _db;
        ["bodycam", format [("STR_ADVSEC_officers_with_recordings_view_recording" call ADVSEC_fnc_L), count _rows], _rows] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
    };
    case "watch": {
        // Visionado en directo: queda en el registro de AA.II.
        _args params [["_uid", ""]];
        ["bodycamLive", _caller, [_uid]] call ADVSEC_fnc_logEvent;
    };
    case "clip": {
        // 1.22: marcar un registro de la cámara como prueba: informe F-AI con sello (hash del contenido) y cadena de custodia
        // Marca el registro más reciente del agente indicado
        _args params [["_uid", ""]];
        private _e = _db getOrDefault [_uid, []];
        if (_e isEqualTo [] || {(_e select 1) isEqualTo []}) exitWith {};
        (_e select 1) select (count (_e select 1) - 1) params ["_d", "_t", "_g", "_data"];
        private _txt = str [_uid, _d, _t, _g, _data];
        private _h = 0;
        {_h = (_h * 31 + _x) mod 9999991} forEach toArray _txt;
        private _seal = format ["SEL-%1", _h];
        private _id = ["FAI01", format [("STR_ADVSEC_m_clip_title" call ADVSEC_fnc_L), _e select 0], [format ["%1 [%2]", _e select 0, _uid]],
            format [("STR_ADVSEC_m_clip_body" call ADVSEC_fnc_L), _d, _t, _g, str _data, _seal, name _caller], "Leve", false] call ADVSEC_fnc_repSystem;
        ["bodyClip", _caller, [_e select 0, _seal, _id]] call ADVSEC_fnc_logEvent;
        (format [("STR_ADVSEC_m_clip_done" call ADVSEC_fnc_L), _id, _seal]) remoteExecCall ["hint", _caller];
    };
    case "view": {
        _args params [["_uid", ""]];
        private _e = _db getOrDefault [_uid, []];
        if (_e isEqualTo []) exitWith {};
        private _rows = (_e select 1) apply {
            _x params ["_d", "_t", "_g", "_data"];
            [format ["%1 · %2 · %3", _d, _t, _g], _uid, format [("STR_ADVSEC_grid_4" call ADVSEC_fnc_L), _t, _d, _g, (str _data) call ADVSEC_fnc_repEsc], [], ""]
        };
        reverse _rows;
        ["bodycamView", _caller, [_uid]] call ADVSEC_fnc_logEvent;
        ["bodycam", format [("STR_ADVSEC_recording_entries" call ADVSEC_fnc_L), (_e select 0) call ADVSEC_fnc_repEsc, count _rows], _rows] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
    };
};
