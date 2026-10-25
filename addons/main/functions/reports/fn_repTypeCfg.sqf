params ["_class"];
private _cfg = missionConfigFile >> "ADVSEC_ReportTypes" >> _class;
if (isClass _cfg) exitWith {_cfg};
configFile >> "ADVSEC_ReportTypes" >> _class
