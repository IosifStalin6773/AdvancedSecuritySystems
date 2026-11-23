/*
    [] (servidor) — riesgo de fuga (1.22). Arranca una sola vez desde rpInit.
    Traslado: un detenido dentro de un vehículo tiene transferEscapeChance por minuto de probabilidad de intentar la fuga.
    Intento: si se escapa, queda libre y busca (wanted); si lo frenan, sufre daño y se registra un informe.
*/
if (!isServer || {!isNil "ADVSEC_jailCareLoopOn"}) exitWith {};
ADVSEC_jailCareLoopOn = true;
[] spawn {
    while {true} do {
        sleep 30;
        // 1.22: cámara corporal que se activa al desenfundar (bodycamAutoDraw) y batería (bodycamBatteryMin, minutos; 0 = infinita)
        private _auto = (["bodycamAutoDraw", 0] call ADVSEC_fnc_setting) isEqualTo 1;
        private _bat = ["bodycamBatteryMin", 0] call ADVSEC_fnc_setting;
        {
            private _u = _x;
            if (_auto && {_u getVariable ["ADVSEC_onDuty", false]} && {currentWeapon _u isNotEqualTo ""} && {!(_u getVariable ["ADVSEC_bodycam", false])}) then {
                _u setVariable ["ADVSEC_bodycam", true, true];
                ["bodycamOn", _u, []] call ADVSEC_fnc_logEvent;
            };
            if (_u getVariable ["ADVSEC_bodycam", false]) then {
                private _run = (_u getVariable ["ADVSEC_bodyRun", 0]) + 30;
                _u setVariable ["ADVSEC_bodyRun", _run];
                if (_bat > 0 && {_run > _bat * 60}) then {
                    _u setVariable ["ADVSEC_bodycam", false, true];
                    _u setVariable ["ADVSEC_bodyRun", 0];
                    ["bodycamBattery", _u, []] call ADVSEC_fnc_logEvent;
                    if (isPlayer _u) then {("STR_ADVSEC_m_bat_low" call ADVSEC_fnc_L) remoteExecCall ["hint", _u]};
                };
            } else {
                _u setVariable ["ADVSEC_bodyRun", 0];
            };
        } forEach (allPlayers + (allUnits select {!isPlayer _x && {_x getVariable ["ADVSEC_onDuty", false]}}));
        private _p = ["transferEscapeChance", 0.02] call ADVSEC_fnc_setting;
        if (_p > 0) then {
            {
                private _u = _x;
                if ((_u getVariable ["ADVSEC_jailUntil", 0]) > serverTime && {!isNull objectParent _u} && {random 1 < _p}) then {
                    [_u] call ADVSEC_fnc_escapeAttempt;
                };
            } forEach (allPlayers + (allUnits select {!isPlayer _x}));
        };
    };
};
