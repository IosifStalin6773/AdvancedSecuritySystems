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
                "<t font='RobotoCondensedBold'>%1</t> · %2<br/><br/>«Buenos días, control policial. Documentación, por favor.»<br/><t color='#8C8C8C' size='0.85'>Tiempo para responder: %3 s</t>",
                [_officer] call ADVSEC_fnc_repEsc, [_cp] call ADVSEC_fnc_repEsc, (ceil (_deadline - serverTime)) max 0
            ];
        };
        sleep 0.5;
    };
    if (!isNull findDisplay 87600) then {(findDisplay 87600) closeDisplay 2};
    ADVSEC_cpAskH = nil;
};
