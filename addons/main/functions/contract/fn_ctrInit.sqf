// [objeto, nombre] — terminal de contratos de la PMC (init del objeto, todas las máquinas)
params ["_obj", ["_name", ("STR_ADVSEC_pmc_terminal" call ADVSEC_fnc_L)]];
if (isServer && {!(call ADVSEC_fnc_trustedInit)}) exitWith {};
if (isNull _obj) exitWith {};
if (isServer) then {
    [_obj, "contract", _name] call ADVSEC_fnc_register;
    private _t = missionNamespace getVariable ["ADVSEC_ctrTerminals", []];
    _t pushBackUnique _obj;
    missionNamespace setVariable ["ADVSEC_ctrTerminals", _t];
};
[_obj, "advsec_contract", _name, ADVSEC_icDoc,
    {[] call ADVSEC_fnc_ctrOpen},
    {[_player, "contractView"] call ADVSEC_fnc_perm},
    "main", [], 3
] call ADVSEC_fnc_addInteraction;
