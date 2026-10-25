// [unidad] (servidor): copia de solo lectura de sus documentos en la unidad para la interfaz de los clientes
params ["_unit"];
private _docs = ([] call ADVSEC_fnc_docStore) getOrDefault [[_unit] call ADVSEC_fnc_docKey, []];
_unit setVariable ["ADVSEC_docs", _docs apply {[_x] call ADVSEC_fnc_docPairs}, true];
