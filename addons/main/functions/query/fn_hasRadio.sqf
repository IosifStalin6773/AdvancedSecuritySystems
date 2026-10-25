// [unidad] -> bool: puede contactar con la central (TFAR / ACRE si están cargados; ItemRadio si no)
params ["_unit"];
if !((["queryNeedsRadio", 1] call ADVSEC_fnc_setting) isEqualTo 1) exitWith {true};
if (isClass (configFile >> "CfgPatches" >> "tfar_core")) exitWith {
    if (!local _unit) exitWith {true};
    (call TFAR_fnc_haveSWRadio) || {call TFAR_fnc_haveLRRadio}
};
if (isClass (configFile >> "CfgPatches" >> "acre_main")) exitWith {
    if (!local _unit) exitWith {true};
    ([] call acre_api_fnc_getCurrentRadioList) isNotEqualTo []
};
"ItemRadio" in assignedItems _unit
