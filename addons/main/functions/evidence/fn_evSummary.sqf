// [prueba, verResultado] -> texto corto
params ["_e", ["_full", false]];
private _t = switch (_e get "type") do {
    case "casing": {format ["Casquillo %1", _e getOrDefault ["ammoName", ""]]};
    case "print": {format ["Huella en %1", _e getOrDefault ["objName", "superficie"]]};
    case "blood": {"Restos de sangre"};
    default {"Prueba"};
};
format ["%1 · %2", _e get "id", _t]
