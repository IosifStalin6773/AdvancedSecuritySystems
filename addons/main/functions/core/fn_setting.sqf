// [ruta (string o array), porDefecto] -> valor de ADVSEC_Settings. Prioridad: CBA > misión (description.ext) > addon
params ["_path", "_default"];
if (_path isEqualType "") then {_path = [_path]};
// Opciones de complementos de CBA (si el ajuste está registrado allí)
private _cba = missionNamespace getVariable ("ADVSEC_cba_" + (_path joinString "_"));
if (!isNil "_cba") exitWith {[_cba, parseNumber _cba] select (_cba isEqualType true)};
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
