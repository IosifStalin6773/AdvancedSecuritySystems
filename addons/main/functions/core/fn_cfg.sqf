// [nombre, porDefecto] -> ajuste general: Opciones de complementos de CBA > description.ext (ADVSEC_<nombre>) > porDefecto
params ["_name", "_default"];
private _v = missionNamespace getVariable ("ADVSEC_cba_" + _name);
if (isNil "_v") then {_v = getMissionConfigValue ["ADVSEC_" + _name, _default]};
if (_v isEqualType true) then {_v = parseNumber _v};
_v
