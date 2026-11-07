// [clase de ADVSEC_Settings] -> subclases (las de description.ext sustituyen a las del addon si existen)
params ["_name"];
private _m = missionConfigFile >> "ADVSEC_Settings" >> _name;
if (isClass _m && {("true" configClasses _m) isNotEqualTo []}) exitWith {"true" configClasses _m};
"true" configClasses (configFile >> "ADVSEC_Settings" >> _name)
