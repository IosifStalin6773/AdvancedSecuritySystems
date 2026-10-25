// [objeto, "PM"|"AI"|"BOTH", requisito adicional ([] = solo acreditación)]
params ["_obj", ["_dept", "PM"], ["_req", []]];
if (isServer && {!(call ADVSEC_fnc_trustedInit)}) exitWith {};
if (isNull _obj) exitWith {};
private _label = switch (_dept) do {
    case "AI": {"Terminal de Asuntos Internos"};
    case "BOTH": {"Terminal de informes PM / AA.II."};
    default {"Terminal de Policía Militar"};
};
if (isServer) then {[_obj, "reports", _label] call ADVSEC_fnc_register};
[_obj, "advsec_reports", _label, ADVSEC_icDoc,
    {[_args select 0] call ADVSEC_fnc_repOpen},
    {
        _args params ["_d", "_r"];
        (_r isEqualTo [] || {[_player, _r] call ADVSEC_fnc_accessCheck})
        && {[_player, ["PM", _d] select (_d == "AI")] call ADVSEC_fnc_repAccess}
    },
    "main", [_dept, _req], 3
] call ADVSEC_fnc_addInteraction;
