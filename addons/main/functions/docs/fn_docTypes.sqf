private _types = ("true" configClasses (configFile >> "ADVSEC_DocumentTypes")) apply {configName _x};
{_types pushBackUnique configName _x} forEach ("true" configClasses (missionConfigFile >> "ADVSEC_DocumentTypes"));
_types
