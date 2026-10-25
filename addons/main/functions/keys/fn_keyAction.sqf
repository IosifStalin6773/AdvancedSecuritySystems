// [id] -> bool (tecla consumida). Acciones de las teclas del mod.
params ["_id"];
if (!alive player || {!isNull findDisplay 312 && {_id != "zeusPanel"}}) exitWith {false};
if (dialog && {_id != "pda"}) exitWith {false};
private _pm = [player, "PM"] call ADVSEC_fnc_repAccess;
private _needPM = {if (!_pm) then {hint "Necesitas placa de Policía Militar o credencial de AA.II."}; _pm};
// Persona o vehículo al que se apunta (a corta distancia)
private _obj = cursorObject;
if (isNull _obj || {(player distance _obj) > 8}) then {_obj = cursorTarget};
private _man = [objNull, _obj] select (!isNull _obj && {_obj isKindOf "CAManBase"} && {alive _obj} && {_obj != player} && {(player distance _obj) < 4});
private _veh = [objNull, _obj] select (!isNull _obj && {_obj isKindOf "LandVehicle" || {_obj isKindOf "Ship"}} && {alive _obj} && {(player distance _obj) < 8});
private _needMan = {if (isNull _man) then {hint "Apunta a una persona cercana."}; !isNull _man};

switch (_id) do {
    case "pda": {if (isNull findDisplay 87200) then {[] call ADVSEC_fnc_pdaOpen} else {closeDialog 0}};
    case "keyHelp": {[] call ADVSEC_fnc_keyHelp};
    case "myDocs": {
        if (([player] call ADVSEC_fnc_docGetAll) isEqualTo []) exitWith {hint "No llevas documentos."};
        [player] call ADVSEC_fnc_docListOpen;
    };
    case "myFines": {[] call ADVSEC_fnc_fineOpen};
    case "hide": {[] call ADVSEC_fnc_hideItem};
    case "pmMenu": {if (call _needPM) then {[player, "self"] call ADVSEC_fnc_policeMenu}};
    case "targetMenu": {
        if !(call _needPM) exitWith {};
        if (!isNull _man) exitWith {[_man, "unit"] call ADVSEC_fnc_policeMenu};
        if (!isNull _veh) exitWith {[_veh] call ADVSEC_fnc_vehOpen};
        hint "Apunta a una persona o vehículo cercano.";
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
        if !([_man] call ADVSEC_fnc_isRestrained) exitWith {hint "Solo puedes escoltar a alguien esposado."};
        [_man, true] call ADVSEC_fnc_escort;
    };
    case "search": {
        if !(call _needPM) exitWith {};
        if (!isNull _man) exitWith {
            if !([_man] call ADVSEC_fnc_isRestrained || {_man getVariable ["ace_captives_isSurrendering", false]} || {"surrender" in toLower animationState _man}) exitWith {hint "La persona debe estar esposada o rendida."};
            [_man] call ADVSEC_fnc_searchOpen;
        };
        if (!isNull _veh) exitWith {[_veh] call ADVSEC_fnc_vehOpen};
        hint "Apunta a una persona o vehículo cercano.";
    };
    case "query": {if (call _needPM) then {[_man] call ADVSEC_fnc_queryOpen}};
    case "fine": {if ((call _needPM) && {call _needMan}) then {[_man] call ADVSEC_fnc_finePrompt}};
    case "askDocs": {if ((call _needPM) && {call _needMan}) then {[_man] call ADVSEC_fnc_docListOpen}};
    case "scene": {if (call _needPM) then {["scene", player] remoteExecCall ["ADVSEC_fnc_evidenceServer", 2]}};
    case "evidence": {if (call _needPM) then {[] call ADVSEC_fnc_evOpen}};
    case "heat": {
        if !([player, "suspicionView"] call ADVSEC_fnc_perm) exitWith {hint "Solo Asuntos Internos con rango suficiente."};
        [] call ADVSEC_fnc_heatOpen;
    };
    case "playerDB": {[] call ADVSEC_fnc_pdbOpen};
    case "superAdmin": {[] call ADVSEC_fnc_adminOpen};
    case "wallet": {[] call ADVSEC_fnc_ecoOpen};
    case "panic": {if ([player, "PM"] call ADVSEC_fnc_repAccess) then {["panic", player] remoteExecCall ["ADVSEC_fnc_dspServer", 2]}};
    case "dispatch": {[] call ADVSEC_fnc_dspOpen};
    case "specs": {[] call ADVSEC_fnc_specOpen};
    case "zeusPanel": {
        if !([player] call ADVSEC_fnc_isZeus) exitWith {hint "Solo Zeus o administrador."};
        [] call ADVSEC_fnc_zeusPanelOpen;
    };
    default {};
};
true
