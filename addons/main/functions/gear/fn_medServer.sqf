/*
    [objeto médico, llamador, [paciente]] (servidor, 1.24) — usa un objeto de material médico sobre un paciente (o sobre uno mismo)
    Sin ACE cura con setDamage / setHitPointDamage; con ACE manda los eventos de ACE cuando existen.
*/
params ["_item", "_caller", ["_args", []]];
if (!isServer) exitWith {};
_args params [["_u", objNull]];
if (isNull _u || {!([_caller, _u, 5] call ADVSEC_fnc_srvCaller)}) exitWith {};
if !(_item in (items _caller)) exitWith {};
private _say = {_this remoteExecCall ["hint", _caller]};
private _ace = isClass (configFile >> "CfgPatches" >> "ace_medical_treatment") && {!isNil "CBA_fnc_targetEvent"};
private _down = lifeState _u == "INCAPACITATED" || {_u getVariable ["ACE_isUnconscious", false]};
private _dmg = damage _u;
// Constantes vitales aproximadas a partir del daño
private _pulse = round (70 + _dmg * 60 + random 8);
private _sys = round (125 - _dmg * 55 + random 6);
private _dia = round (80 - _dmg * 30 + random 4);
private _consume = true;
switch (_item) do {
    case "ADVSEC_MedBag": {
        _consume = false;
        if (_ace) then {["ace_medical_treatment_fullHealLocal", [_u], _u] call CBA_fnc_targetEvent} else {_u setDamage 0};
        (format [("STR_ADVSEC_med_bag_done" call ADVSEC_fnc_L), name _u]) call _say;
    };
    case "ADVSEC_Stethoscope": {
        _consume = false;
        (format [("STR_ADVSEC_med_pulse" call ADVSEC_fnc_L), name _u, [_pulse, 0] select !alive _u, ["STR_ADVSEC_med_breath_ok", "STR_ADVSEC_med_breath_bad"] select (_down || {_dmg > 0.6}) call ADVSEC_fnc_L]) call _say;
    };
    case "ADVSEC_BPCuff": {
        _consume = false;
        (format [("STR_ADVSEC_med_bp" call ADVSEC_fnc_L), name _u, _sys, _dia]) call _say;
    };
    case "ADVSEC_TriageTag": {
        localNamespace setVariable ["ADVSEC_medOK", true];
        ["triage", _caller, [_u]] call ADVSEC_fnc_hospServer;
    };
    case "ADVSEC_Ammonia": {
        if (!_down) exitWith {_consume = false; ("STR_ADVSEC_med_awake" call ADVSEC_fnc_L) call _say};
        if (_ace) then {["ace_medical_WakeUp", [_u], _u] call CBA_fnc_targetEvent} else {[_u, false] remoteExecCall ["setUnconscious", _u]};
        (format [("STR_ADVSEC_med_wake" call ADVSEC_fnc_L), name _u]) call _say;
    };
    case "ADVSEC_Splint": {
        [_u, ["HitLegs", 0]] remoteExecCall ["setHitPointDamage", _u];
        [_u, ["HitHands", 0]] remoteExecCall ["setHitPointDamage", _u];
        (format [("STR_ADVSEC_med_splint" call ADVSEC_fnc_L), name _u]) call _say;
    };
    case "ADVSEC_BurnDressing": {
        _u setDamage ((_dmg - 0.2) max 0);
        (format [("STR_ADVSEC_med_burn" call ADVSEC_fnc_L), name _u]) call _say;
    };
    case "ADVSEC_Albumin": {
        [_u] spawn {params ["_u"]; for "_i" from 1 to 10 do {sleep 1; _u setDamage (((damage _u) - 0.04) max 0)}};
        (format [("STR_ADVSEC_med_albumin" call ADVSEC_fnc_L), name _u]) call _say;
    };
    case "ADVSEC_Morphine": {
        [_u, 0] remoteExecCall ["setFatigue", _u];
        if (_ace) then {["ace_medical_treatment_medicationLocal", [_u, "body", "Morphine"], _u] call CBA_fnc_targetEvent};
        _u setVariable ["ADVSEC_morphine", call ADVSEC_fnc_now, true];
        (format [("STR_ADVSEC_med_morphine" call ADVSEC_fnc_L), name _u]) call _say;
    };
    default {_consume = false};
};
if (_consume) then {_caller removeItem _item};
["medical", _caller, [_item, name _u]] call ADVSEC_fnc_logEvent;
