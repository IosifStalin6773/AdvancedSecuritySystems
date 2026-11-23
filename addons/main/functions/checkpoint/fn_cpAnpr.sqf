/*
    [vehículo, nombre del control] (servidor) — lectura automática de matrícula al entrar en el control.
    Marca en el vehículo (ADVSEC_cpFlags) lo que el agente aplicará al revisar la documentación:
    ["stolen"] vehículo denunciado · ["wantedOwner", nombre] titular en busca y captura · ["itv"] ITV caducada.
*/
params ["_veh", "_name"];
if ((["checkpointANPR", 1] call ADVSEC_fnc_setting) isEqualTo 0) exitWith {};
private _plate = _veh getVariable ["ADVSEC_plate", getPlateNumber _veh];
if (_plate isEqualTo "") exitWith {};
private _flags = [];
private _rec = ([] call ADVSEC_fnc_plateDB) getOrDefault [_plate, []];
if (_rec param [4, false]) then {_flags pushBack ["stolen"]};
private _owner = _rec param [1, ""];
if (isNil "ADVSEC_wantedDB") then {[] call ADVSEC_fnc_policeDBLoad};
if (_owner isNotEqualTo "" && {_owner in ADVSEC_wantedDB}) then {_flags pushBack ["wantedOwner", (ADVSEC_wantedDB get _owner) param [0, ""]]};
if (([_plate] call ADVSEC_fnc_itvState) select 0 == 2) then {_flags pushBack ["itv"]};
_veh setVariable ["ADVSEC_cpFlags", _flags];
if (_flags isNotEqualTo []) then {
    private _txt = format [("STR_ADVSEC_m_anpr_hit" call ADVSEC_fnc_L), _name, _plate, (_flags apply {
        switch (_x select 0) do {
            case "stolen": {("STR_ADVSEC_m_anpr_stolen" call ADVSEC_fnc_L)};
            case "wantedOwner": {format [("STR_ADVSEC_m_anpr_wanted" call ADVSEC_fnc_L), _x param [1, ""]]};
            default {("STR_ADVSEC_m_anpr_itv" call ADVSEC_fnc_L)};
        }
    }) joinString " · "];
    {if ([_x, "PMC"] call ADVSEC_fnc_repAccess) then {_txt remoteExecCall ["hintSilent", _x]}} forEach (allPlayers - entities "HeadlessClient_F");
    ["anpr", objNull, [_name, _plate, _flags apply {_x select 0}]] call ADVSEC_fnc_logEvent;
};
