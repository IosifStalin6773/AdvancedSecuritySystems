// [unidad] — imponer una multa
params ["_unit"];
private _cur = ["currency", "€"] call ADVSEC_fnc_setting;
[format ["MULTA · %1", name _unit], [
    ["Importe", 100, [50, 100, 150, 200, 300, 500, 1000, 2000] apply {[format ["%1 %2", _x, _cur], _x]}],
    ["Motivo", "", ["Circular sin documentación", "Exceso de velocidad", "Conducción temeraria", "Desobediencia a la autoridad", "Alteración del orden", "Portar arma sin licencia", "Acceso a zona restringida", "Otro"]],
    ["Detalle (opcional)", ""]
], {
    params ["_v", "_unit"];
    _v params ["_amt", "_reason", "_detail"];
    if (_detail isNotEqualTo "") then {_reason = format ["%1: %2", _reason, _detail]};
    ["issue", player, [_unit, _amt, _reason]] remoteExecCall ["ADVSEC_fnc_fineServer", 2];
}, _unit] call ADVSEC_fnc_zeusPrompt;
