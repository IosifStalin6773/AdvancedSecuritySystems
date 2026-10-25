// [prueba] -> texto estructurado con ficha y cadena de custodia (las manipulaciones no se muestran)
params ["_e"];
private _esc = {[_this] call ADVSEC_fnc_repEsc};
private _st = createHashMapFromArray [["field", "En la escena"], ["bagged", "Embolsada"], ["analyzing", "En análisis"], ["analyzed", "Analizada"]];
private _lines = [
    format ["<t size='1.2' font='RobotoCondensedBold'>%1</t>", ([_e] call ADVSEC_fnc_evSummary) call _esc],
    format ["<t color='#8C8C8C'>Hallada:</t> %1 · cuadrícula %2", _e get "time", _e get "grid"],
    format ["<t color='#8C8C8C'>Estado:</t> %1%2", _st getOrDefault [_e get "state", "?"], ["", format [" · custodia: %1", (_e get "holderName") call _esc]] select ((_e get "holderName") isNotEqualTo "")]
];
if ((_e get "type") == "casing") then {_lines pushBack format ["<t color='#8C8C8C'>Arma:</t> %1 · nº de serie %2", (_e getOrDefault ["weaponName", ""]) call _esc, _e getOrDefault ["serial", ""]]};
_lines pushBack format ["<br/><t font='RobotoCondensedBold'>RESULTADO DEL LABORATORIO</t><br/>%1", ["<t color='#8C8C8C'>Pendiente de análisis.</t>", (_e get "result") call _esc] select ((_e get "result") isNotEqualTo "")];
_lines pushBack "<br/><t font='RobotoCondensedBold'>CADENA DE CUSTODIA</t>";
{_x params ["_ts", "_name", "_uid", "_what"]; _lines pushBack format ["<t color='#8C8C8C' size='0.9'>%1</t> · %2 · %3", _ts, _name call _esc, _what call _esc]} forEach (_e get "chain");
_lines joinString "<br/>"
