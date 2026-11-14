/*
    Árbol de diálogo (1.21): ["parse", texto] -> datos · ["str", datos] -> texto · ["new"] -> datos vacíos · ["node", datos, id] -> nodo
    datos = [idInicial, [nodo, ...]]
    nodo  = [id, hablante ("npc" | "player" | "narrator"), nombre (vacío = el del NPC o el jugador), texto, x (0-1), y (0-1), [opción, ...], acciónAlEntrar, parámetro]
    opción = [texto, idDestino ("" = terminar), condición (código SQF, vacío = siempre), acción, parámetro]
    acciones: "" · "code" · "setVar" (nombre=valor) · "giveItem" (clase) · "takeItem" (clase) · "join" · "contracts" · "hint" (texto)
*/
params ["_a", ["_v", ""], ["_id", ""]];
switch (_a) do {
    case "new": {["n1", [["n1", "npc", "", ("STR_ADVSEC_dlg_default_text" call ADVSEC_fnc_L), 0.08, 0.1, [[("STR_ADVSEC_dlg_default_opt" call ADVSEC_fnc_L), "", "", "", ""]], "", ""]]]};
    case "parse": {
        if !(_v isEqualType "") exitWith {[]};
        if (_v isEqualTo "") exitWith {[]};
        private _d = parseSimpleArray _v;
        if (!(_d isEqualType []) || {count _d < 2} || {!((_d select 1) isEqualType [])}) exitWith {[]};
        // normaliza nodos y opciones (por si el texto viene de una versión anterior o editado a mano)
        _d set [1, ((_d select 1) select {_x isEqualType [] && {count _x >= 4}}) apply {
            _x params [["_nid", ""], ["_sp", "npc"], ["_nm", ""], ["_tx", ""], ["_x0", 0.1], ["_y0", 0.1], ["_op", []], ["_nac", ""], ["_npr", ""]];
            [[str _nid, _nid] select (_nid isEqualType ""), _sp, _nm, _tx, _x0, _y0,
                (_op select {_x isEqualType []}) apply {_x params [["_t", ""], ["_to", ""], ["_cn", ""], ["_ac", ""], ["_pr", ""]]; [_t, _to, _cn, _ac, _pr]}, _nac, _npr]
        }];
        _d
    };
    case "str": {str _v};
    case "node": {
        private _i = (_v select 1) findIf {(_x select 0) == _id};
        [[], (_v select 1) select _i] select (_i >= 0)
    };
    default {[]};
}
