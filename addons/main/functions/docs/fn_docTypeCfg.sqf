params ["_type"];
private _cfg = missionConfigFile >> "ADVSEC_DocumentTypes" >> _type;
if (isClass _cfg) exitWith {_cfg};
configFile >> "ADVSEC_DocumentTypes" >> _type
