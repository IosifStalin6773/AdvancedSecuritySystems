params ["_unit"];
private _jails = (missionNamespace getVariable ["ADVSEC_jails", []]) select {!isNull _x};
if (_jails isEqualTo []) exitWith {hint "No hay ningún centro de detención (módulo Calabozo)."};
_jails = [_jails, [], {_x distance _unit}, "ASCEND"] call BIS_fnc_sortBy;
[format ["ARRESTO · %1", name _unit], [
    ["Tiempo", 10, [["5 minutos", 5], ["10 minutos", 10], ["15 minutos", 15], ["30 minutos", 30], ["1 hora", 60], ["2 horas", 120], ["Hasta nueva orden", -1]]],
    ["Motivo", ""],
    ["Centro", _jails select 0, _jails apply {[format ["%1 · %2 m", _x getVariable ["ADVSEC_jailName", "Calabozo"], round (_x distance _unit)], _x]}],
    ["Generar acta F-PM-04", true, "bool"]
], {
    params ["_v", "_unit"];
    ["jail", player, [_unit, _v#0, _v#1, _v#2, _v#3]] remoteExecCall ["ADVSEC_fnc_jailServer", 2];
}, _unit] call ADVSEC_fnc_zeusPrompt;
