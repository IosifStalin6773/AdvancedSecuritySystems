params ['_c'];private _oldCases=count _c<24;private _v=parseSimpleArray (str _c);while {count _v<count TSL_customDefault} do {_v pushBack ((parseSimpleArray (str [TSL_customDefault select (count _v)])) select 0);};
// Migrate the initial authored layout to the supplied outside hanging pose.
if ((_v select 20)==0) then {private _rifles=+(_v select 21);if ((_rifles select 0)==4) then {_rifles set [0,3];};_v set [21,_rifles];_v set [20,1];};
{private _i=_x;private _a=+(_v select _i);while {count _a<5} do {_a pushBack ((TSL_customDefault select _i) select (count _a));};_v set [_i,_a];} forEach [5,21];if (_oldCases && {(_v select 19)==0}) then {_v set [23,_v select 3];_v set [3,false];_v set [19,1];};if (_v select 27) then {_v set [18,false];};if (_v select 28) then {_v set [16,false];};_v
