// [acción, llamador, args] (servidor) — cámaras corporales: "list" · "view" [SteamID] · "watch" [SteamID] (permiso bodycamView)
params ["_action", "_caller", ["_args", []]];
if (!isServer) exitWith {};
if !([_caller] call ADVSEC_fnc_srvCaller) exitWith {};
if !([_caller, "bodycamView"] call ADVSEC_fnc_perm) exitWith {[_caller, "revisar cámaras corporales"] call ADVSEC_fnc_deny};
private _db = [] call ADVSEC_fnc_bodyDB;
switch (_action) do {
    case "list": {
        private _rows = [];
        {
            private _u = [_x] call ADVSEC_fnc_uidUnit;
            private _on = !isNull _u && {_u getVariable ["ADVSEC_bodycam", false]};
            _rows pushBack [format ["%1%2 · %3 registros", ["", "● "] select _on, _y select 0, count (_y select 1)], _x, format ["<t font='RobotoCondensedBold'>%1</t><br/>SteamID: %2<br/>%3", (_y select 0) call ADVSEC_fnc_repEsc, _x, ["Cámara apagada o fuera de servicio", "<t color='#66FF66'>GRABANDO</t>"] select _on], [[], [0.45, 1, 0.45, 1]] select _on, ""];
        } forEach _db;
        ["bodycam", format ["Agentes con grabaciones: %1 · «Ver grabación» muestra sus acciones registradas", count _rows], _rows] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
    };
    case "watch": {
        // Visionado en directo: queda en el registro de AA.II.
        _args params [["_uid", ""]];
        ["bodycamLive", _caller, [_uid]] call ADVSEC_fnc_logEvent;
    };
    case "view": {
        _args params [["_uid", ""]];
        private _e = _db getOrDefault [_uid, []];
        if (_e isEqualTo []) exitWith {};
        private _rows = (_e select 1) apply {
            _x params ["_d", "_t", "_g", "_data"];
            [format ["%1 · %2 · %3", _d, _t, _g], _uid, format ["<t font='RobotoCondensedBold'>%1</t><br/>%2 · cuadrícula %3<br/><br/>%4", _t, _d, _g, (str _data) call ADVSEC_fnc_repEsc], [], ""]
        };
        reverse _rows;
        ["bodycamView", _caller, [_uid]] call ADVSEC_fnc_logEvent;
        ["bodycam", format ["<t font='RobotoCondensedBold'>GRABACIÓN · %1</t> · %2 registros", (_e select 0) call ADVSEC_fnc_repEsc, count _rows], _rows] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
    };
};
