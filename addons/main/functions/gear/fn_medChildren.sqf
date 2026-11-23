// [paciente, agente] -> acciones de material médico que lleva el agente (menú sobre el paciente o sobre uno mismo, 1.24)
params ["_u", "_p"];
private _its = items _p;
private _out = [];
{
    _x params ["_c", "_need"];
    if (_c in _its && {_need isEqualTo 0 || {_need isEqualTo 1 && {damage _u > 0 || {lifeState _u == "INCAPACITATED"}}}}) then {
        _out pushBack [format ["advsec_med_%1", _c], format ["%1", getText (configFile >> "CfgWeapons" >> _c >> "displayName")], ADVSEC_icAlarm,
            compile format ['["%1", _player, [_target]] remoteExecCall ["ADVSEC_fnc_medServer", 2]', _c], []];
    };
} forEach [["ADVSEC_Stethoscope", 0], ["ADVSEC_BPCuff", 0], ["ADVSEC_TriageTag", 0], ["ADVSEC_MedBag", 1], ["ADVSEC_Ammonia", 1], ["ADVSEC_Splint", 1], ["ADVSEC_BurnDressing", 1], ["ADVSEC_Albumin", 1], ["ADVSEC_Morphine", 0]];
if ("ADVSEC_Litter" in _its && {_u != _p} && {lifeState _u == "INCAPACITATED" || {_u getVariable ["ACE_isUnconscious", false]} || {(attachedTo _u) isEqualTo _p}}) then {
    _out pushBack ["advsec_med_litter", ["STR_ADVSEC_med_litter_on", "STR_ADVSEC_med_litter_off"] select ((attachedTo _u) isEqualTo _p) call ADVSEC_fnc_L, ADVSEC_icRun, {[_target] call ADVSEC_fnc_medLitter}, []];
};
_out
