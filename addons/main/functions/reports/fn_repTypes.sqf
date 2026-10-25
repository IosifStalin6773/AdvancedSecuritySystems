// -> [[clase, config], ...] (addon + misión)
private _names = ("true" configClasses (configFile >> "ADVSEC_ReportTypes")) apply {configName _x};
{_names pushBackUnique configName _x} forEach ("true" configClasses (missionConfigFile >> "ADVSEC_ReportTypes"));
_names apply {[_x, [_x] call ADVSEC_fnc_repTypeCfg]}
