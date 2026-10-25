// [unidad (opcional)] — consulta a la base de datos central desde la PDA (requiere radio)
params [["_unit", objNull]];
if !([player] call ADVSEC_fnc_hasRadio) exitWith {hint "Sin enlace con la central: necesitas una radio."};
private _go = {
    params ["_u", "_text"];
    ADVSEC_queryArgs = [_u, _text];
    ["query", "Central · consulta de antecedentes", [
        ["Ver multas", {params ["_d"]; if (!isNil "_d" && {_d isEqualType []} && {(_d select 0) == "K"}) then {[_d select 1, _d select 2] call ADVSEC_fnc_fineOpen}}],
        ["Nueva consulta", {closeDialog 0; [] spawn {sleep 0.1; [] call ADVSEC_fnc_queryOpen}}]
    ], {["query", player, ADVSEC_queryArgs] remoteExecCall ["ADVSEC_fnc_queryServer", 2]}] call ADVSEC_fnc_panelOpen;
};
if (!isNull _unit) exitWith {[_unit, ""] call _go};
["CONSULTA A LA CENTRAL", [
    ["Persona presente", objNull, "players"],
    ["…o nombre / SteamID", ""]
], {
    params ["_v", "_go"];
    _v params ["_u", "_text"];
    if (_text isNotEqualTo "") then {_u = objNull};
    if (isNull _u && {_text isEqualTo ""}) exitWith {hint "Indica una persona."};
    [_u, _text] call _go;
}, _go] call ADVSEC_fnc_zeusPrompt;
