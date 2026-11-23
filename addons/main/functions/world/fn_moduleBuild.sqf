// Módulo Eden "Construir instalación" (1.24): base, comisaría, prisión, hospital, base fluvial o tienda, ya configuradas
params ["_logic", "", ["_activated", true]];
if (!_activated || {!isServer}) exitWith {};
private _t = ["base", "station", "stockade", "hospital", "river", "shop"] param [_logic getVariable ["Kind", 0], "base"];
[_t, _logic] call ADVSEC_fnc_buildServer;
