// [unidad] -> descuento (0-1) en tiendas legales por las medallas que tiene (suma de su %, con tope medalDiscountMax)
params ["_unit"];
private _aw = _unit getVariable ["ADVSEC_medals", []];
if (_aw isEqualTo []) exitWith {0};
private _pct = 0;
{if ((_x select 0) in _aw) then {_pct = _pct + (_x param [2, 0])}} forEach (["medals", []] call ADVSEC_fnc_setting);
((_pct min (["medalDiscountMax", 15] call ADVSEC_fnc_setting)) max 0) / 100
