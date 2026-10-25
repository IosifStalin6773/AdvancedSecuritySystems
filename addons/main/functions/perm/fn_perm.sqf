// [unidad, acción] -> bool. Zeus/administrador y modo un jugador: siempre. Ver ADVSEC_Settings >> Permissions.
params ["_unit", "_action"];
if (isNull _unit) exitWith {false};
if ([_unit] call ADVSEC_fnc_isZeus) exitWith {true};
([["Permissions", _action], ["PM", 1]] call ADVSEC_fnc_setting) params [["_dept", "PM"], ["_min", 1]];
private _cba = missionNamespace getVariable ("ADVSEC_cba_perm_" + _action);
if (!isNil "_cba") then {_min = round _cba};
if !([_unit, _dept] call ADVSEC_fnc_repAccess) exitWith {false};
private _lvl = [_unit, _dept] call ADVSEC_fnc_rankLevel;
if (_lvl == 0) exitWith {((["pdaGrantsAccess", 0] call ADVSEC_fnc_cfg)) isEqualTo 1 && {_min <= 1}};
_lvl >= _min
