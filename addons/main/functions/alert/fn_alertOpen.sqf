// Cambiar el nivel de alerta de la base (permiso alertLevel)
if !([player, "alertLevel"] call ADVSEC_fnc_perm) exitWith {hint "Tu rango no permite cambiar el nivel de alerta."};
["NIVEL DE ALERTA DE LA BASE", [["Nivel", missionNamespace getVariable ["ADVSEC_alertLevel", 0], [["Verde · normalidad", 0], ["Amarillo · alarmas armadas", 1], ["Rojo · puertas cerradas e identificación", 2]]]], {
    params ["_v"];
    ["set", player, [_v select 0]] remoteExecCall ["ADVSEC_fnc_alertServer", 2];
}] call ADVSEC_fnc_zeusPrompt;
