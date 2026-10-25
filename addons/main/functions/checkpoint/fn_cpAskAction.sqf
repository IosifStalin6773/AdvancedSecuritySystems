// ["show"|"refuse"] — respuesta del jugador al agente del control
params ["_a"];
ADVSEC_cpAnswered = true;
closeDialog 0;
if (isNil "ADVSEC_cpAskVeh") exitWith {};
[_a, player, ADVSEC_cpAskVeh] remoteExecCall ["ADVSEC_fnc_cpServer", 2];
if (_a == "show") then {player playActionNow "gestureNod"};
