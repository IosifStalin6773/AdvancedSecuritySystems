// Cliente: registra las teclas del mod (CBA si está cargado; si no, un manejador KeyDown propio)
if (!hasInterface) exitWith {};
ADVSEC_keys = [] call ADVSEC_fnc_keyList;
if (isClass (configFile >> "CfgPatches" >> "cba_keybinding")) exitWith {
    {
        _x params ["_id", "_name", "_tip", "_cat", "_key"];
        _key params ["_k", "_s", "_c", "_a"];
        ["Advanced Security Systems", "advsec_" + _id, [_name, format ["%1 · %2", _cat, _tip]],
            compile format ["['%1'] call ADVSEC_fnc_keyAction", _id], "", [_k, [_s, _c, _a]]
        ] call CBA_fnc_addKeybind;
    } forEach ADVSEC_keys;
};
[] spawn {
    waitUntil {!isNull findDisplay 46};
    (findDisplay 46) displayAddEventHandler ["KeyDown", {
        params ["", "_k", "_s", "_c", "_a"];
        private _i = ADVSEC_keys findIf {((_x select 4) select 0) == _k && {((_x select 4) select 1) isEqualTo _s} && {((_x select 4) select 2) isEqualTo _c} && {((_x select 4) select 3) isEqualTo _a}};
        if (_i < 0) exitWith {false};
        [(ADVSEC_keys select _i) select 0] call ADVSEC_fnc_keyAction
    }];
};
