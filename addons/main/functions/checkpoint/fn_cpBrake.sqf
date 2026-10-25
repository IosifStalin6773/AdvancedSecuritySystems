/*
    [vehículo, puntoDeParada (ATL, opcional)] — se ejecuta donde el vehículo es LOCAL (su conductor).
    Frenado suave por fotograma: deceleración calculada para parar antes del control (2,5-7,5 m/s²),
    solo sobre la componente horizontal (la gravedad y la suspensión siguen siendo de PhysX)
    y amortiguando el giro sobre el eje vertical para que el vehículo no trompee.
    Si el vehículo cambia de dueño, el servidor vuelve a enviar esta función a la nueva máquina.
*/
params ["_veh", ["_stopAt", []]];
if (!local _veh || {!alive _veh}) exitWith {};
private _old = _veh getVariable ["ADVSEC_cpBrakeEH", -1];
if (_old >= 0) then {removeMissionEventHandler ["EachFrame", _old]};
// IA al volante: que no acelere mientras dure la retención
private _d = driver _veh;
if (!isNull _d && {!isPlayer _d} && {local _d}) then {_d forceSpeed 0};
_veh setVariable ["ADVSEC_cpStopAt", _stopAt];
private _eh = addMissionEventHandler ["EachFrame", {
    _thisArgs params ["_veh"];
    if (isNull _veh || {!alive _veh} || {!local _veh} || {!(_veh getVariable ["ADVSEC_cpHold", false])}) exitWith {
        removeMissionEventHandler ["EachFrame", _thisEventHandler];
        if (!isNull _veh) then {
            _veh setVariable ["ADVSEC_cpBrakeEH", nil];
            private _d = driver _veh;
            if (!isNull _d && {!isPlayer _d} && {local _d}) then {_d forceSpeed -1};
        };
    };
    if (!isTouchingGround _veh) exitWith {};      // en el aire no se toca: lo resuelve la física
    private _dt = diag_deltaTime min 0.1;
    (velocity _veh) params ["_vx", "_vy", "_vz"];
    private _h = sqrt (_vx ^ 2 + _vy ^ 2);
    if (_h < 0.35) exitWith {if (_h > 0.05) then {_veh setVelocity [0, 0, _vz]}};
    // Distancia disponible hasta el punto de parada (si va hacia él); si no, frenada media
    private _stop = _veh getVariable ["ADVSEC_cpStopAt", []];
    private _a = 5;
    if (_stop isNotEqualTo []) then {
        private _to = (_stop vectorDiff getPosATL _veh) select [0, 2];
        private _dist = vectorMagnitude _to;
        if (_dist > 1 && {(_to vectorDotProduct [_vx, _vy]) > 0}) then {_a = ((_h ^ 2) / (2 * ((_dist - 6) max 3))) max 2.5 min 7.5};
    };
    private _k = ((_h - _a * _dt) max 0) / _h;
    _veh setVelocity [_vx * _k, _vy * _k, _vz];
    // Amortigua solo la guiñada (eje Z); cabeceo y balanceo siguen siendo de la física
    (angularVelocity _veh) params ["_ax", "_ay", "_az"];
    if (abs _az > 0.05) then {_veh setAngularVelocity [_ax, _ay, _az * 0.85]};
}, [_veh]];
_veh setVariable ["ADVSEC_cpBrakeEH", _eh];
