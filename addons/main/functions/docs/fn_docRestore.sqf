// Devuelve al inventario los items de documentos propios que falten (Arsenal, cambio de equipo). No devuelve los incautados.
if (!hasInterface || {!alive player}) exitWith {};
private _seized = player getVariable ["ADVSEC_seized", []];
private _have = items player + assignedItems player;
{
    private _item = getText (([(createHashMapFromArray _x) get "type"] call ADVSEC_fnc_docTypeCfg) >> "item");
    if (_item != "" && {!(_item in _have)} && {!(_item in _seized)}) then {
        if (player canAdd _item) then {player addItem _item} else {player addItemToUniform _item};
        _have pushBack _item;
    };
} forEach (player getVariable ["ADVSEC_docs", []]);
