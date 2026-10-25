// [persona, importe, motivo, nombreAgente, uidAgente] -> id (servidor, sin validación: la hace quien llama)
params ["_unit", "_amount", "_reason", "_by", ["_byUid", ""]];
private _db = [] call ADVSEC_fnc_fineDB;
private _key = [_unit] call ADVSEC_fnc_docKey;
private _n = (localNamespace getVariable ["ADVSEC_fineSeq", 0]) + 1;
localNamespace setVariable ["ADVSEC_fineSeq", _n];
private _id = format ["M-%1-%2", (date select 0), [_n, 4] call BIS_fnc_padNumber];
private _list = _db getOrDefault [_key, []];
_list pushBack [_id, call ADVSEC_fnc_now, _amount, _reason, _by, _byUid, "Pendiente", name _unit, ""];
_db set [_key, _list];
["fines"] call ADVSEC_fnc_dbDirty;
["fine", objNull, [name _unit, _key, _amount, _reason, _by]] call ADVSEC_fnc_logEvent;
private _cur = ["currency", "€"] call ADVSEC_fnc_setting;
if (isPlayer _unit) then {
    (format ["Has recibido la multa %1 de %2 %3.\nMotivo: %4\nAgente: %5\n\nConsúltala en tu PDA o en el menú personal (Mis multas).", _id, _amount, _cur, _reason, _by]) remoteExecCall ["hint", _unit];
};
// Importe pendiente alto: requisitoria automática
private _thr = ["fineWantedThreshold", 0] call ADVSEC_fnc_setting;
if (_thr > 0 && {isPlayer _unit}) then {
    private _due = 0;
    {if ((_x select 6) == "Pendiente") then {_due = _due + (_x select 2)}} forEach _list;
    if (_due >= _thr) then {[_key, name _unit, format ["Multas impagadas (%1 %2)", _due, _cur], "Baja"] call ADVSEC_fnc_wantedSys};
};
_id
