params ["_r"];
private _disp = [] call ADVSEC_fnc_repDisp;
if (isNull _disp) exitWith {};
private _ctrl = _disp displayCtrl 86603;
if (count _r == 0) exitWith {_ctrl ctrlSetStructuredText parseText "<t color='#8C8C8C'>Sin informes. Usa «Nuevo informe» para registrar uno.</t>"};

private _e = {[_this] call ADVSEC_fnc_repEsc};
private _row = {params ["_k", "_v"]; format ["<t color='#8C8C8C'>%1:</t> %2<br/>", _k, _v call _e]};
private _txt = format [
    "<t size='1.4' font='RobotoCondensedBold'>%1</t><br/><t color='#D0A330'>%2 · %3</t><br/><br/>",
    (_r get "id") call _e, (_r get "typeName") call _e, ["POLICÍA MILITAR", "ASUNTOS INTERNOS"] select ((_r get "dept") == "AI")
];
if (_r getOrDefault ["confidential", false]) then {_txt = _txt + "<t color='#FF4D4D' font='RobotoCondensedBold'>CONFIDENCIAL — RESERVADO A AA.II.</t><br/>"};
{_txt = _txt + (_x call _row)} forEach [
    ["Asunto", _r get "title"],
    ["Estado", _r get "status"],
    ["Gravedad", _r get "gravity"],
    ["Sanción", _r getOrDefault ["sanction", "Ninguna"]],
    ["Implicados", (_r getOrDefault ["subjects", []]) joinString "; "],
    ["Hechos (fecha/lugar)", _r getOrDefault ["place", ""]],
    ["Evidencias / testigos", _r getOrDefault ["witnesses", ""]],
    ["Registrado por", format ["%1 [%2]", _r get "author", _r get "authorUid"]],
    ["Registro", format ["%1 · %2", _r get "created", _r getOrDefault ["mission", ""]]],
    ["Última modificación", _r get "updated"]
];
_txt = _txt + "<br/><t font='RobotoCondensedBold'>DESCRIPCIÓN</t><br/>" + ((_r getOrDefault ["body", ""]) call _e) + "<br/>";

private _notes = _r getOrDefault ["notes", []];
if (_notes isNotEqualTo []) then {
    _txt = _txt + "<br/><t font='RobotoCondensedBold'>ANOTACIONES</t><br/>";
    {
        _x params ["_ts", "_name", "_uid", "_note"];
        _txt = _txt + format ["<t color='#8C8C8C'>%1 · %2 [%3]</t><br/>%4<br/>", _ts, _name call _e, _uid, _note call _e];
    } forEach _notes;
};
private _access = _r getOrDefault ["access", []];
if (_access isNotEqualTo []) then {
    _txt = _txt + "<br/><t font='RobotoCondensedBold'>REGISTRO DE ACCESOS</t><br/>";
    {_x params ["_ts", "_name", "_uid"]; _txt = _txt + format ["<t color='#8C8C8C' size='0.85'>%1 · %2 [%3]</t><br/>", _ts, _name call _e, _uid]} forEach (_access select [(count _access - 15) max 0]);
};

_ctrl ctrlSetStructuredText parseText _txt;
_ctrl ctrlSetPositionH ((ctrlTextHeight _ctrl) max (((ctrlPosition (_disp displayCtrl 86620)) select 3) - 0.01));
_ctrl ctrlCommit 0;
