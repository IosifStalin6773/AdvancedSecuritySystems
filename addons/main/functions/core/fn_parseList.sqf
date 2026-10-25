// ["1, 2" | "Passport,IDCard", numérico] -> array
params [["_str", ""], ["_numeric", false]];
if (_str isEqualType []) exitWith {_str};
private _list = (_str splitString ", ") select {_x != ""};
if (_numeric) then {_list apply {parseNumber _x}} else {_list}
