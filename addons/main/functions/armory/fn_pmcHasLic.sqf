// [unidad, tipoDocumento] -> bool (servidor). ¿Tiene la unidad un documento de ese tipo emitido (licencia)?
params ["_u", "_t"];
if (isNull _u) exitWith {false};
(([] call ADVSEC_fnc_docStore) getOrDefault [[_u] call ADVSEC_fnc_docKey, []]) findIf {(_x get "type") == _t} >= 0
