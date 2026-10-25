// [especialidad] — PDA genérica de una metopa (lista, solicitudes, altas y bajas; parametrizada por especialidad)
params ["_sp"];
ADVSEC_specCur = _sp;
private _send = {params ["_act", "_d"]; [_act, player, [ADVSEC_specCur, _d]] remoteExecCall ["ADVSEC_fnc_specServer", 2]};
ADVSEC_specSend = _send;
["spec_" + _sp, format ["PDA · %1", [_sp] call ADVSEC_fnc_specName], [
    ["Aceptar", {params ["_d"]; if (!isNil "_d" && {(_d select 0) == "app"}) then {["accept", _d select 1] call ADVSEC_specSend}}],
    ["Rechazar / baja", {params ["_d"]; if (!isNil "_d") then {[["remove", "reject"] select ((_d select 0) == "app"), _d select 1] call ADVSEC_specSend}}],
    ["Añadir jugador", {["ALTA EN LA ESPECIALIDAD", [["Jugador", objNull, "players"]], {params ["_v"]; ["add", _v select 0] call ADVSEC_specSend}] call ADVSEC_fnc_zeusPrompt}],
    ["Encargado sí / no", {params ["_d"]; if (!isNil "_d" && {(_d select 0) == "mem"}) then {["lead", _d select 1] call ADVSEC_specSend}}],
    ["Volver", {closeDialog 0; [] spawn {sleep 0.1; [] call ADVSEC_fnc_specOpen}}]
], {["view", player, [ADVSEC_specCur]] remoteExecCall ["ADVSEC_fnc_specServer", 2]}] call ADVSEC_fnc_panelOpen;
