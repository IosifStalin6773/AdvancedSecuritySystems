// [[[id, texto, icono, código, args, subhijos?], ...], objetivo] -> hijos ACE; con subhijos crea un submenú
params ["_list", "_target"];
_list apply {
    _x params ["_cid", "_ctext", "_cicon", "_ccode", ["_cargs", []], ["_csub", []]];
    private _child = if (_csub isEqualTo []) then {
        [_cid, _ctext, _cicon, {params ["_target", "_player", "_p"]; _p params ["_code", "_args"]; call _code}, {true}, {}, [_ccode, _cargs]] call ace_interact_menu_fnc_createAction
    } else {
        [_cid, _ctext, _cicon, {}, {true}, {params ["_target", "", "_p"]; [_p select 2, _target] call ADVSEC_fnc_aceKids}, [_ccode, _cargs, _csub]] call ace_interact_menu_fnc_createAction
    };
    [_child, [], _target]
}
