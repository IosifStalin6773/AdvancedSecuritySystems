// [prueba, verResultado] -> texto corto
params ["_e", ["_full", false]];
private _t = switch (_e get "type") do {
    case "casing": {format [("STR_ADVSEC_casing" call ADVSEC_fnc_L), _e getOrDefault ["ammoName", ""]]};
    case "print": {format [("STR_ADVSEC_fingerprint_on" call ADVSEC_fnc_L), _e getOrDefault ["objName", "superficie"]]};
    case "blood": {("STR_ADVSEC_blood_traces" call ADVSEC_fnc_L)};
    default {("STR_ADVSEC_evidence_4" call ADVSEC_fnc_L)};
};
format ["%1 · %2", _e get "id", _t]
