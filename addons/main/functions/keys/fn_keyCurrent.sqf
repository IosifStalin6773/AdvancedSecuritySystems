// [id] -> [DIK, shift, ctrl, alt] asignado ahora (CBA si está cargado)
params ["_id"];
private _def = (([] call ADVSEC_fnc_keyList) select {(_x select 0) == _id}) param [0, []];
if (_def isEqualTo []) exitWith {[0, false, false, false]};
if (isClass (configFile >> "CfgPatches" >> "cba_keybinding")) then {
    private _kb = ["Advanced Security Systems", "advsec_" + _id] call CBA_fnc_getKeybind;
    if (!isNil "_kb") then {
        (_kb param [5, []]) params [["_k", 0], ["_m", [false, false, false]]];
        _m params [["_s", false], ["_c", false], ["_a", false]];
        _def set [4, [_k, _s, _c, _a]];
    };
};
_def select 4
