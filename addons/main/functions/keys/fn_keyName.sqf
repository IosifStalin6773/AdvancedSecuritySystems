// [DIK, shift, ctrl, alt] -> "Ctrl+Shift+Inicio" (vacío si no hay tecla)
params [["_k", 0], ["_s", false], ["_c", false], ["_a", false]];
if (_k <= 0) exitWith {"(sin asignar)"};
private _parts = [];
if (_c) then {_parts pushBack "Ctrl"};
if (_s) then {_parts pushBack "Shift"};
if (_a) then {_parts pushBack "Alt"};
_parts pushBack (((keyName _k) splitString """") joinString "");
_parts joinString "+"
