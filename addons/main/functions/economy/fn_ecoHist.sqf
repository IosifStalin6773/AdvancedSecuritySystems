// [cuenta, texto, importe] (servidor): apunta un movimiento (se guardan los 40 últimos)
params ["_a", "_text", "_amt"];
private _h = _a select 3;
_h pushBack [call ADVSEC_fnc_now, _text, _amt];
if (count _h > 40) then {_h deleteRange [0, count _h - 40]};
["eco"] call ADVSEC_fnc_dbDirty;
