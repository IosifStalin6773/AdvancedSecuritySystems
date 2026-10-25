/*
    [unidad, requisito] -> bool
    requisito: [nivelMínimo (-1 = no), tiposDoc ([] = cualquiera), idLlave ("" = no)]
    Acceso si cumple (nivel/tipos) O posee la llave.
*/
params ["_unit", ["_req", []]];
_req params [["_clr", -1], ["_types", []], ["_key", ""]];

((_clr >= 0 || {_types isNotEqualTo []}) && {[_unit, _clr, _types] call ADVSEC_fnc_docCheck})
|| {_key != "" && {[_unit, -1, [], _key] call ADVSEC_fnc_docCheck}}
