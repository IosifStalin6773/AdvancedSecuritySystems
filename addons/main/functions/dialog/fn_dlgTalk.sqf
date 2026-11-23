/*
    [npc, idNodo ("" = el inicial)] — ventana de conversación (cliente). ["pick"] = responder con la opción elegida.
    Solo se muestran las respuestas cuya condición se cumple (código con _player y _npc). Sin respuestas: «Terminar».
*/
params ["_npc", ["_id", ""]];
if (!hasInterface) exitWith {};
if (_npc isEqualTo "pick") exitWith {
    private _d = findDisplay 88300;
    if (isNull _d) exitWith {};
    (_d getVariable ["ADVSEC_talk", []]) params [["_n", objNull], ["_opts", []]];
    private _r = lbCurSel (_d displayCtrl 88303);
    if (_r < 0) exitWith {};
    private _o = _opts param [_r, []];
    if (_o isEqualTo []) exitWith {closeDialog 0};
    _o params ["", ["_to", ""], "", ["_ac", ""], ["_pr", ""]];
    [_n, _ac, _pr] call ADVSEC_fnc_dlgAction;
    if (_to isEqualTo "" || {_ac == "contracts"}) exitWith {closeDialog 0};
    [_n, _to] call ADVSEC_fnc_dlgTalk;
};
private _data = _npc getVariable ["ADVSEC_dlg", []];
if (_data isEqualTo []) exitWith {};
if (_id isEqualTo "") then {_id = _data select 0};
private _node = ["node", _data, _id] call ADVSEC_fnc_dlgData;
if (_node isEqualTo []) exitWith {closeDialog 0};
_node params ["", ["_sp", "npc"], ["_nm", ""], ["_tx", ""], "", "", ["_op", []], ["_nac", ""], ["_npr", ""]];
// Acción del nodo: se ejecuta al mostrarlo
if (_nac isNotEqualTo "") then {[_npc, _nac, _npr] call ADVSEC_fnc_dlgAction};
if (_nac == "contracts") exitWith {closeDialog 0};
if (isNull findDisplay 88300 && {!createDialog "ADVSEC_DlgTalk"}) exitWith {};
private _d = findDisplay 88300;
private _who = if (_nm isNotEqualTo "") then {_nm} else {
    switch (_sp) do {case "player": {name player}; case "narrator": {""}; default {name _npc}}
};
(_d displayCtrl 88301) ctrlSetText toUpper ([_who, ("STR_ADVSEC_dlg_sp_narrator" call ADVSEC_fnc_L)] select (_who isEqualTo ""));
// Variables en el texto: %npc% y %player%
private _t = [_tx] call ADVSEC_fnc_repEsc;
_t = (_t regexReplace ["%npc%", [name _npc] call ADVSEC_fnc_repEsc]) regexReplace ["%player%", [name player] call ADVSEC_fnc_repEsc];
(_d displayCtrl 88302) ctrlSetStructuredText parseText format ["<t size='1.05' %1>%2</t>", ["", "font='RobotoCondensedLight' color='#bbbbbb'"] select (_sp == "narrator"), _t];
private _ok = _op select {
    private _cn = _x select 2;
    if (_cn isEqualTo "") then {true} else {
        private _player = player;
        private _r = call compile _cn;
        _r isEqualTo true
    }
};
if (_ok isEqualTo []) then {_ok = [[("STR_ADVSEC_dlg_finish" call ADVSEC_fnc_L), "", "", "", ""]]};
private _lb = _d displayCtrl 88303;
lbClear _lb;
{_lb lbAdd format ["%1. %2", _forEachIndex + 1, _x select 0]} forEach _ok;
_lb lbSetCurSel 0;
_d setVariable ["ADVSEC_talk", [_npc, _ok]];
