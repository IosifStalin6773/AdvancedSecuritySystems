if (isNil "ADVSEC_zeusPromptData") exitWith {closeDialog 0};
ADVSEC_zeusPromptData params ["_code", "_args", "_ctrls"];
private _values = _ctrls apply {
    _x params ["_c", "_kind", "_vals", "_default"];
    switch (_kind) do {
        case "combo": {_vals param [lbCurSel _c, _default]};
        case "multi": {(lbSelection _c) apply {_vals select _x}};
        default {ctrlText _c};
    }
};
ADVSEC_zeusPromptData = nil;
closeDialog 0;
[_values, _args] call _code;
