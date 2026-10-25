// [ruta (string o array), porDefecto] -> valor de ADVSEC_Settings. Prioridad: CBA > misión (description.ext) > addon
params ["_path", "_default"];
if (_path isEqualType "") then {_path = [_path]};
// Opciones de complementos de CBA (si el ajuste está registrado allí)
private _cba = missionNamespace getVariable ("ADVSEC_cba_" + (_path joinString "_"));
// Las casillas de CBA dan Bool: se pasan a 0/1. (No usar [a, parseNumber a] select ...: SQF evalúa todo el array y parseNumber falla con números.)
if (!isNil "_cba") exitWith {if (_cba isEqualType true) then {parseNumber _cba} else {_cba}};
private _get = {
    params ["_root"];
    private _c = _root >> "ADVSEC_Settings";
    {_c = _c >> _x} forEach _path;
    _c
};
private _c = [missionConfigFile] call _get;
if (isNull _c) then {_c = [configFile] call _get};
if (isNull _c) exitWith {_default};
switch (true) do {
    case (isArray _c): {getArray _c};
    case (isNumber _c): {getNumber _c};
    case (isText _c): {getText _c};
    default {_default};
}
