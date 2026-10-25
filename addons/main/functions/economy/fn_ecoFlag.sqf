/*
    [de [uid, nombre], a [uid, nombre], importe, tipo, forzar] (servidor)
    Apunta un movimiento sospechoso para AA.II. si interviene un agente PM/AA.II. y supera suspiciousAmount (o si forzar).
    Al agente le suma sospecha: regla "bribe" si es soborno, "suspiciousMoney" si no.
*/
params ["_from", "_to", "_amt", "_kind", ["_force", false]];
private _agent = {
    params ["_uid"];
    private _u = [_uid] call ADVSEC_fnc_uidUnit;
    !isNull _u && {([_u, "PM"] call ADVSEC_fnc_rankLevel) > 0 || {([_u, "AI"] call ADVSEC_fnc_rankLevel) > 0}}
};
private _agents = [_from, _to] select {[_x select 0] call _agent};
if (!_force && {_agents isEqualTo [] || {_amt < (["suspiciousAmount", 2000] call ADVSEC_fnc_setting)}}) exitWith {};
[] call ADVSEC_fnc_ecoDB;
private _l = localNamespace getVariable ["ADVSEC_ecoFlags", []];
_l pushBack [call ADVSEC_fnc_now, _from select 0, _from select 1, _to select 0, _to select 1, _amt, _kind];
if (count _l > 200) then {_l deleteRange [0, count _l - 200]};
localNamespace setVariable ["ADVSEC_ecoFlags", _l];
["eco"] call ADVSEC_fnc_dbDirty;
{[_x, ["suspiciousMoney", "bribe"] select (_kind == "Soborno"), format ["%1 de %2 %3 (%4 → %5)", _kind, _amt, ["currency", "€"] call ADVSEC_fnc_setting, _from select 1, _to select 1]] call ADVSEC_fnc_heatAdd} forEach _agents;
