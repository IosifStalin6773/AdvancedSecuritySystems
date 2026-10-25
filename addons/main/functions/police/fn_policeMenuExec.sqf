if (isNil "ADVSEC_pmMenu") exitWith {};
ADVSEC_pmMenu params ["_target", "_mode", "_acts"];
private _a = _acts param [lbCurSel ((findDisplay 87100) displayCtrl 87102), []];
if (_a isEqualTo []) exitWith {};
_a params ["", "", "", "_code", ["_args", []]];
private _player = player;
closeDialog 0;
call _code;
