// [edificio, [índices]] — forzar cerradura (kit de herramientas) y asegurar puerta (PM), en cada cliente
params ["_b", "_doors"];
if (!hasInterface || {isNull _b}) exitWith {};
{
    private _flag = format ["ADVSEC_breachAct_%1", _x];
    if (isNil {_b getVariable _flag}) then {
        _b setVariable [_flag, true];
        [_b, format ["advsec_breach_%1", _x], "Forzar cerradura", ADVSEC_icKey,
            {_args params ["_i"]; [_target, _i] spawn ADVSEC_fnc_breach},
            {_args params ["_i"]; (_target getVariable [format ["ADVSEC_locked_%1", _i], false]) && {((["breachItem", "ToolKit"] call ADVSEC_fnc_cfg)) in items _player}},
            "root", [_x], 2.5, format ["Door_%1_trigger", _x]
        ] call ADVSEC_fnc_addInteraction;
        [_b, format ["advsec_secure_%1", _x], "Asegurar puerta (PM)", ADVSEC_icPol,
            {_args params ["_i"]; [_target, _i, true] call ADVSEC_fnc_doorSet; hint "Puerta asegurada."},
            {_args params ["_i"]; !(_target getVariable [format ["ADVSEC_locked_%1", _i], false]) && {[_player, "PM"] call ADVSEC_fnc_repAccess}},
            "root", [_x], 2.5, format ["Door_%1_trigger", _x]
        ] call ADVSEC_fnc_addInteraction;
    };
} forEach _doors;
