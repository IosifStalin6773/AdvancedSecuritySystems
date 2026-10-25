params [["_unit", objNull]];
["DECLARAR BUSCADO", [
    ["Persona", _unit, "players"],
    ["Motivo", ""],
    ["Peligrosidad", "Media", ["Baja", "Media", "Alta", "Extrema"]]
], {
    params ["_v"];
    _v params ["_u", "_reason", "_level"];
    if (isNull _u) exitWith {hint "Selecciona una persona."};
    ["add", player, [getPlayerUID _u, name _u, _reason, _level]] remoteExecCall ["ADVSEC_fnc_wantedServer", 2];
}] call ADVSEC_fnc_zeusPrompt;
