/*
    [título, segundos, condición, alTerminar, args, alFallar] — barra de progreso en pantalla (cliente).
    condición y códigos reciben args en _this. Se cancela si la condición deja de cumplirse o si se abre otra barra.
*/
params ["_title", "_secs", ["_cond", {true}], ["_done", {}], ["_args", []], ["_fail", {}]];
if (!hasInterface) exitWith {};
ADVSEC_progId = (missionNamespace getVariable ["ADVSEC_progId", 0]) + 1;
[ADVSEC_progId, _title, _secs, _cond, _done, _args, _fail] spawn {
    params ["_id", "_title", "_secs", "_cond", "_done", "_args", "_fail"];
    "ADVSEC_prog" cutRsc ["ADVSEC_RscProgress", "PLAIN", 0.15, false];
    private _d = uiNamespace getVariable ["ADVSEC_progDisplay", displayNull];
    (_d displayCtrl 86451) ctrlSetText toUpper _title;
    private _bar = _d displayCtrl 86453;
    private _w = 0.38;
    private _end = time + _secs;
    private _ok = true;
    while {time < _end} do {
        if (ADVSEC_progId != _id || {!alive player} || {!(_args call _cond)}) exitWith {_ok = false};
        private _f = 1 - ((_end - time) / _secs);
        _bar ctrlSetPositionW (_w * _f);
        _bar ctrlCommit 0;
        (_d displayCtrl 86452) ctrlSetText format ["%1%3 · %2 s", (round (_f * 100)) min 99, ceil (_end - time), "%"];
        uiSleep 0.05;
    };
    if (ADVSEC_progId == _id) then {"ADVSEC_prog" cutFadeOut 0.2};
    if (_ok) then {_args call _done} else {_args call _fail};
};
