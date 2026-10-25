/*
    Registra los ajustes en Opciones > Opciones de complementos (CBA). Sin CBA no hace nada y se usan description.ext y el addon.
    El valor por defecto de cada ajuste es el de la misión (o el del addon), así que CBA solo pisa lo que el admin cambie.
    Todos son globales: los fija el servidor/administrador y se sincronizan a los clientes.
*/
if (!isClass (configFile >> "CfgPatches" >> "cba_settings") || {isNil "CBA_fnc_addSetting"}) exitWith {};
private _cat = "Advanced Security Systems";
// [variable, tipo, título, descripción, subcategoría, datos]
private _add = {
    params ["_var", "_type", "_title", "_tip", "_sub", "_data", ["_restart", false]];
    ["ADVSEC_cba_" + _var, _type, [_title, _tip], [_cat, _sub], _data, 1, {}, _restart] call CBA_fnc_addSetting;
};
private _num = {params ["_path", "_def"]; [_path, _def] call ADVSEC_fnc_setting};
private _mis = {params ["_name", "_def"]; getMissionConfigValue ["ADVSEC_" + _name, _def]};
private _bool = {(_this isEqualTo 1) || {_this isEqualTo true}};

// --- General
["saveInterval", "SLIDER", "Guardado a disco (s)", "Cada cuántos segundos se escriben los datos del servidor en el perfil.", "1 · General", [15, 600, ["saveInterval", 60] call _mis, 0]] call _add;
["logMax", "SLIDER", "Tamaño del registro de eventos", "Máximo de eventos guardados (auditoría).", "1 · General", [500, 50000, ["logMax", 5000] call _mis, 0]] call _add;
["uiBlur", "CHECKBOX", "Desenfoque tras los menús", "Difumina el fondo al abrir ventanas del mod.", "1 · General", (["uiBlur", 1] call _mis) call _bool] call _add;
["reportsSelfAction", "CHECKBOX", "Acción propia «Informes PM / AA.II.»", "Muestra el acceso a informes en el menú propio.", "1 · General", (["reportsSelfAction", 1] call _mis) call _bool] call _add;
["pdaGrantsAccess", "CHECKBOX", "La PDA basta para acceder", "Llevar la PDA da acceso sin placa ni credencial.", "1 · General", (["pdaGrantsAccess", 0] call _mis) call _bool] call _add;

// --- Documentos
["autoMilitaryID", "CHECKBOX", "ID militar automático", "Entrega una identificación militar ligada al SteamID en cada aparición.", "2 · Documentos", (["autoMilitaryID", 1] call _mis) call _bool] call _add;
["militaryIssuer", "EDITBOX", "Emisor del ID militar", "Texto del emisor en la identificación automática.", "2 · Documentos", ["militaryIssuer", "Estado Mayor"] call _mis] call _add;
["militaryClearance", "SLIDER", "Nivel del ID militar", "Nivel de acceso de la identificación automática.", "2 · Documentos", [0, 5, ["militaryClearance", 1] call _mis, 0]] call _add;

// --- Policía Militar
["breachItem", "EDITBOX", "Objeto para forzar cerraduras", "Clase del objeto necesario (p. ej. ToolKit).", "3 · Policía Militar", ["breachItem", "ToolKit"] call _mis] call _add;
["breachTime", "SLIDER", "Tiempo para forzar (s)", "", "3 · Policía Militar", [3, 120, ["breachTime", 20] call _mis, 0]] call _add;
["hiddenFindChance", "SLIDER", "Prob. de hallar objetos escondidos en la ropa", "", "3 · Policía Militar", [0, 1, [["hiddenFindChance"], 0.75] call _num, 2]] call _add;
["stashFindChance", "SLIDER", "Prob. de hallar el doble fondo de un vehículo", "", "3 · Policía Militar", [0, 1, [["stashFindChance"], 0.5] call _num, 2]] call _add;
["queryNeedsRadio", "CHECKBOX", "La consulta a la central exige radio", "TFAR / ACRE si están cargados; si no, la radio normal.", "3 · Policía Militar", ([["queryNeedsRadio"], 1] call _num) call _bool] call _add;
["queryDelay", "SLIDER", "Espera de la central (s)", "", "3 · Policía Militar", [0, 30, [["queryDelay"], 3] call _num, 0]] call _add;

// --- Rangos y permisos (rango mínimo 0-5; 0 = cualquiera del cuerpo)
private _names = createHashMapFromArray [
    ["restrain", "Esposar"], ["search", "Cachear"], ["seize", "Incautar"], ["vehicleSearch", "Registrar vehículos"],
    ["evidenceCollect", "Recoger pruebas"], ["query", "Consultar la central"], ["fine", "Multar"], ["fineCancel", "Anular multas"],
    ["wanted", "Gestionar buscados"], ["arrest", "Arrestar"], ["release", "Liberar"], ["evidenceAnalyze", "Analizar pruebas"],
    ["reportStatus", "Cambiar estado de informes"], ["revokeDoc", "Revocar documentos"], ["caseClose", "AA.II.: cerrar expedientes"],
    ["suspicionView", "AA.II.: ver índice de sospecha"], ["evidenceTamper", "AA.II.: alterar pruebas"], ["evidenceAudit", "AA.II.: auditoría forense"],
    ["playerDB", "Base de datos de jugadores"], ["rankPM", "Asignar rangos PM"], ["rankAI", "AA.II.: asignar rangos"], ["rankGlobal", "Asignar rangos globales"], ["treasury", "Tesorería de la PM"], ["dutyView", "Control de servicio"], ["dispatch", "Central de despacho"], ["suspend", "AA.II.: suspender agentes"], ["alertLevel", "Nivel de alerta"], ["plateQuery", "Consultar matrículas"], ["licenseRevoke", "Retirar licencias"], ["bankAudit", "AA.II.: auditoría bancaria"], ["bankFreeze", "AA.II.: congelar cuentas"], ["k9", "Unidad canina"], ["radar", "Radar de velocidad"], ["bodycamView", "AA.II.: cámaras corporales"]
];
{
    private _c = _x;
    private _a = configName _c;
    private _def = (getArray _c) param [1, 1];
    private _m = missionConfigFile >> "ADVSEC_Settings" >> "Permissions" >> _a;
    if (isArray _m) then {_def = (getArray _m) param [1, _def]};
    ["perm_" + _a, "SLIDER", format ["Rango mínimo: %1", _names getOrDefault [_a, _a]], format ["Cuerpo: %1", (getArray _c) param [0, "PM"]], "4 · Rangos y permisos", [0, 5, _def, 0]] call _add;
} forEach (configProperties [configFile >> "ADVSEC_Settings" >> "Permissions", "isArray _x", true]);
["globalRankSetUnit", "CHECKBOX", "El rango global cambia el rango de Arma", "Aplica setUnitRank según ranksGlobalArma al asignar un rango global.", "4 · Rangos y permisos", ([["globalRankSetUnit"], 1] call _num) call _bool] call _add;

// --- Evidencias
["evidenceTTL", "SLIDER", "Duración de las pruebas en el suelo (s)", "", "5 · Evidencias", [60, 14400, [["evidenceTTL"], 3600] call _num, 0]] call _add;
["casingEvery", "SLIDER", "Casquillo registrado cada N disparos", "", "5 · Evidencias", [1, 30, [["casingEvery"], 4] call _num, 0]] call _add;
["printChance", "SLIDER", "Prob. de dejar huella", "", "5 · Evidencias", [0, 1, [["printChance"], 0.8] call _num, 2]] call _add;
["gloveChance", "SLIDER", "Prob. de dejar huella con guantes", "", "5 · Evidencias", [0, 1, [["gloveChance"], 0.15] call _num, 2]] call _add;
["labTime", "SLIDER", "Tiempo de análisis (s)", "", "5 · Evidencias", [5, 900, [["labTime"], 90] call _num, 0]] call _add;
["auditTime", "SLIDER", "Tiempo de auditoría forense (s)", "", "5 · Evidencias", [5, 300, [["auditTime"], 25] call _num, 0]] call _add;
["sceneRadius", "SLIDER", "Radio de inspección de escena (m)", "", "5 · Evidencias", [3, 60, [["sceneRadius"], 15] call _num, 0]] call _add;

// --- Asuntos Internos
["heatThreshold", "SLIDER", "Umbral de expediente automático", "Puntos de sospecha que abren un F-AI-01.", "6 · Asuntos Internos", [5, 300, [["heatThreshold"], 30] call _num, 0]] call _add;
["heatDecay", "SLIDER", "Pérdida de sospecha cada 10 min", "", "6 · Asuntos Internos", [0, 20, [["heatDecay"], 1] call _num, 0]] call _add;
private _rules = createHashMapFromArray [
    ["restrainNoCause", "esposar sin motivo"], ["arrestNoCause", "arrestar sin motivo"], ["arrestNoReport", "arrestar sin acta"],
    ["hitRestrained", "herir a un esposado"], ["earlyRelease", "liberar antes de tiempo"], ["wantedRemovedByOther", "retirar un buscado ajeno"],
    ["ownCaseAccess", "consultar su propio expediente"], ["evidenceTamper", "manipular pruebas"], ["fineCancelled", "anular una multa ajena"], ["bribe", "aceptar un soborno"], ["suspiciousMoney", "movimiento de dinero sospechoso"], ["bodycamOff", "apagar la cámara corporal"]
];
{
    ["Rules_" + configName _x, "SLIDER", format ["Sospecha por %1", _rules getOrDefault [configName _x, configName _x]], "", "6 · Asuntos Internos", [0, 100, [["Rules", configName _x], getNumber _x] call _num, 0]] call _add;
} forEach (configProperties [configFile >> "ADVSEC_Settings" >> "Rules", "isNumber _x", true]);

// --- Multas
["currency", "EDITBOX", "Moneda", "", "7 · Multas", [["currency"], "€"] call _num] call _add;
["moneyVar", "EDITBOX", "Variable de dinero del jugador", "Vacío = pago manual ante un agente.", "7 · Multas", [["moneyVar"], ""] call _num] call _add;
["fineWantedThreshold", "SLIDER", "Deuda que añade a buscados (0 = nunca)", "", "7 · Multas", [0, 100000, [["fineWantedThreshold"], 0] call _num, 0]] call _add;

// --- Economía
["economy", "CHECKBOX", "Economía de ADVSEC", "Efectivo, banco, nóminas, cajeros y tiendas. Compatible con el HUD THUD (variable moneyX).", "9 · Economía", ([["economy"], 1] call _num) call _bool] call _add;
["startCash", "SLIDER", "Efectivo inicial", "", "9 · Economía", [0, 100000, [["startCash"], 500] call _num, 0]] call _add;
["startBank", "SLIDER", "Banco inicial", "", "9 · Economía", [0, 1000000, [["startBank"], 2000] call _num, 0]] call _add;
["salaryInterval", "SLIDER", "Minutos entre nóminas (0 = sin nóminas)", "", "9 · Economía", [0, 240, [["salaryInterval"], 30] call _num, 0]] call _add;
["salaryBase", "SLIDER", "Nómina base", "Más el plus por rango PM, AA.II. y global.", "9 · Economía", [0, 10000, [["salaryBase"], 100] call _num, 0]] call _add;
["salaryFromTreasury", "CHECKBOX", "Las nóminas salen de la tesorería", "", "9 · Economía", ([["salaryFromTreasury"], 0] call _num) call _bool] call _add;
["fineToTreasury", "CHECKBOX", "Las multas van a la tesorería de la PM", "", "9 · Economía", ([["fineToTreasury"], 1] call _num) call _bool] call _add;
["shopToTreasury", "CHECKBOX", "Las compras van a la tesorería de la PM", "", "9 · Economía", ([["shopToTreasury"], 0] call _num) call _bool] call _add;
["sellFactor", "SLIDER", "Parte del precio al vender", "", "9 · Economía", [0, 1, [["sellFactor"], 0.5] call _num, 2]] call _add;
["atmAnywhere", "CHECKBOX", "Banco sin cajero", "Ingresar, retirar y transferir desde cualquier sitio.", "9 · Economía", ([["atmAnywhere"], 0] call _num) call _bool] call _add;
["thudCompat", "CHECKBOX", "Compatibilidad con el HUD THUD", "Publica tesorería, agentes y jefe (resourcesFIA, hr, theBoss) fuera de Antistasi.", "9 · Economía", ([["thudCompat"], 1] call _num) call _bool] call _add;

// --- Control de carretera
["checkpointFine", "SLIDER", "Multa por ir sin documentación", "", "8 · Control de carretera", [0, 10000, [["checkpointFine"], 150] call _num, 0]] call _add;
["checkpointSearchChance", "SLIDER", "Prob. de registrar el vehículo", "", "8 · Control de carretera", [0, 1, [["checkpointSearchChance"], 1] call _num, 2]] call _add;
["checkpointPapersTime", "SLIDER", "Tiempo revisando documentación (s)", "", "8 · Control de carretera", [2, 60, [["checkpointPapersTime"], 8] call _num, 0]] call _add;
["checkpointVehicleTime", "SLIDER", "Tiempo registrando el vehículo (s)", "", "8 · Control de carretera", [2, 120, [["checkpointVehicleTime"], 15] call _num, 0]] call _add;
["checkpointUnits", "SLIDER", "Agentes que crea un control", "", "8 · Control de carretera", [0, 8, [["checkpointUnits"], 2] call _num, 0]] call _add;
["checkpointSide", "LIST", "Bando de los agentes creados", "", "8 · Control de carretera", [["west", "east", "independent", "civilian"], ["BLUFOR", "OPFOR", "Independiente", "Civil"], (["west", "east", "independent", "civilian"] find toLower ([["checkpointSide"], "west"] call _num)) max 0]] call _add;
["checkpointExemptPM", "CHECKBOX", "No parar a la PM / admins / Zeus", "", "8 · Control de carretera", ([["checkpointExemptPM"], 0] call _num) call _bool] call _add;
