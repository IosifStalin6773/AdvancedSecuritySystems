// [objeto] (todas las máquinas, 1.24): hospital. Quirófano para heridos graves y destino de las evacuaciones aéreas.
params ["_obj"];
if (isNull _obj) exitWith {};
if (isServer) then {
    [_obj, "hospital", ("STR_ADVSEC_hosp" call ADVSEC_fnc_L)] call ADVSEC_fnc_register;
    ADVSEC_hospitals = ((missionNamespace getVariable ["ADVSEC_hospitals", []]) select {!isNull _x}) + [_obj];
    publicVariable "ADVSEC_hospitals";
};
[_obj, "advsec_hosp_surgery", ("STR_ADVSEC_hosp_surgery" call ADVSEC_fnc_L), ADVSEC_icAlarm,
    {[_target] spawn ADVSEC_fnc_hospSurgery},
    {[_player, "medical"] call ADVSEC_fnc_perm},
    "main", [], 6
] call ADVSEC_fnc_addInteraction;
