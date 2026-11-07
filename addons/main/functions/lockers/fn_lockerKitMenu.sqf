/*
    (cliente) Equipo completo de la taquilla.
    ["children", taquilla, jugador] -> acciones ACE hijas (las pide la acción de config de la taquilla)
    ["apply", equipo] -> se pone el equipo enviado por el servidor
    [hay, fecha, resumen] -> respuesta del servidor a "info" (aviso en pantalla)
*/
params [["_a", ""], ["_b", objNull], ["_c", objNull]];
if (!hasInterface) exitWith {[]};
if (_a isEqualType true) exitWith {
    hint parseText ([format [("STR_ADVSEC_lkit_info" call ADVSEC_fnc_L), _b, _c call ADVSEC_fnc_repEsc], ("STR_ADVSEC_lkit_none" call ADVSEC_fnc_L)] select !_a);
};
switch (_a) do {
    case "apply": {
        player setUnitLoadout _b;
        [] spawn {sleep 0.5; [] call ADVSEC_fnc_docRestore};
        [];
    };
    case "children": {
        if (isNil "ace_interact_menu_fnc_createAction") exitWith {[]};
        private _out = [];
        {
            _x params ["_id", "_txt", "_op", "_icon"];
            private _act = [_id, _txt, _icon, {
                params ["_target", "_player", "_args"];
                [_args select 0, _player, _target] remoteExecCall ["ADVSEC_fnc_lockerKit", 2];
            }, {true}, {}, [_op]] call ace_interact_menu_fnc_createAction;
            _out pushBack [_act, [], _b];
        } forEach [
            ["advsec_lkit_save", ("STR_ADVSEC_lkit_act_save" call ADVSEC_fnc_L), "save", "\A3\ui_f\data\igui\cfg\actions\gear_ca.paa"],
            ["advsec_lkit_load", ("STR_ADVSEC_lkit_act_load" call ADVSEC_fnc_L), "load", "\A3\ui_f\data\igui\cfg\actions\reammo_ca.paa"],
            ["advsec_lkit_info", ("STR_ADVSEC_lkit_act_info" call ADVSEC_fnc_L), "info", "\A3\ui_f\data\igui\cfg\simpleTasks\types\documents_ca.paa"]
        ];
        _out
    };
    default {[]};
};
