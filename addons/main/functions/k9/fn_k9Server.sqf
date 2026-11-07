/*
    [acción, llamador, args] (servidor) — unidad canina
    "toggle" (llamar / retirar perro) · "sniff" [objetivo] (vehículo: doble fondo · persona: objetos escondidos)
*/
params ["_action", "_caller", ["_args", []]];
if (!isServer) exitWith {};
if !([_caller] call ADVSEC_fnc_srvCaller) exitWith {};
if !([_caller, "k9"] call ADVSEC_fnc_perm) exitWith {[_caller, ("STR_ADVSEC_use_the_k9_unit" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
private _say = {_this remoteExecCall ["hint", _caller]};
private _dog = _caller getVariable ["ADVSEC_k9", objNull];
switch (_action) do {
    case "toggle": {
        if (!isNull _dog) exitWith {deleteVehicle _dog; _caller setVariable ["ADVSEC_k9", objNull, true]; ("STR_ADVSEC_dog_dismissed" call ADVSEC_fnc_L) call _say};
        _dog = createAgent [["k9Class", "Alsatian_Random_F"] call ADVSEC_fnc_setting, _caller getPos [2, getDir _caller], [], 0, "NONE"];
        _dog setVariable ["BIS_fnc_animalBehaviour_disable", true];
        _dog allowDamage false;
        _caller setVariable ["ADVSEC_k9", _dog, true];
        ("STR_ADVSEC_dog_at_your_side_use" call ADVSEC_fnc_L) call _say;
        // Sigue al guía mientras ambos existan
        [_caller, _dog] spawn {
            params ["_h", "_d"];
            while {alive _d && {!isNull _h} && {(_h getVariable ["ADVSEC_k9", objNull]) isEqualTo _d}} do {
                if (_d getVariable ["ADVSEC_k9Busy", false]) then {sleep 1; continue};
                private _dist = _d distance _h;
                if (_dist > 60) then {_d setPosATL (_h getPos [2, random 360]); _dist = 2};
                if (_dist > 4) then {_d moveTo (_h getPos [2, getDir _h + 180]); _d playMove (["Dog_Run", "Dog_Sprint"] select (_dist > 15))} else {_d playMove "Dog_Stop"};
                sleep 1;
            };
            if (!isNull _d && {!alive _h || {isNull _h}}) then {deleteVehicle _d};
        };
    };
    case "sniff": {
        _args params [["_t", objNull]];
        if (isNull _dog) exitWith {("STR_ADVSEC_call_the_dog_first" call ADVSEC_fnc_L) call _say};
        if (isNull _t || {(_t distance _caller) > 8}) exitWith {("STR_ADVSEC_get_closer_to_the_target" call ADVSEC_fnc_L) call _say};
        if (_dog getVariable ["ADVSEC_k9Busy", false]) exitWith {};
        _dog setVariable ["ADVSEC_k9Busy", true];
        ("STR_ADVSEC_the_dog_is_sniffing" call ADVSEC_fnc_L) call _say;
        [_caller, _dog, _t] spawn {
            params ["_h", "_d", "_t"];
            _d moveTo (getPosATL _t);
            _d playMove "Dog_Walk";
            sleep 6;
            _d setVariable ["ADVSEC_k9Busy", false];
            private _p = ["k9FindChance", 0.9] call ADVSEC_fnc_setting;
            private _hit = 0;
            if (_t isKindOf "AllVehicles" && {!(_t isKindOf "CAManBase")}) then {
                {if (random 1 < _p) then {_x set [3, true]; _hit = _hit + 1}} forEach (_t getVariable ["ADVSEC_stash", []]);
            } else {
                _hit = {random 1 < _p} count (_t getVariable ["ADVSEC_hidden", []]);
                if (_hit > 0) then {_t setVariable ["ADVSEC_k9Mark", serverTime + 300, true]};
            };
            ["k9", _h, [typeOf _t, _hit]] call ADVSEC_fnc_logEvent;
            ([("STR_ADVSEC_the_dog_does_not_alert" call ADVSEC_fnc_L), format [("STR_ADVSEC_the_dog_alerts_indication_s" call ADVSEC_fnc_L), _hit]] select (_hit > 0)) remoteExecCall ["hint", _h];
        };
    };
};
