// Módulo Eden "Vida en base / pueblo" (1.24): personal y civiles de ambiente alrededor del módulo
params ["_logic", "", ["_activated", true]];
if (!_activated || {!isServer}) exitWith {};
[getPosATL _logic, _logic getVariable ["Kind", 0], _logic getVariable ["Count", 8], _logic getVariable ["Radius", 80]] spawn ADVSEC_fnc_lifeServer;
