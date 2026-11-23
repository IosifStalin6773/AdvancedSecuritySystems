/*
    [vehículo, nombreAgente, nombreControl, límite (serverTime)] — cliente: el agente pide la documentación.
    El servidor es quien cuenta el tiempo (40 s) y decide; aquí solo se muestra la cuenta atrás y se vigila el diálogo:
    - se cierra solo si el control suelta el vehículo, el jugador sale de él o muere;
    - si el jugador lo cierra con Esc sin responder, se vuelve a abrir (hay que elegir Mostrar o Negarse).
*/
params ["_veh", "_officer", "_cp", ["_deadline", -1]];
if (!hasInterface || {vehicle player != _veh}) exitWith {};
if (_deadline < 0) then {_deadline = serverTime + 40};
ADVSEC_cpAskVeh = _veh;
ADVSEC_cpAskInfo = [_officer, _cp, _deadline];
ADVSEC_cpAnswered = false;
if (!isNil "ADVSEC_cpAskH") then {terminate ADVSEC_cpAskH};
ADVSEC_cpAskH = [_veh] spawn {
    params ["_veh"];
    private _pending = {
        alive player && {vehicle player == _veh} && {_veh getVariable ["ADVSEC_cpHold", false]}
        && {!ADVSEC_cpAnswered} && {serverTime < ((ADVSEC_cpAskInfo select 2) + 2)}
    };
    while _pending do {
        if (isNull findDisplay 87600) then {
            if (createDialog "ADVSEC_CpAsk") then {playSound "FD_CP_Not_Clear_F"};
        };
        ADVSEC_cpAskInfo params ["_officer", "_cp", "_deadline"];
        private _ctrl = (findDisplay 87600) displayCtrl 87602;
        if (!isNull _ctrl) then {
            _ctrl ctrlSetStructuredText parseText format [
                ("STR_ADVSEC_good_morning_police_checkpoint_documents" call ADVSEC_fnc_L),
                [_officer] call ADVSEC_fnc_repEsc, [_cp] call ADVSEC_fnc_repEsc, (ceil (_deadline - serverTime)) max 0
            ];
            // El cuadro crece con el texto: los botones bajan y el fondo se alarga
            private _d = findDisplay 87600;
            private _p = ctrlPosition _ctrl;
            private _h = (ctrlTextHeight _ctrl) max ((_p select 3) min 0.05);
            if (abs (_h - (_p select 3)) > 0.002) then {
                _ctrl ctrlSetPosition [_p select 0, _p select 1, _p select 2, _h];
                _ctrl ctrlCommit 0;
                private _by = (_p select 1) + _h + 0.015;
                {
                    private _b = _d displayCtrl _x;
                    private _bp = ctrlPosition _b;
                    _b ctrlSetPosition [_bp select 0, _by, _bp select 2, _bp select 3];
                    _b ctrlCommit 0;
                } forEach [87603, 87604];
                private _bh = (ctrlPosition (_d displayCtrl 87603)) select 3;
                {
                    private _c = _d displayCtrl _x;
                    private _cp0 = ctrlPosition _c;
                    _c ctrlSetPosition [_cp0 select 0, _cp0 select 1, _cp0 select 2, (_by + _bh + 0.015) - (_cp0 select 1)];
                    _c ctrlCommit 0;
                } forEach [87605, 87606, 87607];
            };
        };
        sleep 0.5;
    };
    if (!isNull findDisplay 87600) then {(findDisplay 87600) closeDisplay 2};
    ADVSEC_cpAskH = nil;
};
