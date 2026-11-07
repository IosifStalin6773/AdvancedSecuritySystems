// Group identity lives in existing placement IDs; save/preset records remain unchanged.
params [['_key','']];if !(_key isEqualType '') exitWith {''};private _p=_key splitString '_';
if (count _p!=6 || {(_p select 0)!='added'} || {(_p select 1)!='stack'}) exitWith {''};
private _numeric=true;{if (_x=='' || {((toArray _x) findIf {_x<48 || {_x>57}})>=0}) then {_numeric=false;};} forEach (_p select [2,4]);if (!_numeric) exitWith {''};
private _i=parseNumber (_p select 4);private _n=parseNumber (_p select 5);if (_n<2 || {_n>10} || {_i<0} || {_i>=_n}) exitWith {''};
(_p select [0,4]) joinString '_'
