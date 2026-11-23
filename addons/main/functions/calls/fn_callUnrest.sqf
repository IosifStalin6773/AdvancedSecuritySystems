// [cambio, motivo] (servidor, 1.24): tensión social 0-100. Sube con avisos fallidos y civiles muertos; baja con avisos resueltos.
params ["_d", ["_why", ""]];
if (!isServer) exitWith {};
private _v = (((missionNamespace getVariable ["ADVSEC_unrest", 0]) + _d) max 0) min 100;
private _old = missionNamespace getVariable ["ADVSEC_unrest", 0];
missionNamespace setVariable ["ADVSEC_unrest", _v, true];
// Avisa a la PM al cruzar 25/50/75
{
    if ((_old < _x && {_v >= _x}) || {_old >= _x && {_v < _x}}) exitWith {
        private _pm = (allPlayers - entities "HeadlessClient_F") select {[_x, "PMC"] call ADVSEC_fnc_repAccess};
        (format [("STR_ADVSEC_call_unrest_now" call ADVSEC_fnc_L), round _v, _why]) remoteExecCall ["systemChat", _pm];
    };
} forEach [25, 50, 75];
_v
