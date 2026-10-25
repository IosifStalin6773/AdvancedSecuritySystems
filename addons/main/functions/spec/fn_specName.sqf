// [id] -> nombre de la especialidad
params ["_id"];
private _c = missionConfigFile >> "ADVSEC_Specialties" >> _id;
if (!isClass _c) then {_c = configFile >> "ADVSEC_Specialties" >> _id};
[_id, getText (_c >> "name")] select (getText (_c >> "name") isNotEqualTo "")
