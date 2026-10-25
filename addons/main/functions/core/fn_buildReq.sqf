// [nivel, tipos ("A,B" o array), llave] -> requisito ([] si no exige nada)
params [["_clr", -1], ["_types", ""], ["_key", ""]];
if (_clr isEqualType "") then {_clr = if (_clr isEqualTo "") then {-1} else {parseNumber _clr}};
_types = [_types] call ADVSEC_fnc_parseList;
if (_clr < 0 && {_types isEqualTo []} && {_key isEqualTo ""}) exitWith {[]};
[_clr, _types, _key]
