/*
    ["set", llamador, [nivel]] (servidor) — nivel de alerta de la base: 0 verde · 1 amarillo · 2 rojo
    Amarillo: arma todas las alarmas. Rojo: además cierra todas las puertas controladas y los keypads exigen documento (alertRedIdTypes).
    Al bajar de rojo se reabren solo las puertas que cerró la alerta. THUD: tierWar = 1 / 5 / 10 (línea de nivel de guerra).
*/
params ["_action", "_caller", ["_args", []]];
if (!isServer) exitWith {};
if (_action != "set") exitWith {};
if (!isNull _caller && {!([_caller] call ADVSEC_fnc_srvCaller)}) exitWith {};
if (!isNull _caller && {!([_caller, "alertLevel"] call ADVSEC_fnc_perm)}) exitWith {[_caller, ("STR_ADVSEC_change_the_alert_level" call ADVSEC_fnc_L)] call ADVSEC_fnc_deny};
private _lvl = ((_args param [0, 0]) max 0) min 2;
private _old = missionNamespace getVariable ["ADVSEC_alertLevel", 0];
ADVSEC_alertLevel = _lvl;
publicVariable "ADVSEC_alertLevel";
private _reg = missionNamespace getVariable ["ADVSEC_secObjects", []];
if (_lvl >= 1) then {
    {if ((_x select 1) == "alarm") then {[_x select 0, "arm", ("STR_ADVSEC_alert_level" call ADVSEC_fnc_L)] call ADVSEC_fnc_alarmSet}} forEach _reg;
};
private _locked = localNamespace getVariable ["ADVSEC_alertLocked", []];
if (_lvl == 2 && {_old < 2}) then {
    _locked = [];
    {
        if ((_x select 1) == "door") then {
            private _b = _x select 0;
            {
                if !(_b getVariable [format ["ADVSEC_locked_%1", _x], false]) then {_locked pushBack [_b, _x]};
                [_b, _x, true] call ADVSEC_fnc_doorSet;
            } forEach ((_x select 3) select {_x isEqualType 0});
        };
    } forEach _reg;
    localNamespace setVariable ["ADVSEC_alertLocked", _locked];
};
if (_lvl < 2 && {_old == 2}) then {
    {_x params ["_b", "_i"]; if (!isNull _b) then {[_b, _i, false] call ADVSEC_fnc_doorSet}} forEach _locked;
    localNamespace setVariable ["ADVSEC_alertLocked", []];
};
if !([] call ADVSEC_fnc_ecoA3A) then {tierWar = [1, 5, 10] select _lvl; publicVariable "tierWar"};
private _txt = [("STR_ADVSEC_green_normal_2" call ADVSEC_fnc_L), ("STR_ADVSEC_yellow_alarms_armed_2" call ADVSEC_fnc_L), ("STR_ADVSEC_red_base_locked_down_id" call ADVSEC_fnc_L)] select _lvl;
(format [("STR_ADVSEC_alert_level_2" call ADVSEC_fnc_L), _txt]) remoteExecCall ["systemChat", 0];
[format [("STR_ADVSEC_alert" call ADVSEC_fnc_L), ["#66FF66", "#FFD24D", "#FF4D4D"] select _lvl, _txt]] remoteExecCall ["ADVSEC_fnc_alertHint", 0];
["alertLevel", _caller, [_lvl]] call ADVSEC_fnc_logEvent;
