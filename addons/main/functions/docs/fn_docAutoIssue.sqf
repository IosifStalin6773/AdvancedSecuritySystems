// [unidad, forzar] (servidor): ID militar ligado al SteamID + credenciales PM/AA.II. por lista de SteamID
params ["_unit", ["_force", false]];
if (!isServer) exitWith {["autoissue", player, [_unit, _force]] remoteExecCall ["ADVSEC_fnc_docServer", 2]};
if (isNull _unit) exitWith {};
private _uid = getPlayerUID _unit;
if (_uid isEqualTo "") exitWith {};
private _short = _uid select [(count _uid - 8) max 0];

if (_force || {((["autoMilitaryID", 1] call ADVSEC_fnc_cfg)) isEqualTo 1}) then {
    [_unit, "MilitaryID", [
        ["name", name _unit],
        ["rank", [_unit] call ADVSEC_fnc_rankName],
        ["unit", groupId group _unit],
        ["uid", _uid],
        ["number", "MIL-" + _short],
        ["issuer", (["militaryIssuer", "Estado Mayor"] call ADVSEC_fnc_cfg)],
        ["clearance", (["militaryClearance", 1] call ADVSEC_fnc_cfg)]
    ], true, true, true] call ADVSEC_fnc_docCreate;
};

{
    _x params ["_list", "_type", "_prefix"];
    // Entradas: "SteamID" o ["SteamID", rango 1-5]
    private _e = (getMissionConfigValue [_list, []]) select {(_x isEqualTo _uid) || {_x isEqualType [] && {(_x param [0, ""]) isEqualTo _uid}}};
    if (_e isNotEqualTo []) then {
        private _lvl = [1, (_e select 0) param [1, 1]] select ((_e select 0) isEqualType []);
        [_unit, _type, [["name", name _unit], ["uid", _uid], ["number", _prefix + _short], ["clearance", _lvl], ["issuer", "Estado Mayor"]], true, true, true] call ADVSEC_fnc_docCreate;
    };
} forEach [["ADVSEC_pmUIDs", "MPBadge", "PM-"], ["ADVSEC_iaUIDs", "IABadge", "AI-"]];
// La base de datos de jugadores manda sobre las listas de la misión
[_unit] call ADVSEC_fnc_pdbApply;
[_unit] call ADVSEC_fnc_specApply;
