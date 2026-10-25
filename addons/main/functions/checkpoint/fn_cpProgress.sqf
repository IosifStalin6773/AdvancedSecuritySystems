// [título, segundos, vehículo] — cliente: barra de progreso mientras el agente revisa documentación y vehículo
params ["_title", "_secs", "_veh"];
[_title, _secs, {(_this select 0) getVariable ["ADVSEC_cpHold", false]}, {}, [_veh]] call ADVSEC_fnc_progress;
