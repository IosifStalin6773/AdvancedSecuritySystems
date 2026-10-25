// [unidad, deServicio] (servidor): ficha entrada/salida, suma las horas y enciende/apaga la cámara corporal
params ["_unit", "_on"];
if (isNull _unit) exitWith {};
private _was = _unit getVariable ["ADVSEC_onDuty", false];
if (_was isEqualTo _on) exitWith {};
private _uid = getPlayerUID _unit;
private _db = [] call ADVSEC_fnc_dutyDB;
private _e = _db getOrDefault [_uid, [0, name _unit, []]];
_e set [1, name _unit];
if (_on) then {
    _unit setVariable ["ADVSEC_dutyStart", serverTime];
    _unit setVariable ["ADVSEC_dutyStartTxt", call ADVSEC_fnc_now];
} else {
    private _min = round ((serverTime - (_unit getVariable ["ADVSEC_dutyStart", serverTime])) / 60);
    _e set [0, (_e select 0) + _min];
    (_e select 2) pushBack [_unit getVariable ["ADVSEC_dutyStartTxt", ""], call ADVSEC_fnc_now, _min];
    if (count (_e select 2) > 50) then {(_e select 2) deleteAt 0};
};
_db set [_uid, _e];
["duty"] call ADVSEC_fnc_dbDirty;
_unit setVariable ["ADVSEC_onDuty", _on, true];
_unit setVariable ["ADVSEC_bodycam", _on, true];
[["dutyOff", "dutyOn"] select _on, _unit, [round (_e select 0)]] call ADVSEC_fnc_logEvent;
