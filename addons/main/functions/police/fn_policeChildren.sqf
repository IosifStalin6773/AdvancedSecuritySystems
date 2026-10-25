/*
    Acciones de Policía Militar -> [[id, texto, icono, código, args], ...] (hijos ACE y menú sin ACE)
    [objetivo, agente, modo] modo: "unit" | "self" | "zeus"
*/
params ["_target", "_player", ["_mode", "unit"]];
private _list = [];
private _add = {_list pushBack _this};

if (_mode == "self") exitWith {
    ["advsec_pm_unload", "Sacar detenidos del vehículo", ADVSEC_icCar, {[_player] call ADVSEC_fnc_policeUnload}, []] call _add;
    ["advsec_pm_wanted", "Lista de buscados", ADVSEC_icPol, {[] call ADVSEC_fnc_wantedOpen}, []] call _add;
    ["advsec_pm_reports", "Archivo de informes", ADVSEC_icDoc, {["BOTH"] call ADVSEC_fnc_repOpen}, []] call _add;
    ["advsec_pm_incident", "Registrar incidente", ADVSEC_icDoc, {["PM"] call ADVSEC_fnc_repEditorOpen}, []] call _add;
    ["advsec_pm_query", "Consulta a la central", ADVSEC_icSearch, {[] call ADVSEC_fnc_queryOpen}, []] call _add;
    private _veh = (nearestObjects [_player, ["Car", "Motorcycle", "Tank", "Ship"], 7]) select {alive _x && {isNull objectParent _player}};
    if (_veh isNotEqualTo [] && {[_player, "vehicleSearch"] call ADVSEC_fnc_perm}) then {
        ["advsec_pm_vehsearch", format ["Registrar %1", getText (configOf (_veh select 0) >> "displayName")], ADVSEC_icCar, {[_args select 0] call ADVSEC_fnc_vehOpen}, [_veh select 0]] call _add;
    };
    if ([_player, "evidenceCollect"] call ADVSEC_fnc_perm) then {
        ["advsec_pm_scene", "Inspeccionar escena (pruebas)", ADVSEC_icSearch, {["scene", _player] remoteExecCall ["ADVSEC_fnc_evidenceServer", 2]}, []] call _add;
    };
    ["advsec_pm_evidence", "Registro de pruebas", ADVSEC_icDoc, {[] call ADVSEC_fnc_evOpen}, []] call _add;
    if ([_player, "suspicionView"] call ADVSEC_fnc_perm) then {
        ["advsec_ai_heat", "AA.II.: índice de sospecha", ADVSEC_icPol, {[] call ADVSEC_fnc_heatOpen}, []] call _add;
    };
    // Servicio, central, alerta, matrículas, radar, K9 y AA.II.
    ["advsec_pm_duty", ["Fichar ENTRADA de servicio", "Fichar SALIDA de servicio"] select (_player getVariable ["ADVSEC_onDuty", false]), ADVSEC_icJail, {["toggle", _player] remoteExecCall ["ADVSEC_fnc_dutyServer", 2]}, []] call _add;
    if (_player getVariable ["ADVSEC_onDuty", false]) then {
        ["advsec_pm_cam", ["Encender cámara corporal", "Apagar cámara corporal"] select (_player getVariable ["ADVSEC_bodycam", false]), ADVSEC_icCam, {["bodycam", _player] remoteExecCall ["ADVSEC_fnc_dutyServer", 2]}, []] call _add;
    };
    ["advsec_pm_dsp", "Central de despacho", ADVSEC_icAlarm, {[] call ADVSEC_fnc_dspOpen}, []] call _add;
    ["advsec_pm_panic", "BOTÓN DE PÁNICO", ADVSEC_icAlarm, {["panic", _player] remoteExecCall ["ADVSEC_fnc_dspServer", 2]}, []] call _add;
    if ([_player, "dutyView"] call ADVSEC_fnc_perm) then {["advsec_pm_dutyv", "Control de servicio", ADVSEC_icJail, {[] call ADVSEC_fnc_dutyOpen}, []] call _add};
    if ([_player, "alertLevel"] call ADVSEC_fnc_perm) then {["advsec_pm_alert", "Nivel de alerta de la base", ADVSEC_icAlarm, {[] call ADVSEC_fnc_alertOpen}, []] call _add};
    if ([_player, "plateQuery"] call ADVSEC_fnc_perm) then {["advsec_pm_plate", "Consultar matrícula", ADVSEC_icCar, {[] call ADVSEC_fnc_plateQuery}, []] call _add};
    if ([_player, "radar"] call ADVSEC_fnc_perm) then {["advsec_pm_radar", "Radar de velocidad (apunta)", ADVSEC_icCar, {[] call ADVSEC_fnc_radarUse}, []] call _add};
    if ([_player, "k9"] call ADVSEC_fnc_perm) then {
        ["advsec_pm_k9", ["K9: llamar al perro", "K9: retirar al perro"] select !isNull (_player getVariable ["ADVSEC_k9", objNull]), ADVSEC_icSearch, {["toggle", _player] remoteExecCall ["ADVSEC_fnc_k9Server", 2]}, []] call _add;
        if (!isNull (_player getVariable ["ADVSEC_k9", objNull])) then {
            ["advsec_pm_sniff", "K9: olfatear lo que apuntas", ADVSEC_icSearch, {["sniff", _player, [cursorObject]] remoteExecCall ["ADVSEC_fnc_k9Server", 2]}, []] call _add;
        };
    };
    if ([_player, "suspend"] call ADVSEC_fnc_perm) then {["advsec_ai_susp", "AA.II.: suspensiones", ADVSEC_icPol, {[] call ADVSEC_fnc_susOpen}, []] call _add};
    if ([_player, "bankAudit"] call ADVSEC_fnc_perm) then {["advsec_ai_bank", "AA.II.: auditoría bancaria", ADVSEC_icSearch, {[] call ADVSEC_fnc_auditOpen}, []] call _add};
    if ([_player, "bodycamView"] call ADVSEC_fnc_perm) then {["advsec_ai_cam", "AA.II.: cámaras corporales", ADVSEC_icCam, {[] call ADVSEC_fnc_bodyOpen}, []] call _add};
    if ([_player, "playerDB"] call ADVSEC_fnc_perm) then {
        ["advsec_pm_playerdb", "Base de datos de jugadores", ADVSEC_icDoc, {[] call ADVSEC_fnc_pdbOpen}, []] call _add;
    };
    _list
};
if (!alive _target) exitWith {_list};

private _r = [_target] call ADVSEC_fnc_isRestrained;
private _surr = (_target getVariable ["ace_captives_isSurrendering", false]) || {"surrender" in toLower animationState _target};
private _inVeh = !isNull objectParent _target;

if (_r) then {
    ["advsec_pm_free", "Quitar esposas", ADVSEC_icPol, {[_target, false, _player] call ADVSEC_fnc_restrain}, []] call _add;
    if (!_inVeh && {_mode == "unit"}) then {
        if ((attachedTo _target) isEqualTo _player) then {
            ["advsec_pm_escoff", "Dejar de escoltar", ADVSEC_icRun, {[_target, false] call ADVSEC_fnc_escort}, []] call _add;
        } else {
            ["advsec_pm_esc", "Escoltar", ADVSEC_icRun, {[_target, true] call ADVSEC_fnc_escort}, []] call _add;
        };
    };
    if (_inVeh) then {
        ["advsec_pm_out", "Sacar del vehículo", ADVSEC_icCar, {[_target, "unload"] call ADVSEC_fnc_policeLocal}, []] call _add;
    } else {
        ["advsec_pm_load", "Meter en vehículo", ADVSEC_icCar, {[_target] call ADVSEC_fnc_policeLoad}, []] call _add;
    };
} else {
    ["advsec_pm_cuff", "Esposar", ADVSEC_icPol, {[_target, true, _player] call ADVSEC_fnc_restrain}, []] call _add;
};
if ((_r || {_surr} || {_mode == "zeus"}) && {[_player, "search"] call ADVSEC_fnc_perm}) then {
    ["advsec_pm_search", "Registrar (cacheo)", ADVSEC_icSearch, {[_target] call ADVSEC_fnc_searchOpen}, []] call _add;
};
if ((_target getVariable ["ADVSEC_jailUntil", 0]) > serverTime) then {
    ["advsec_pm_release", "Poner en libertad", ADVSEC_icRun, {["release", _player, [_target]] remoteExecCall ["ADVSEC_fnc_jailServer", 2]}, []] call _add;
} else {
    if ((_r || {_mode == "zeus"}) && {(missionNamespace getVariable ["ADVSEC_jails", []]) isNotEqualTo []}) then {
        ["advsec_pm_jail", "Arrestar / encarcelar", ADVSEC_icJail, {[_target] call ADVSEC_fnc_jailPrompt}, []] call _add;
    };
};
if (isPlayer _target) then {
    if ((getPlayerUID _target) in (missionNamespace getVariable ["ADVSEC_wantedUIDs", []])) then {
        ["advsec_pm_unwant", "Retirar de buscados", ADVSEC_icPol, {["del", _player, [getPlayerUID _target]] remoteExecCall ["ADVSEC_fnc_wantedServer", 2]}, []] call _add;
    } else {
        ["advsec_pm_want", "Declarar buscado", ADVSEC_icPol, {[_target] call ADVSEC_fnc_wantedPrompt}, []] call _add;
    };
};
if (isPlayer _target && {[_player, "licenseRevoke"] call ADVSEC_fnc_perm}) then {
    ["advsec_pm_lic", "Retirar licencia", ADVSEC_icDoc, {[_target] call ADVSEC_fnc_licRevokePrompt}, []] call _add;
};
if ([_player, "fine"] call ADVSEC_fnc_perm) then {
    ["advsec_pm_fine", "Multar", ADVSEC_icDoc, {[_target] call ADVSEC_fnc_finePrompt}, []] call _add;
};
["advsec_pm_qry", "Consultar antecedentes", ADVSEC_icSearch, {[_target] call ADVSEC_fnc_queryOpen}, []] call _add;
["advsec_pm_docs", "Solicitar documentación", ADVSEC_icDoc, {[_target] call ADVSEC_fnc_docListOpen}, []] call _add;
["advsec_pm_inc", "Registrar incidente", ADVSEC_icDoc, {["PM", format ["%1 [%2]", name _target, getPlayerUID _target]] call ADVSEC_fnc_repEditorOpen}, []] call _add;
_list
