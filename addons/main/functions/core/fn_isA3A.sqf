// -> bool: la misión es Antistasi (Ultimate o Community). Con el mod Antistasi Ultimate cargado sus funciones existen
// en cualquier misión, así que se mira la configuración de la propia misión.
private _r = missionNamespace getVariable "ADVSEC_isA3A";
if (isNil "_r") then {
    _r = isClass (missionConfigFile >> "A3A") || {isClass (missionConfigFile >> "CfgFunctions" >> "A3A")};
    missionNamespace setVariable ["ADVSEC_isA3A", _r];
};
_r
