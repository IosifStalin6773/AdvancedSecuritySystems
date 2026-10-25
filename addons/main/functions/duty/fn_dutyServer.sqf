// [acción, llamador, args] (servidor) — "toggle" [terminal] · "list" · "bodycam" (alternar)
params ["_action", "_caller", ["_args", []]];
if (!isServer) exitWith {};
if !([_caller] call ADVSEC_fnc_srvCaller) exitWith {};
private _say = {_this remoteExecCall ["hint", _caller]};
switch (_action) do {
    case "toggle": {
        _args params [["_term", objNull]];
        if !([_caller, "PM"] call ADVSEC_fnc_repAccess || {[_caller, "AI"] call ADVSEC_fnc_repAccess}) exitWith {"Necesitas placa PM o credencial AA.II. para fichar." call _say};
        if ((["dutyAnywhere", 1] call ADVSEC_fnc_setting) isNotEqualTo 1 && {isNull _term || {!(_term getVariable ["ADVSEC_dutyTerm", false])} || {(_caller distance _term) > 6}}) exitWith {"Ficha en un terminal de fichaje." call _say};
        private _on = !(_caller getVariable ["ADVSEC_onDuty", false]);
        [_caller, _on] call ADVSEC_fnc_dutySet;
        private _h = (([] call ADVSEC_fnc_dutyDB) getOrDefault [getPlayerUID _caller, [0]]) select 0;
        (format ["%1 · Horas de servicio acumuladas: %2 h %3 min%4", ["FIN DE SERVICIO", "ENTRADA DE SERVICIO"] select _on, floor (_h / 60), _h mod 60, ["", ". Cámara corporal encendida."] select _on]) call _say;
    };
    case "bodycam": {
        if !(_caller getVariable ["ADVSEC_onDuty", false]) exitWith {"La cámara corporal solo se usa de servicio." call _say};
        private _on = !(_caller getVariable ["ADVSEC_bodycam", false]);
        _caller setVariable ["ADVSEC_bodycam", _on, true];
        [["bodycamOff", "bodycamOn"] select _on, _caller, []] call ADVSEC_fnc_logEvent;
        if (!_on) then {[_caller, "bodycamOff", "Apagó la cámara de servicio"] call ADVSEC_fnc_heatAdd};
        (["Cámara corporal APAGADA (queda registrado).", "Cámara corporal encendida."] select _on) call _say;
    };
    case "list": {
        if !([_caller, "dutyView"] call ADVSEC_fnc_perm) exitWith {[_caller, "ver el control de servicio"] call ADVSEC_fnc_deny};
        private _rows = [];
        {
            _y params ["_min", "_name", "_shifts"];
            private _u = [_x] call ADVSEC_fnc_uidUnit;
            private _on = !isNull _u && {_u getVariable ["ADVSEC_onDuty", false]};
            if (_on) then {_min = _min + round ((serverTime - (_u getVariable ["ADVSEC_dutyStart", serverTime])) / 60)};
            _rows pushBack [format ["%1%2 · %3 h %4 min", ["", "● "] select _on, _name, floor (_min / 60), _min mod 60], _x,
                format ["<t font='RobotoCondensedBold'>%1</t><br/>%2<br/>Total: %3 h %4 min<br/><br/>%5", _name call ADVSEC_fnc_repEsc, ["Fuera de servicio", "<t color='#66FF66'>DE SERVICIO</t>"] select _on, floor (_min / 60), _min mod 60,
                    ((_shifts select [((count _shifts) - 12) max 0]) apply {format ["%1 → %2 · %3 min", _x select 0, _x select 1, _x select 2]}) joinString "<br/>"], [[], [0.45, 1, 0.45, 1]] select _on, ""];
        } forEach ([] call ADVSEC_fnc_dutyDB);
        ["duty", format ["Agentes con turnos registrados: %1 · ● = de servicio ahora", count _rows], _rows] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
    };
};
