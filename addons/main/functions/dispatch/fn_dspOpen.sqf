// Central de despacho (PM): avisos 112 y pánicos
if !([player, "PM"] call ADVSEC_fnc_repAccess) exitWith {hint "Solo la Policía Militar accede a la central."};
["dispatch", "Central de despacho", [
    ["Aceptar aviso", {params ["_id"]; if (!isNil "_id") then {["accept", player, [_id]] remoteExecCall ["ADVSEC_fnc_dspServer", 2]}}],
    ["Cerrar aviso", {params ["_id"]; if (!isNil "_id") then {["close", player, [_id]] remoteExecCall ["ADVSEC_fnc_dspServer", 2]}}],
    ["Fichar entrada / salida", {["toggle", player] remoteExecCall ["ADVSEC_fnc_dutyServer", 2]}],
    ["Agentes de servicio", {closeDialog 0; [] spawn {sleep 0.1; [] call ADVSEC_fnc_dutyOpen}}],
    ["Actualizar", {["refresh"] call ADVSEC_fnc_panelAction}]
], {["list", player] remoteExecCall ["ADVSEC_fnc_dspServer", 2]}] call ADVSEC_fnc_panelOpen;
