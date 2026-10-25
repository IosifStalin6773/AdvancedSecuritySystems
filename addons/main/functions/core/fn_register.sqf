// [objeto, tipo, etiqueta, datos] (servidor) -> registro global de elementos de seguridad (panel e iconos Zeus)
params ["_obj", "_kind", ["_label", ""], ["_data", []]];
if (!isServer || {isNull _obj}) exitWith {};
if (isNil "ADVSEC_secObjects") then {ADVSEC_secObjects = []};
ADVSEC_secObjects = ADVSEC_secObjects select {!isNull (_x select 0) && {!((_x select 0) isEqualTo _obj && {(_x select 1) == _kind})}};
ADVSEC_secObjects pushBack [_obj, _kind, _label, _data];
publicVariable "ADVSEC_secObjects";
