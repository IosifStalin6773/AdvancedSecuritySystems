/*
    Oficina de expedición (init del objeto).
    [objeto, tipos ([] = todos), nombreEmisor, requisito del operador ([] = libre), nivelMáximo]
*/
params ["_obj", ["_types", []], ["_name", "Autoridad"], ["_req", []], ["_maxClr", 5]];
if (isServer && {!(call ADVSEC_fnc_trustedInit)}) exitWith {};
if (isNull _obj) exitWith {};
if (isServer) then {[_obj, "issuer", _name] call ADVSEC_fnc_register};
_obj setVariable ["ADVSEC_issueTypes", _types];
_obj setVariable ["ADVSEC_issuerName", _name];
_obj setVariable ["ADVSEC_issueMaxClearance", _maxClr];
_obj setVariable ["ADVSEC_issueReq", _req];

[_obj, "advsec_issue", "Emitir documento", ADVSEC_icDoc,
    {[_target] call ADVSEC_fnc_docEditorOpen},
    {_args isEqualTo [] || {!isMultiplayer} || {(call BIS_fnc_admin) > 0} || {[_player, _args] call ADVSEC_fnc_accessCheck}},
    "main", _req, 3
] call ADVSEC_fnc_addInteraction;

[_obj, "advsec_licenses", "Licencias y registro de armas", ADVSEC_icDoc,
    {[_target] call ADVSEC_fnc_licOpen},
    {[] call ADVSEC_fnc_ecoOn},
    "main", [], 3
] call ADVSEC_fnc_addInteraction;
