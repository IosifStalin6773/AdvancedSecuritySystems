// [edificio, "1,2" | [1,2] | "all"] -> [índices]
params ["_building", ["_spec", "all"]];
if (_spec isEqualType []) exitWith {_spec};
if ((toLower _spec) in ["", "all", "*", "todas"]) exitWith {
    private _n = getNumber (configOf _building >> "numberOfDoors");
    if (_n < 1) then {
        while {isClass (configOf _building >> "AnimationSources" >> format ["Door_%1_source", _n + 1])} do {_n = _n + 1};
    };
    private _list = [];
    for "_i" from 1 to _n do {_list pushBack _i};
    _list
};
[_spec, true] call ADVSEC_fnc_parseList
