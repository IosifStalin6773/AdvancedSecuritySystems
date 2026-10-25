params ["_unit"];
private _g = _unit getVariable ["ADVSEC_globalRank", ""];
if (_g isNotEqualTo "") exitWith {_g};
switch (rank _unit) do {
    case "PRIVATE": {"Soldado"};
    case "CORPORAL": {"Cabo"};
    case "SERGEANT": {"Sargento"};
    case "LIEUTENANT": {"Teniente"};
    case "CAPTAIN": {"Capitán"};
    case "MAJOR": {"Comandante"};
    case "COLONEL": {"Coronel"};
    default {""};
}
