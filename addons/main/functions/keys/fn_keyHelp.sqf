// Panel con todas las teclas del mod (las actuales, incluidas las cambiadas en CBA)
["keys", ("STR_ADVSEC_advanced_security_systems_keys" call ADVSEC_fnc_L), [
    [("STR_ADVSEC_close" call ADVSEC_fnc_L), {closeDialog 0}]
], {
    private _rows = [];
    private _cat = "";
    {
        _x params ["_id", "_name", "_tip", "_c"];
        if (_c != _cat) then {_cat = _c; _rows pushBack [toUpper _c, [], "", [0.816, 0.639, 0.188, 1], ""]};
        private _k = [_id] call ADVSEC_fnc_keyCurrent;
        _rows pushBack [format ["    %1   ·   %2", _k call ADVSEC_fnc_keyName, _name], _id, format [("STR_ADVSEC_key_2" call ADVSEC_fnc_L), _name, _tip, _k call ADVSEC_fnc_keyName], [], ""];
    } forEach ([] call ADVSEC_fnc_keyList);
    ["keys", [("STR_ADVSEC_change_the_keys_in_options" call ADVSEC_fnc_L), ("STR_ADVSEC_without_cba_keys_are_changed" call ADVSEC_fnc_L)] select !(isClass (configFile >> "CfgPatches" >> "cba_keybinding")), _rows] call ADVSEC_fnc_panelSet;
}] call ADVSEC_fnc_panelOpen;
