// PM: consultar una matrícula (por defecto la del vehículo más cercano)
private _v = (nearestObjects [player, ["LandVehicle", "Air", "Ship"], 25]) param [0, objNull];
[("STR_ADVSEC_check_plate" call ADVSEC_fnc_L), [[("STR_ADVSEC_plate" call ADVSEC_fnc_L), [getPlateNumber _v, ""] select isNull _v]], {
    params ["_v"];
    ["query", player, [_v select 0]] remoteExecCall ["ADVSEC_fnc_plateServer", 2];
}] call ADVSEC_fnc_zeusPrompt;
