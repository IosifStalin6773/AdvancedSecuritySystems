# ADVSEC 1.12.0 · Sistema de rol militar

## 1. Estructura de archivos
```
addons/main/functions/
  spec/  specApply · specDB · specLocal · specName · specOpen · specPda · specServer
  duty/  dutyDB · dutyOpen · dutyServer · dutySet · dutyTermInit · moduleDuty
  dispatch/  dspCall · dspMark · dspNotify · dspOpen · dspServer
  aimod/  susOpen · susServer
  alert/  alertHint · alertOpen · alertServer
  plates/  dealerInit · dealerOpen · moduleDealer · plateDB · plateMine · plateQuery · plateServer
  licenses/  licOpen · licRevokePrompt · licServer · wpnDB · wpnRegister · wpnSerial
  k9/  k9Server
  radar/  radarUse
  bodycam/  bodyDB · bodyOpen · bodyServer
  discord/  discord · jsonEsc
  economy/  atmInit · auditOpen · bribeAsk · bribeOffer · ecoA3A · ecoAI · ecoAcc · ecoCash · ecoCharge · ecoClient · ecoDB · ecoFlag · ecoGiveItem · ecoHist · ecoItemName · ecoItemPic · ecoLoop · ecoOn · ecoOpen · ecoPublish · ecoPush · ecoSalary · ecoServer · ecoSetCash · ecoShopOpen · ecoTakeItem · ecoTreasury · ecoTreasuryOpen · moduleAtm · moduleShop · shopInit
  core/  utcMin · uidUnit · rpInit (+ ganchos en logEvent, keypadServer, evidenceServer, fineServer, searchAction)
addons/main/CfgSettings.hpp   ADVSEC_Settings (ajustes) · ADVSEC_Specialties · ADVSEC_Ranks · ADVSEC_Keys
addons/main/CfgDocuments.hpp  WeaponLicense · DriverLicense · PilotLicense
addons/thud/config.cpp        compatibilidad THUD (textos de rango y etiquetas)
examples/description.ext      CfgRemoteExec (lista blanca) · CfgORBAT
```

## 2. Funciones clave (firma)
```sqf
ADVSEC_fnc_specApply  // [unidad] (servidor): publica sus especialidades (ADVSEC_specs) y aplica rasgos de Arma y ACE
ADVSEC_fnc_specDB  // (servidor) -> hashmap especialidad -> [miembros [uid], encargados [uid], solicitudes [[uid, nombre, fecha]], historial]
ADVSEC_fnc_specLocal  // [[[rasgo, bool], ...]] (donde la unidad es local): rasgos de la especialidad
ADVSEC_fnc_specName  // [id] -> nombre de la especialidad
ADVSEC_fnc_specOpen  // Lista de especialidades: abrir su PDA, solicitar ingreso o darse de baja
ADVSEC_fnc_specPda  // [especialidad] — PDA genérica de una metopa (lista, solicitudes, altas y bajas; parametrizada por especialidad)
ADVSEC_fnc_specServer  // [acción, llamador, args] (servidor) — especialidades (metopas)
ADVSEC_fnc_dutyDB  // (servidor) -> hashmap SteamID -> [minutos totales, nombre, turnos [[inicio, fin, minutos], ...]]
ADVSEC_fnc_dutyOpen  // Control de servicio: horas por agente (permiso dutyView)
ADVSEC_fnc_dutyServer  // [acción, llamador, args] (servidor) — "toggle" [terminal] · "list" · "bodycam" (alternar)
ADVSEC_fnc_dutySet  // [unidad, deServicio] (servidor): ficha entrada/salida, suma las horas y enciende/apaga la cámara corporal
ADVSEC_fnc_dutyTermInit  // [objeto, nombre] — terminal de fichaje (init del objeto, todas las máquinas)
ADVSEC_fnc_moduleDuty  params ["_logic", "", ["_activated", true]];
ADVSEC_fnc_dspCall  // Llamada al 112 (cualquier jugador)
ADVSEC_fnc_dspMark  // [id, posición, pánico] (cliente): marcador local que se borra a los 10 min
ADVSEC_fnc_dspNotify  // [id, título, texto, posición, pánico] (cliente PM): aviso en pantalla y marca en el mapa durante 10 min
ADVSEC_fnc_dspOpen  // Central de despacho (PM): avisos 112 y pánicos
ADVSEC_fnc_dspServer  // [acción, llamador, args] (servidor) — central de despacho
ADVSEC_fnc_susOpen  // AA.II.: suspensiones temporales de agentes
ADVSEC_fnc_susServer  // [acción, llamador, args] (servidor) — suspensiones de AA.II.
ADVSEC_fnc_alertHint  // [texto estructurado] (clientes): aviso de cambio de alerta
ADVSEC_fnc_alertOpen  // Cambiar el nivel de alerta de la base (permiso alertLevel)
ADVSEC_fnc_alertServer  // ["set", llamador, [nivel]] (servidor) — nivel de alerta de la base: 0 verde · 1 amarillo · 2 rojo
ADVSEC_fnc_dealerInit  // [objeto, nombre, vehículos "clase:precio, ..." o [[clase, precio], ...]] — concesionario (init del objeto, todas las máquinas)
ADVSEC_fnc_dealerOpen  // [concesionario] — catálogo de vehículos
ADVSEC_fnc_moduleDealer  params ["_logic", "", ["_activated", true]];
ADVSEC_fnc_plateDB  // (servidor) -> hashmap matrícula -> [clase, SteamID dueño, nombre dueño, fecha, robado, netId]
ADVSEC_fnc_plateMine  // Mis vehículos: denunciar robo / recuperado
ADVSEC_fnc_plateQuery  // PM: consultar una matrícula (por defecto la del vehículo más cercano)
ADVSEC_fnc_plateServer  // [acción, llamador, args] (servidor) — concesionario y registro de matrículas
ADVSEC_fnc_licOpen  // [oficina] — comprar licencias y registrar armas
ADVSEC_fnc_licRevokePrompt  // [unidad] — PM: retirar una licencia
ADVSEC_fnc_licServer  // [acción, llamador, args] (servidor) — licencias de pago y registro de armas
ADVSEC_fnc_wpnDB  // (servidor) -> hashmap nº de serie -> [clase, SteamID titular, nombre titular, fecha]
ADVSEC_fnc_wpnRegister  // [unidad, clase] (servidor) -> nº de serie registrado a nombre de la unidad
ADVSEC_fnc_wpnSerial  // [SteamID, clase de arma] -> número de serie (el mismo que llevan sus casquillos)
ADVSEC_fnc_k9Server  // [acción, llamador, args] (servidor) — unidad canina
ADVSEC_fnc_radarUse  // Radar de velocidad (PM): mide el vehículo apuntado y ofrece multa directa si supera el límite
ADVSEC_fnc_bodyDB  // (servidor) -> hashmap SteamID -> [nombre, registros [[fecha, tipo, cuadrícula, datos], ...]] (150 últimos)
ADVSEC_fnc_bodyOpen  // AA.II.: cámaras corporales de los agentes
ADVSEC_fnc_bodyServer  // [acción, llamador, args] (servidor) — cámaras corporales: "list" · "view" [SteamID] (permiso bodycamView)
ADVSEC_fnc_discord  // [título, texto, color] (servidor) — aviso a Discord por webhook.
ADVSEC_fnc_jsonEsc  // [texto] -> texto escapado para JSON
ADVSEC_fnc_atmInit  // [objeto, nombre] — cajero automático (init del objeto, todas las máquinas)
ADVSEC_fnc_auditOpen  // AA.II.: movimientos sospechosos, auditoría y congelación de cuentas
ADVSEC_fnc_bribeAsk  // [sobornador, importe] (agente): aceptar o rechazar el dinero
ADVSEC_fnc_bribeOffer  // [agente] — ofrecer un soborno en efectivo
ADVSEC_fnc_ecoA3A  // -> bool: la misión es Antistasi (el efectivo moneyX lo gestiona Antistasi; ADVSEC solo añade banco, tiendas y nóminas)
ADVSEC_fnc_ecoAI  // [acción, llamador, args] (servidor) — corrupción y AA.II.
ADVSEC_fnc_ecoAcc  // [SteamID, nombre] (servidor) -> cuenta (la crea con el saldo inicial si no existe)
ADVSEC_fnc_ecoCash  // [unidad] (servidor) -> efectivo. En Antistasi manda la variable moneyX del jugador; si no, la cuenta del servidor.
ADVSEC_fnc_ecoCharge  // [unidad, importe, concepto, aTesorería] (servidor) -> bool
ADVSEC_fnc_ecoClient  // (cliente, al aparecer) Pide al servidor el saldo para que el HUD lo muestre.
ADVSEC_fnc_ecoDB  // (servidor) -> hashmap SteamID -> [efectivo, banco, nombre, historial [[fecha, texto, importe], ...]]
ADVSEC_fnc_ecoFlag  // [de [uid, nombre], a [uid, nombre], importe, tipo, forzar] (servidor)
ADVSEC_fnc_ecoGiveItem  // [clase, cantidad] (cliente que compra): mete el objeto en uniforme, chaleco o mochila; si no cabe, lo deja en el suelo
ADVSEC_fnc_ecoHist  // [cuenta, texto, importe] (servidor): apunta un movimiento (se guardan los 40 últimos)
ADVSEC_fnc_ecoItemName  // [clase] -> nombre visible (arma, objeto, cargador o mochila); "" si la clase no existe
ADVSEC_fnc_ecoItemPic  // [clase] -> icono del objeto ("" si no tiene)
ADVSEC_fnc_ecoLoop  // (servidor, programado) publica las variables del HUD cada 10 s y paga las nóminas
ADVSEC_fnc_ecoOn  // -> bool: economía de ADVSEC activa (ajuste economy)
ADVSEC_fnc_ecoOpen  // Cartera: efectivo, banco e historial; cajero (ingresar, retirar, transferir) y dar efectivo
ADVSEC_fnc_ecoPublish  // (servidor) Variables globales que lee el HUD THUD fuera de Antistasi:
ADVSEC_fnc_ecoPush  // [unidad] (servidor): crea la cuenta si hace falta y publica el efectivo y el banco en el jugador
ADVSEC_fnc_ecoSalary  // (servidor) Nómina a cada jugador conectado, ingresada en el banco:
ADVSEC_fnc_ecoServer  // [acción, llamador, args] (servidor) — economía.
ADVSEC_fnc_ecoSetCash  // [unidad, efectivo] (servidor): fija el efectivo y lo publica en el jugador (moneyX: lo lee el HUD THUD)
ADVSEC_fnc_ecoShopOpen  // [tienda] — catálogo: comprar (1 o 5) y vender
ADVSEC_fnc_ecoTakeItem  // [clase] (cliente que vende): retira una unidad del objeto vendido
ADVSEC_fnc_ecoTreasury  // [variación, concepto] (servidor) -> nuevo saldo de la tesorería de la PM
ADVSEC_fnc_ecoTreasuryOpen  // Tesorería de la PM: saldo, movimientos y primas a agentes (permiso treasury)
ADVSEC_fnc_moduleAtm  params ["_logic", "", ["_activated", true]];
ADVSEC_fnc_moduleShop  params ["_logic", "", ["_activated", true]];
ADVSEC_fnc_shopInit  // [objeto, nombre, artículos] — tienda (init del objeto, todas las máquinas)
```

## 3. Rangos (ADVSEC_Ranks) y especialidades
```cpp
    ranksGlobal[] = {"Sin rango", "Rct.", "Sdo.", "Sdo 1º.", "Cbo.", "Cbo 1º.", "Cbo M.", "Sgt.", "Sgt 1º.", "Sgt M.", "Brig.", "Tte.", "Cap."};
    ranksGlobalArma[] = {"", "PRIVATE", "PRIVATE", "PRIVATE", "CORPORAL", "CORPORAL", "CORPORAL", "SERGEANT", "SERGEANT", "SERGEANT", "LIEUTENANT", "CAPTAIN", "MAJOR"};

// Especialidades (metopas). traits: setUnitTrait · ace: variables de ACE en la unidad
class ADVSEC_Specialties {
    class JTAC { name = "JTAC"; };
    class RO { name = "Radio operador"; };
    class SAN { name = "Sanitario"; traits[] = {{"Medic", 1}}; ace[] = {{"ace_medical_medicClass", 1}}; };
    class MED { name = "Médico"; traits[] = {{"Medic", 1}}; ace[] = {{"ace_medical_medicClass", 2}}; };
    class AT { name = "Antitanque (AT)"; };
    class MG { name = "Ametrallador"; };
    class ENG { name = "Ingeniero"; traits[] = {{"Engineer", 1}}; ace[] = {{"ace_isEngineer", 2}}; };
    class EOD { name = "EOD (desactivación)"; traits[] = {{"ExplosiveSpecialist", 1}}; ace[] = {{"ace_isEOD", 1}, {"ace_isEngineer", 1}}; };
    class AA { name = "Antiaéreo (AA)"; };
    class GRN { name = "Granadero"; };
    class TANK { name = "Carrista"; };
    class PARA { name = "Paracaidista"; };
    class PILOT { name = "Piloto"; };
    class LOG { name = "Logística"; traits[] = {{"Engineer", 1}}; ace[] = {{"ace_isEngineer", 1}}; };
    class ART { name = "Artillería"; };
    class MRK { name = "Tirador"; };
};

// Rangos (capa de datos sobre CfgORBAT): índice = posición en ranksGlobal
class ADVSEC_Ranks {
    class R1 { abbr = "Rct."; name = "Recluta"; category = "Tropa"; arma = "PRIVATE"; };
    class R2 { abbr = "Sdo."; name = "Soldado"; category = "Tropa"; arma = "PRIVATE"; };
    class R3 { abbr = "Sdo 1º."; name = "Soldado primero"; category = "Tropa"; arma = "PRIVATE"; };
    class R4 { abbr = "Cbo."; name = "Cabo"; category = "Suboficial"; arma = "CORPORAL"; };
    class R5 { abbr = "Cbo 1º."; name = "Cabo primero"; category = "Suboficial"; arma = "CORPORAL"; };
    class R6 { abbr = "Cbo M."; name = "Cabo mayor"; category = "Suboficial"; arma = "CORPORAL"; };
    class R7 { abbr = "Sgt."; name = "Sargento"; category = "Suboficial"; arma = "SERGEANT"; };
    class R8 { abbr = "Sgt 1º."; name = "Sargento primero"; category = "Suboficial"; arma = "SERGEANT"; };
    class R9 { abbr = "Sgt M."; name = "Sargento mayor"; category = "Suboficial"; arma = "SERGEANT"; };
    class R10 { abbr = "Brig."; name = "Brigada"; category = "Oficial"; arma = "LIEUTENANT"; };
    class R11 { abbr = "Tte."; name = "Teniente"; category = "Oficial"; arma = "CAPTAIN"; };
    class R12 { abbr = "Cap."; name = "Capitán"; category = "Oficial"; arma = "MAJOR"; };
};
```

### CfgORBAT (description.ext de ejemplo)
```cpp
class CfgORBAT {
    class ADVSEC_Bn {
        id = 1; idType = 0; side = "West"; size = "Battalion"; type = "Infantry";
        insignia = ""; colorInsignia[] = {0, 0.3, 0.6, 1};
        commander = "Cap."; commanderRank = "MAJOR";
        text = "%1 Batallón"; textShort = "%1 Bn";
        description = "Mando: Cap. · Oficiales: Cap., Tte., Brig. · Suboficiales: Sgt M., Sgt 1º., Sgt., Cbo M., Cbo 1º., Cbo. · Tropa: Sdo 1º., Sdo., Rct.";
        class Mando { id = 1; idType = 0; side = "West"; size = "Platoon"; type = "HQ"; commander = "Tte."; commanderRank = "CAPTAIN"; text = "Plana mayor"; };
        class Fusileros { id = 1; idType = 0; side = "West"; size = "Company"; type = "Infantry"; commander = "Brig."; commanderRank = "LIEUTENANT"; text = "%1 Compañía";
            class S_MG { id = 1; idType = 0; side = "West"; size = "Squad"; type = "MotorizedInfantry"; commander = "Sgt."; commanderRank = "SERGEANT"; text = "Ametralladoras"; };
            class S_AT { id = 2; idType = 0; side = "West"; size = "Squad"; type = "Infantry"; commander = "Sgt."; commanderRank = "SERGEANT"; text = "Contracarro (AT)"; };
            class S_GRN { id = 3; idType = 0; side = "West"; size = "Squad"; type = "Infantry"; commander = "Cbo M."; commanderRank = "CORPORAL"; text = "Granaderos"; };
            class S_MRK { id = 4; idType = 0; side = "West"; size = "FireTeam"; type = "Recon"; commander = "Cbo 1º."; commanderRank = "CORPORAL"; text = "Tiradores"; };
        };
        class Apoyo { id = 2; idType = 0; side = "West"; size = "Company"; type = "Support"; commander = "Brig."; commanderRank = "LIEUTENANT"; text = "Compañía de apoyo";
            class S_JTAC { id = 1; idType = 0; side = "West"; size = "FireTeam"; type = "Recon"; commander = "Sgt 1º."; commanderRank = "SERGEANT"; text = "JTAC"; };
            class S_RO { id = 2; idType = 0; side = "West"; size = "FireTeam"; type = "HQ"; commander = "Sgt."; commanderRank = "SERGEANT"; text = "Transmisiones (RO)"; };
            class S_MED { id = 3; idType = 0; side = "West"; size = "Squad"; type = "Medical"; commander = "Sgt 1º."; commanderRank = "SERGEANT"; text = "Sanidad (Sanitarios / Médicos)"; };
            class S_ENG { id = 4; idType = 0; side = "West"; size = "Squad"; type = "Engineers"; commander = "Sgt."; commanderRank = "SERGEANT"; text = "Ingenieros y EOD"; };
            class S_AA { id = 5; idType = 0; side = "West"; size = "Squad"; type = "AntiAir"; commander = "Sgt."; commanderRank = "SERGEANT"; text = "Antiaérea (AA)"; };
            class S_ART { id = 6; idType = 0; side = "West"; size = "Squad"; type = "Artillery"; commander = "Sgt M."; commanderRank = "SERGEANT"; text = "Artillería"; };
            class S_LOG { id = 7; idType = 0; side = "West"; size = "Squad"; type = "Maintenance"; commander = "Sgt."; commanderRank = "SERGEANT"; text = "Logística"; };
        };
        class Especiales { id = 3; idType = 0; side = "West"; size = "Company"; type = "Infantry"; commander = "Brig."; commanderRank = "LIEUTENANT"; text = "Unidades especiales";
            class S_TANK { id = 1; idType = 0; side = "West"; size = "Platoon"; type = "Armored"; commander = "Sgt 1º."; commanderRank = "SERGEANT"; text = "Carros (Tank)"; };
            class S_PARA { id = 2; idType = 0; side = "West"; size = "Platoon"; type = "Airborne"; commander = "Sgt 1º."; commanderRank = "SERGEANT"; text = "Paracaidistas"; };
            class S_PILOT { id = 3; idType = 0; side = "West"; size = "Squad"; type = "Helicopter"; commander = "Sgt M."; commanderRank = "SERGEANT"; text = "Pilotos"; };
        };
    };
};
```

## 4. PDA de especialidad (genérica, parametrizada)
```sqf
// [especialidad] — PDA genérica de una metopa (lista, solicitudes, altas y bajas; parametrizada por especialidad)
params ["_sp"];
ADVSEC_specCur = _sp;
private _send = {params ["_act", "_d"]; [_act, player, [ADVSEC_specCur, _d]] remoteExecCall ["ADVSEC_fnc_specServer", 2]};
ADVSEC_specSend = _send;
["spec_" + _sp, format ["PDA · %1", [_sp] call ADVSEC_fnc_specName], [
    ["Aceptar", {params ["_d"]; if (!isNil "_d" && {(_d select 0) == "app"}) then {["accept", _d select 1] call ADVSEC_specSend}}],
    ["Rechazar / baja", {params ["_d"]; if (!isNil "_d") then {[["remove", "reject"] select ((_d select 0) == "app"), _d select 1] call ADVSEC_specSend}}],
    ["Añadir jugador", {["ALTA EN LA ESPECIALIDAD", [["Jugador", objNull, "players"]], {params ["_v"]; ["add", _v select 0] call ADVSEC_specSend}] call ADVSEC_fnc_zeusPrompt}],
    ["Encargado sí / no", {params ["_d"]; if (!isNil "_d" && {(_d select 0) == "mem"}) then {["lead", _d select 1] call ADVSEC_specSend}}],
    ["Volver", {closeDialog 0; [] spawn {sleep 0.1; [] call ADVSEC_fnc_specOpen}}]
], {["view", player, [ADVSEC_specCur]] remoteExecCall ["ADVSEC_fnc_specServer", 2]}] call ADVSEC_fnc_panelOpen;
```
```sqf
/*
    [acción, llamador, args] (servidor) — especialidades (metopas)
    "list" · "view" [esp] · "apply" [esp] · "leave" [esp] · "accept" [esp, uid] · "reject" [esp, uid]
    "add" [esp, unidad] · "remove" [esp, uid] · "lead" [esp, uid] (alternar encargado; solo superadministradores)
*/
params ["_action", "_caller", ["_args", []]];
if (!isServer) exitWith {};
if !([_caller] call ADVSEC_fnc_srvCaller) exitWith {};
private _db = [] call ADVSEC_fnc_specDB;
private _uid = getPlayerUID _caller;
private _say = {_this remoteExecCall ["hint", _caller]};
private _pdb = [] call ADVSEC_fnc_pdbDB;
private _nameOf = {params ["_k"]; ((_pdb getOrDefault [_k, []]) param [0, _k])};
_args params [["_sp", ""], "_who"];
private _e = _db getOrDefault [_sp, []];
private _admin = [_caller] call ADVSEC_fnc_adminIs;
private _canManage = _admin || {_e isNotEqualTo [] && {_uid in (_e select 1)}};
private _hist = {params ["_t"]; (_e select 3) pushBack [call ADVSEC_fnc_now, name _caller, _t]; if (count (_e select 3) > 60) then {(_e select 3) deleteAt 0}; ["spec"] call ADVSEC_fnc_dbDirty};
private _refresh = {
    private _u = [_this] call ADVSEC_fnc_uidUnit;
    if (!isNull _u) then {[_u] call ADVSEC_fnc_specApply};
};
if (_action != "list" && {_e isEqualTo []}) exitWith {};

switch (_action) do {
    case "list": {
        private _rows = [];
        {
            private _id = _x;
            _y params ["_m", "_l", "_a"];
            private _st = switch (true) do {
                case (_uid in _l): {"encargado"};
                case (_uid in _m): {"miembro"};
                case ((_a findIf {(_x select 0) isEqualTo _uid}) >= 0): {"solicitud enviada"};
                default {""};
            };
            _rows pushBack [format ["%1 · %2 miembros%3%4", [_id] call ADVSEC_fnc_specName, count _m, ["", format [" · %1 solicitudes", count _a]] select (_a isNotEqualTo [] && {_uid in _l || _admin}), ["", " · " + toUpper _st] select (_st isNotEqualTo "")], _id,
                format ["<t size='1.15' font='RobotoCondensedBold'>%1</t><br/>Miembros: %2<br/>Encargados: %3<br/>Tu situación: %4", [_id] call ADVSEC_fnc_specName, count _m, ((_l apply {[_x] call _nameOf}) joinString ", ") call ADVSEC_fnc_repEsc, ["sin relación", _st] select (_st isNotEqualTo "")],
                [[], [0.82, 0.64, 0.19, 1], [0.45, 1, 0.45, 1]] select (([_st == "encargado", _st == "miembro"] find true) + 1), ""];
        } forEach _db;
        ["specs", "Selecciona una especialidad: «Abrir PDA» para ver su lista o «Solicitar ingreso».", _rows] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
    };
    case "view": {
        _e params ["_m", "_l", "_a"];
        if (!_canManage && {!(_uid in _m)}) exitWith {"Solo los miembros y encargados ven la lista." call _say};
        private _rows = [];
        {_rows pushBack [format ["SOLICITUD · %1 · %2", _x select 1, _x select 2], ["app", _x select 0], format ["<t font='RobotoCondensedBold'>%1</t><br/>SteamID: %2<br/>Solicitada: %3<br/><t color='#8C8C8C'>«Aceptar» le da de alta; «Rechazar / baja» la descarta.</t>", (_x select 1) call ADVSEC_fnc_repEsc, _x select 0, _x select 2], [1, 0.75, 0.3, 1], ""]} forEach _a;
        {
            private _on = !isNull ([_x] call ADVSEC_fnc_uidUnit);
            private _g = (_pdb getOrDefault [_x, []]) param [7, 0];
            _rows pushBack [format ["%1%2 · %3%4", ["", "★ "] select (_x in _l), [_x] call _nameOf, [7, _g] call ADVSEC_fnc_pdbRankName, ["", " · en línea"] select _on], ["mem", _x],
                format ["<t font='RobotoCondensedBold'>%1</t><br/>SteamID: %2<br/>Rango: %3<br/>%4%5", ([_x] call _nameOf) call ADVSEC_fnc_repEsc, _x, [7, _g] call ADVSEC_fnc_pdbRankName, ["Miembro", "Encargado de la especialidad"] select (_x in _l), ["", "<br/><t color='#66FF66'>EN LÍNEA</t>"] select _on],
                [[], [0.82, 0.64, 0.19, 1]] select (_x in _l), ""];
        } forEach _m;
        ["spec_" + _sp, format ["<t size='1.1' font='RobotoCondensedBold'>%1</t> · %2 miembros · %3 solicitudes%4", [_sp] call ADVSEC_fnc_specName, count _m, count _a, ["<br/><t color='#8C8C8C'>Solo lectura: no eres encargado.</t>", ""] select _canManage], _rows] remoteExecCall ["ADVSEC_fnc_panelSet", _caller];
    };
    case "apply": {
        if (_uid in (_e select 0)) exitWith {"Ya perteneces a esa especialidad." call _say};
        if (((_e select 2) findIf {(_x select 0) isEqualTo _uid}) >= 0) exitWith {"Ya tienes una solicitud pendiente." call _say};
        (_e select 2) pushBack [_uid, name _caller, call ADVSEC_fnc_now];
        ["Solicitud de ingreso"] call _hist;
        {(format ["%1 solicita entrar en %2.", name _caller, [_sp] call ADVSEC_fnc_specName]) remoteExecCall ["hint", _x]} forEach ((_e select 1) apply {[_x] call ADVSEC_fnc_uidUnit} select {!isNull _x});
        "Solicitud enviada a los encargados." call _say;
        ["list", _caller] call ADVSEC_fnc_specServer;
    };
    case "leave": {
        _e set [2, (_e select 2) select {(_x select 0) isNotEqualTo _uid}];
        _e set [0, (_e select 0) - [_uid]];
        _e set [1, (_e select 1) - [_uid]];
        ["Baja voluntaria"] call _hist;
        [_caller] call ADVSEC_fnc_specApply;
        ["list", _caller] call ADVSEC_fnc_specServer;
    };
    case "accept";
    case "reject";
    case "remove";
    case "add";
    case "lead": {
        if (!_canManage) exitWith {[_caller, format ["gestionar la especialidad %1", _sp]] call ADVSEC_fnc_deny};
        private _t = if (_action == "add") then {if (_who isEqualType objNull && {!isNull _who}) then {getPlayerUID _who} else {""}} else {_who};
        if !(_t isEqualType "") exitWith {};
        if (_t isEqualTo "") exitWith {};
        switch (_action) do {
            case "accept";
            case "add": {
                _e set [2, (_e select 2) select {(_x select 0) isNotEqualTo _t}];
                (_e select 0) pushBackUnique _t;
                [format ["Alta de %1", [_t] call _nameOf]] call _hist;
            };
            case "reject";
            case "remove": {
                _e set [2, (_e select 2) select {(_x select 0) isNotEqualTo _t}];
                _e set [0, (_e select 0) - [_t]];
                if (_admin) then {_e set [1, (_e select 1) - [_t]]};
                [format ["Baja de %1", [_t] call _nameOf]] call _hist;
            };
            case "lead": {
                if (!_admin) exitWith {"Solo un superadministrador nombra encargados." call _say};
                if (_t in (_e select 1)) then {_e set [1, (_e select 1) - [_t]]} else {(_e select 1) pushBack _t; (_e select 0) pushBackUnique _t};
                [format ["Encargado: %1", [_t] call _nameOf]] call _hist;
            };
        };
        ["specChange", _caller, [_sp, _action, _t]] call ADVSEC_fnc_logEvent;
        _t call _refresh;
        ["view", _caller, [_sp]] call ADVSEC_fnc_specServer;
    };
};
```

## 5. Webhook de Discord
```sqf
/*
    [título, texto, color] (servidor) — aviso a Discord por webhook.
    SUPOSICIÓN: Arma no hace HTTP; se usa la extensión de servidor discordExtension con callExtension [url, json] (p. ej. un build de DiscordEmbedBuilder / webhook genérico). Sin extensión no hace nada.
*/
params ["_title", "_text", ["_color", 13672496]];
if (!isServer) exitWith {};
private _url = ["discordWebhook", ""] call ADVSEC_fnc_setting;
if (_url isEqualTo "") exitWith {};
private _json = format ['{"username":"ADVSEC","embeds":[{"title":"%1","description":"%2","color":%3,"footer":{"text":"%4 · %5"}}]}',
    [_title] call ADVSEC_fnc_jsonEsc, [_text] call ADVSEC_fnc_jsonEsc, _color, [missionName] call ADVSEC_fnc_jsonEsc, call ADVSEC_fnc_now];
private _r = (["discordExtension", "DiscordEmbedBuilder"] call ADVSEC_fnc_setting) callExtension [_url, [_json]];
if ((_r select 1) != 0 || {(_r select 2) != 0}) then {diag_log format ["[ADVSEC] Discord: la extensión devolvió %1", _r]};
```

## 6. Compatibilidad THUD (addon advsec_thud)
```cpp
// Compatibilidad ADVSEC <-> HUD THUD: solo cambia textos de THUD; si THUD no está cargado, Arma ignora este addon.
// THUD lee el rango de Arma (rank): ADVSEC lo fija con ranksGlobalArma; aquí se le da el nombre de rango de la unidad.
class CfgPatches {
    class advsec_thud {
        name = "Advanced Security Systems - THUD";
        author = "oscar";
        requiredVersion = 2.14;
        requiredAddons[] = {"THUD_Antistasi", "AdvancedSecuritySystems"};
        skipWhenMissingDependencies = 1;
        units[] = {};
        weapons[] = {};
    };
};
#define ADVSEC_THUD_TEXTS \
    hr = "PM"; money = "Dinero"; treasury = "Tesorería %1"; boss = "Mando"; bossYou = "Tú"; \
    warLevel = "NIVEL DE ALERTA:"; warLevelC = "Alerta:"; \
    rank_PRIVATE = "TROPA"; rank_CORPORAL = "CABO"; rank_SERGEANT = "SARGENTO"; \
    rank_LIEUTENANT = "BRIGADA"; rank_CAPTAIN = "TENIENTE"; rank_MAJOR = "CAPITÁN"; rank_COLONEL = "CAPITÁN"; \
    rankc_PRIVATE = "Tropa"; rankc_CORPORAL = "Cabo"; rankc_SERGEANT = "Sargento"; \
    rankc_LIEUTENANT = "Brigada"; rankc_CAPTAIN = "Teniente"; rankc_MAJOR = "Capitán"; rankc_COLONEL = "Capitán";
class THUD_Settings {
    class Texts { ADVSEC_THUD_TEXTS };
    class TextsEN { ADVSEC_THUD_TEXTS };
};
```

> THUD lee `rank` (7 rangos de Arma), `moneyX`, `resourcesFIA`, `hr`, `theBoss` y `tierWar`: ADVSEC los publica (fuera de Antistasi) y el rango exacto de 12 niveles vive en ADVSEC (`ADVSEC_globalRank`); en THUD se ve el escalón (Tropa/Cabo/Sargento/Brigada/Teniente/Capitán).
