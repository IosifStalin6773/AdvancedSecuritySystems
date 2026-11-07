// [id] -> bool (tecla consumida). Acciones de las teclas del mod.
params ["_id"];
if (!alive player || {!isNull findDisplay 312 && {_id != "zeusPanel"}}) exitWith {false};
if (dialog && {_id != "pda"}) exitWith {false};
private _pm = [player, "PM"] call ADVSEC_fnc_repAccess;
private _needPM = {if (!_pm) then {hint ("STR_ADVSEC_you_need_a_military_police_3" call ADVSEC_fnc_L)}; _pm};
// Persona o vehículo al que se apunta (a corta distancia)
private _obj = cursorObject;
if (isNull _obj || {(player distance _obj) > 8}) then {_obj = cursorTarget};
private _man = [objNull, _obj] select (!isNull _obj && {_obj isKindOf "CAManBase"} && {alive _obj} && {_obj != player} && {(player distance _obj) < 4});
private _veh = [objNull, _obj] select (!isNull _obj && {_obj isKindOf "LandVehicle" || {_obj isKindOf "Ship"}} && {alive _obj} && {(player distance _obj) < 8});
private _needMan = {if (isNull _man) then {hint ("STR_ADVSEC_aim_at_a_nearby_person" call ADVSEC_fnc_L)}; !isNull _man};

switch (_id) do {
    case "pda": {if (isNull findDisplay 87200) then {[] call ADVSEC_fnc_pdaOpen} else {closeDialog 0}};
    case "keyHelp": {[] call ADVSEC_fnc_keyHelp};
    case "myDocs": {
        if (([player] call ADVSEC_fnc_docGetAll) isEqualTo []) exitWith {hint ("STR_ADVSEC_you_carry_no_documents" call ADVSEC_fnc_L)};
        [player] call ADVSEC_fnc_docListOpen;
    };
    case "myFines": {[] call ADVSEC_fnc_fineOpen};
    case "hide": {[] call ADVSEC_fnc_hideItem};
    case "pmMenu": {if (call _needPM) then {[player, "self"] call ADVSEC_fnc_policeMenu}};
    case "targetMenu": {
        if !(call _needPM) exitWith {};
        if (!isNull _man) exitWith {[_man, "unit"] call ADVSEC_fnc_policeMenu};
        if (!isNull _veh) exitWith {[_veh] call ADVSEC_fnc_vehOpen};
        hint ("STR_ADVSEC_aim_at_a_nearby_person_2" call ADVSEC_fnc_L);
    };
    case "restrain": {
        if (!(call _needPM) || {!(call _needMan)}) exitWith {};
        [_man, !([_man] call ADVSEC_fnc_isRestrained), player] call ADVSEC_fnc_restrain;
    };
    case "escort": {
        if !(call _needPM) exitWith {};
        private _cur = player getVariable ["ADVSEC_escorting", objNull];
        if (!isNull _cur) exitWith {[_cur, false] call ADVSEC_fnc_escort};
        if !(call _needMan) exitWith {};
        if !([_man] call ADVSEC_fnc_isRestrained) exitWith {hint ("STR_ADVSEC_you_can_only_escort_someone" call ADVSEC_fnc_L)};
        [_man, true] call ADVSEC_fnc_escort;
    };
    case "search": {
        if !(call _needPM) exitWith {};
        if (!isNull _man) exitWith {
            if !([_man] call ADVSEC_fnc_isRestrained || {_man getVariable ["ace_captives_isSurrendering", false]} || {"surrender" in toLower animationState _man}) exitWith {hint ("STR_ADVSEC_the_person_must_be_handcuffed" call ADVSEC_fnc_L)};
            [_man] call ADVSEC_fnc_searchOpen;
        };
        if (!isNull _veh) exitWith {[_veh] call ADVSEC_fnc_vehOpen};
        hint ("STR_ADVSEC_aim_at_a_nearby_person_2" call ADVSEC_fnc_L);
    };
    case "query": {if (call _needPM) then {[_man] call ADVSEC_fnc_queryOpen}};
    case "fine": {if ((call _needPM) && {call _needMan}) then {[_man] call ADVSEC_fnc_finePrompt}};
    case "askDocs": {if ((call _needPM) && {call _needMan}) then {[_man] call ADVSEC_fnc_docListOpen}};
    case "scene": {if (call _needPM) then {["scene", player] remoteExecCall ["ADVSEC_fnc_evidenceServer", 2]}};
    case "evidence": {if (call _needPM) then {[] call ADVSEC_fnc_evOpen}};
    case "heat": {
        if !([player, "suspicionView"] call ADVSEC_fnc_perm) exitWith {hint ("STR_ADVSEC_only_internal_affairs_with_sufficient" call ADVSEC_fnc_L)};
        [] call ADVSEC_fnc_heatOpen;
    };
    case "playerDB": {[] call ADVSEC_fnc_pdbOpen};
    case "superAdmin": {[] call ADVSEC_fnc_adminOpen};
    case "wallet": {[] call ADVSEC_fnc_ecoOpen};
    case "panic": {if ([player, "PM"] call ADVSEC_fnc_repAccess) then {["panic", player] remoteExecCall ["ADVSEC_fnc_dspServer", 2]}};
    case "dispatch": {[] call ADVSEC_fnc_dspOpen};
    case "specs": {[] call ADVSEC_fnc_specOpen};
    case "zeusPanel": {
        if !([player] call ADVSEC_fnc_isZeus) exitWith {hint ("STR_ADVSEC_zeus_or_admin_only" call ADVSEC_fnc_L)};
        [] call ADVSEC_fnc_zeusPanelOpen;
    };
    default {};
};
true
