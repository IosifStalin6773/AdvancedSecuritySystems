// [unidad] -> "Sargento PM" / "Comisario AA.II." / "" según su placa de mayor rango
params ["_unit"];
private _ai = [_unit, "AI"] call ADVSEC_fnc_rankLevel;
if (_ai > 0) exitWith {format ["%1 AA.II.", (["ranksAI", []] call ADVSEC_fnc_setting) param [_ai - 1, ""]]};
private _pm = [_unit, "PM"] call ADVSEC_fnc_rankLevel;
if (_pm > 0) exitWith {format ["%1 PM", (["ranksPM", []] call ADVSEC_fnc_setting) param [_pm - 1, ""]]};
""
