/*
    Wrapper ACE / addAction. Ejecutar en cada cliente (efecto local).
    [target, id, texto, icono, statement, condition, parent, args, distancia, posición, hijos]
    parent: "main" (ACE_MainActions) | "self" (ACE_SelfActions) | "root" (raíz del objeto)
    statement/condition/hijos ven: _target, _player, _args
    hijos (solo ACE): código que devuelve [[id, texto, icono, statement, args], ...]; sin ACE se usa el statement.
*/
params [
    "_target", "_id", "_text", ["_icon", ""], "_statement", ["_condition", {true}],
    ["_parent", "main"], ["_args", []], ["_distance", 2.5], ["_position", [0, 0, 0]], ["_children", {}]
];
if (!hasInterface || {isNull _target}) exitWith {};
// Volver a aplicar un módulo al mismo objeto sustituye la acción en vez de duplicarla
private _ace = isClass (configFile >> "CfgPatches" >> "ace_interact_menu");
private _known = _target getVariable ["ADVSEC_actIds", createHashMap];
_target setVariable ["ADVSEC_actIds", _known];
private _prev = _known getOrDefault [_id, []];
if (_prev isNotEqualTo []) then {
    if (_ace) then {[_target, _prev select 0, _prev select 1] call ace_interact_menu_fnc_removeActionFromObject} else {_target removeAction (_prev select 0)};
    _known deleteAt _id;
};

// Objetos grandes: el punto de interacción está en el centro del modelo, así que se amplía el alcance
if (_parent != "self" && {_position isEqualTo [0, 0, 0]}) then {_distance = _distance max (((boundingBoxReal _target) select 2) * 0.8)};

if (_ace) then {
    private _type = parseNumber (_parent == "self");
    private _path = switch (_parent) do {
        case "self": {["ACE_SelfActions"]};
        case "root": {[]};
        default {["ACE_MainActions"]};
    };

    if (
        _parent == "main"
        && {!(_target getVariable ["ADVSEC_aceRoot", false])}
        && {!isClass (configOf _target >> "ACE_Actions" >> "ACE_MainActions")}
    ) then {
        _target setVariable ["ADVSEC_aceRoot", true];
        private _root = ["ACE_MainActions", "Interacciones", "", {}, {true}, {}, [], [0, 0, 0], _distance max 3] call ace_interact_menu_fnc_createAction;
        [_target, 0, [], _root] call ace_interact_menu_fnc_addActionToObject;
    };

    private _hasChildren = _children isNotEqualTo {};
    private _action = [
        _id,
        _text,
        _icon,
        [{params ["_target", "_player", "_p"]; _p params ["_code", "", "_args"]; call _code}, {}] select _hasChildren,
        {params ["_target", "_player", "_p"]; _p params ["", "_cond", "_args"]; call _cond},
        [{}, {
            params ["_target", "_player", "_p"];
            _p params ["", "", "_args", "_kids"];
            [call _kids, _target] call ADVSEC_fnc_aceKids
        }] select _hasChildren,
        [_statement, _condition, _args, _children],
        _position,
        _distance,
        [false, false, false, false, _parent == "root"],
        {}
    ] call ace_interact_menu_fnc_createAction;
    [_target, _type, _path, _action] call ace_interact_menu_fnc_addActionToObject;
    _known set [_id, [_type, _path + [_id]]];
} else {
    ADVSEC_actCounter = ADVSEC_actCounter + 1;
    private _key = format ["a%1", ADVSEC_actCounter];
    ADVSEC_actConds set [_key, [_condition, _args]];

    private _cond = format ["private _player = _this; (ADVSEC_actConds get '%1') params ['_cond', '_args']; call _cond", _key];
    private _radius = _distance;
    if (_position isEqualType "") then {
        _cond = format ["((_target modelToWorldVisual (_target selectionPosition '%1')) distance _this) < %2 && {%3}", _position, _distance, _cond];
        _radius = 50;
    };

    private _aid = _target addAction [
        if (_icon != "") then {format ["<img image='%1'/> %2", _icon, _text]} else {_text},
        {params ["_target", "_player", "", "_p"]; _p params ["_code", "_args"]; call _code},
        [_statement, _args],
        1.5, false, true, "", _cond, _radius
    ];
    _known set [_id, [_aid]];
};
