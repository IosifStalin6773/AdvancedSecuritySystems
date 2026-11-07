// [unidad (opcional)] — consulta a la base de datos central desde la PDA (requiere radio)
params [["_unit", objNull]];
if !([player] call ADVSEC_fnc_hasRadio) exitWith {hint ("STR_ADVSEC_no_link_to_dispatch_you" call ADVSEC_fnc_L)};
private _go = {
    params ["_u", "_text"];
    ADVSEC_queryArgs = [_u, _text];
    ["query", ("STR_ADVSEC_dispatch_background_check" call ADVSEC_fnc_L), [
        [("STR_ADVSEC_view_fines" call ADVSEC_fnc_L), {params ["_d"]; if (!isNil "_d" && {_d isEqualType []} && {(_d select 0) == "K"}) then {[_d select 1, _d select 2] call ADVSEC_fnc_fineOpen}}],
        [("STR_ADVSEC_new_query" call ADVSEC_fnc_L), {closeDialog 0; [] spawn {sleep 0.1; [] call ADVSEC_fnc_queryOpen}}]
    ], {["query", player, ADVSEC_queryArgs] remoteExecCall ["ADVSEC_fnc_queryServer", 2]}] call ADVSEC_fnc_panelOpen;
};
if (!isNull _unit) exitWith {[_unit, ""] call _go};
[("STR_ADVSEC_query_dispatch" call ADVSEC_fnc_L), [
    [("STR_ADVSEC_person_present" call ADVSEC_fnc_L), objNull, "players"],
    [("STR_ADVSEC_or_name_steamid" call ADVSEC_fnc_L), ""]
], {
    params ["_v", "_go"];
    _v params ["_u", "_text"];
    if (_text isNotEqualTo "") then {_u = objNull};
    if (isNull _u && {_text isEqualTo ""}) exitWith {hint ("STR_ADVSEC_specify_a_person" call ADVSEC_fnc_L)};
    [_u, _text] call _go;
}, _go] call ADVSEC_fnc_zeusPrompt;
