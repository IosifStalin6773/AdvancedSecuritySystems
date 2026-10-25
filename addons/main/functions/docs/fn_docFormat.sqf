// [documento] -> texto estructurado con sus campos (vista previa)
params ["_doc"];
if (_doc isEqualType []) then {_doc = createHashMapFromArray _doc};
private _cfg = [_doc get "type"] call ADVSEC_fnc_docTypeCfg;
private _labels = getArray (_cfg >> "labels");
private _txt = format ["<t size='1.25' font='RobotoCondensedBold' color='#D0A330'>%1</t><br/><img image='%2' size='1.6'/><br/>", getText (_cfg >> "displayName"), getText (_cfg >> "icon")];
{
    private _v = _doc getOrDefault [_x, ""];
    if (_v isEqualType []) then {_v = _v joinString ", "};
    if !(_v isEqualType "") then {_v = str _v};
    _txt = _txt + format ["<t color='#8C8C8C'>%1:</t> %2<br/>", _labels param [_forEachIndex, _x], [_v] call ADVSEC_fnc_repEsc];
} forEach getArray (_cfg >> "fields");
private _exp = _doc getOrDefault ["expires", ""];
if (_exp isNotEqualTo "") then {
    date params ["_y", "_m", "_d"];
    if (parseNumber ((_exp splitString "-/.") joinString "") < (_y * 10000 + _m * 100 + _d)) then {_txt = _txt + "<br/><t color='#FF4D4D' font='RobotoCondensedBold'>CADUCADO</t>"};
};
_txt + format ["<br/><t color='#8C8C8C' size='0.85'>%1</t>", _doc get "id"]
