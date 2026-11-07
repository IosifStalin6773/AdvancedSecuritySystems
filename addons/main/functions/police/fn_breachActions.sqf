// [edificio, [índices]] — forzar cerradura (kit de herramientas) y asegurar puerta (PM), en cada cliente
params ["_b", "_doors"];
if (!hasInterface || {isNull _b}) exitWith {};
{
    private _flag = format ["ADVSEC_breachAct_%1", _x];
    if (isNil {_b getVariable _flag}) then {
        _b setVariable [_flag, true];
        [_b, format ["advsec_breach_%1", _x], ("STR_ADVSEC_pick_lock" call ADVSEC_fnc_L), ADVSEC_icKey,
            {_args params ["_i"]; [_target, _i] spawn ADVSEC_fnc_breach},
            {_args params ["_i"]; (_target getVariable [format ["ADVSEC_locked_%1", _i], false]) && {((["breachItem", "ToolKit"] call ADVSEC_fnc_cfg)) in items _player}},
            "root", [_x], 2.5, format ["Door_%1_trigger", _x]
        ] call ADVSEC_fnc_addInteraction;
        [_b, format ["advsec_secure_%1", _x], ("STR_ADVSEC_secure_door_mp" call ADVSEC_fnc_L), ADVSEC_icPol,
            {_args params ["_i"]; [_target, _i, true] call ADVSEC_fnc_doorSet; hint ("STR_ADVSEC_door_secured" call ADVSEC_fnc_L)},
            {_args params ["_i"]; !(_target getVariable [format ["ADVSEC_locked_%1", _i], false]) && {[_player, "PM"] call ADVSEC_fnc_repAccess}},
            "root", [_x], 2.5, format ["Door_%1_trigger", _x]
        ] call ADVSEC_fnc_addInteraction;
    };
} forEach _doors;
