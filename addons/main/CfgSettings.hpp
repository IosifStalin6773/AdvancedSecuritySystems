// Ajustes de la v1.6. Cualquier clase o valor se puede sobrescribir en description.ext (misma ruta: class ADVSEC_Settings).
class ADVSEC_Settings {
    // Idioma de los textos de ADVSEC: 0 = automático (idioma del juego; un servidor dedicado usa inglés), 1 = English, 2 = Español
    language = 0;
    // Rangos por nivel de placa (1-5). El nivel es el campo "clearance" de la placa/credencial.
    ranksPM[] = {"$STR_ADVSEC_officer", "$STR_ADVSEC_corporal", "$STR_ADVSEC_sergeant", "$STR_ADVSEC_lieutenant", "$STR_ADVSEC_captain"};
    ranksAI[] = {"Inspector", "$STR_ADVSEC_chief_inspector", "$STR_ADVSEC_superintendent", "$STR_ADVSEC_chief_superintendent", "Director"};
    // Rangos globales (base de datos de jugadores). El primero es "sin rango".
    ranksGlobal[] = {"$STR_ADVSEC_no_rank", "Rct.", "Sdo.", "$STR_ADVSEC_pfc", "Cbo.", "$STR_ADVSEC_lcpl", "$STR_ADVSEC_cpl_m", "Sgt.", "$STR_ADVSEC_ssgt", "$STR_ADVSEC_msgt", "Brig.", "Tte.", "Cap."};   // ORBAT: Tropa 1-3, Suboficial 4-9, Oficial 10-12 (ver class ADVSEC_Ranks)
    // Rango de Arma 3 que recibe la unidad con cada rango global (mismo orden; "" = no cambiar)
    ranksGlobalArma[] = {"", "PRIVATE", "PRIVATE", "PRIVATE", "CORPORAL", "CORPORAL", "CORPORAL", "SERGEANT", "SERGEANT", "SERGEANT", "LIEUTENANT", "CAPTAIN", "MAJOR"};   // rango de Arma (lo lee THUD; textos en advsec_thud)
    superAdmins[] = {};          // UIDs con acceso al terminal de superadministrador (además de Zeus y los añadidos en partida)
    globalRankSetUnit = 1;       // 1 = aplica setUnitRank según ranksGlobalArma

    // Permisos: {cuerpo ("PM" admite también AA.II.; "AI" solo AA.II.), nivel mínimo}
    class Permissions {
        restrain[] = {"PM", 1};
        search[] = {"PM", 1};
        seize[] = {"PM", 1};
        vehicleSearch[] = {"PM", 1};
        evidenceCollect[] = {"PM", 1};
        query[] = {"PM", 1};
        fine[] = {"PM", 2};
        fineCancel[] = {"PM", 4};
        wanted[] = {"PM", 2};
        arrest[] = {"PM", 2};
        release[] = {"PM", 3};
        evidenceAnalyze[] = {"PM", 3};
        reportStatus[] = {"PM", 3};
        revokeDoc[] = {"PM", 4};
        caseClose[] = {"AI", 3};
        suspicionView[] = {"AI", 1};
        evidenceTamper[] = {"AI", 1};
        evidenceAudit[] = {"AI", 3};
        playerDB[] = {"PM", 4};      // abrir la base de datos de jugadores
        rankPM[] = {"PM", 5};        // asignar rangos PM (solo inferiores al propio)
        rankAI[] = {"AI", 5};        // asignar rangos AA.II. (solo inferiores al propio)
        rankGlobal[] = {"PM", 5};
        treasury[] = {"PM", 5};     // ver la tesorería de la PM y pagar primas
        dutyView[] = {"PM", 3};     // ver agentes de servicio y horas
        dispatch[] = {"PM", 1};     // central de despacho: aceptar y cerrar avisos
        suspend[] = {"AI", 4};      // suspender agentes temporalmente
        alertLevel[] = {"PM", 4};   // cambiar el nivel de alerta de la base
        plateQuery[] = {"PM", 1};   // consultar matrículas
        licenseRevoke[] = {"PM", 2}; // retirar licencias
        bankAudit[] = {"AI", 3};    // auditar cuentas y movimientos sospechosos
        bankFreeze[] = {"AI", 4};   // congelar cuentas
        k9[] = {"PM", 2};           // unidad canina
        radar[] = {"PM", 1};        // radar de velocidad
        bodycamView[] = {"AI", 2};  // revisar cámaras corporales
        patrolPlan[] = {"PM", 3};   // planificar y cancelar patrullas con ruta
    };

    // Evidencias
    evidenceTTL = 3600;          // segundos que una prueba sigue en el suelo sin recoger
    casingEvery = 4;             // un casquillo registrado cada N disparos
    printChance = 0.8;           // probabilidad de dejar huella al tocar puertas, vehículos y contenedores
    gloveChance = 0.15;          // probabilidad con guantes
    gloveItems[] = {};           // clases de objeto/uniforme/chaleco/gafas que cuentan como guantes
    labTime = 90;
    auditTime = 25;              // segundos de auditoría forense (con barra de progreso)                // segundos de análisis
    sceneRadius = 15;            // radio de inspección de escena

    // Sospecha y expedientes automáticos de AA.II.
    heatThreshold = 30;          // al superarlo se abre un F-AI-01 automático
    heatDecay = 1;               // puntos que se pierden cada 10 minutos
    class Rules {
        restrainNoCause = 8;     // esposar a alguien sin requisitoria ni informe que le nombre
        arrestNoCause = 15;      // encarcelar a alguien sin requisitoria ni informe que le nombre
        arrestNoReport = 10;     // encarcelar sin acta F-PM-04
        hitRestrained = 25;      // herir a una persona esposada
        earlyRelease = 10;       // liberar antes de cumplir la condena (no Zeus)
        wantedRemovedByOther = 5;// retirar de buscados a quien declaró otro agente sin informe
        ownCaseAccess = 20;      // un investigador consulta un expediente en el que figura
        evidenceTamper = 40;     // manipulación de prueba descubierta en auditoría
        fineCancelled = 5;       // anular una multa ajena
        bribe = 25;              // aceptar un soborno (queda rastro en el banco)
        suspiciousMoney = 10;    // movimiento de dinero sospechoso con un agente
        bodycamOff = 5;          // apagar la cámara corporal de servicio
    };

    // Cacheo y registro de vehículos
    hiddenFindChance = 0.75;     // probabilidad de encontrar cada objeto escondido entre la ropa
    stashFindChance = 0.5;       // probabilidad de encontrar cada objeto del doble fondo de un vehículo

    // Consulta a la base central desde la PDA
    queryNeedsRadio = 1;         // exige radio (TFAR/ACRE si están cargados; ItemRadio si no)
    queryDelay = 3;

    // Multas
    currency = "€";
    moneyVar = "";               // variable extra donde copiar el efectivo (además de moneyX); sin economía, la que se cobra (vacío = pago manual)
    fineWantedThreshold = 0;     // importe pendiente que añade a buscados automáticamente (0 = no)

    // Economía (compatible con el HUD THUD: efectivo en la variable moneyX del jugador; tesorería, agentes y jefe en resourcesFIA, hr y theBoss)
    economy = 1;                 // 0 = desactivada (las multas usan moneyVar o pago manual)
    startCash = 500;             // efectivo de una cuenta nueva
    startBank = 2000;            // banco de una cuenta nueva
    treasuryStart = 10000;       // tesorería inicial de la PM
    salaryInterval = 30;         // minutos entre nóminas (0 = sin nóminas)
    salaryBase = 100;            // nómina de cualquier jugador
    salaryPM[] = {0, 150, 250, 400, 600, 900};   // plus por nivel de placa PM (0-5)
    salaryAI[] = {0, 150, 250, 400, 600, 900};   // plus por nivel de credencial AA.II. (0-5)
    salaryGlobalStep = 20;       // plus por cada escalón de rango global
    salaryFromTreasury = 0;      // 1 = las nóminas salen de la tesorería de la PM
    fineToTreasury = 1;          // las multas cobradas van a la tesorería
    shopToTreasury = 0;          // las compras en tiendas van a la tesorería
    shopCamera = 1;              // 1 = la tienda enfoca a tu personaje con cámara orbital, como el arsenal
    sellFactor = 0.5;            // parte del precio que devuelve la tienda al vender
    atmAnywhere = 0;             // 1 = ingresar, retirar y transferir sin cajero
    thudCompat = 1;              // publica resourcesFIA, hr y theBoss para el HUD THUD (solo fuera de Antistasi)
    thudTreasuryName = "PM";     // nombre de la «facción» en la línea de tesorería del HUD
    a3aTreasury = 1;             // en Antistasi, la tesorería de la PM es el dinero de la facción rebelde (resourcesFIA)
    // Taquillas personales (TS_Lockers integrado; necesita ACE y CBA)
    lockerAccess = 0;            // quién puede reclamar una taquilla: 0 todos, 1 solo PM, 2 PM o AA.II.
    lockerJailBlock = 1;         // los detenidos no pueden usar su taquilla
    lockerPersist = 2;           // recrear las taquillas colocadas con Zeus al reiniciar: 0 nunca, 1 siempre, 2 solo en Antistasi
    shopItems[] = {
        {"FirstAidKit", 25}, {"Medikit", 250}, {"ToolKit", 150}, {"ItemMap", 10}, {"ItemCompass", 10}, {"ItemWatch", 10},
        {"ItemRadio", 50}, {"ItemGPS", 150}, {"Binocular", 75}, {"Chemlight_green", 5}, {"SmokeShell", 20}, {"B_AssaultPack_rgr", 120}
    };

    // Servicio, despacho y alerta
    salaryDutyOnly = 1;          // el plus PM/AA.II. de la nómina solo se cobra de servicio
    dutyAnywhere = 1;            // 1 = fichar desde el menú propio; 0 = solo en un terminal de fichaje
    callCooldown = 60;           // segundos entre llamadas al 112 del mismo jugador
    // Patrullas con ruta
    patrolOrdered = 1;           // 1 = los puntos se cumplen en orden; 0 = en cualquier orden
    patrolNeedDuty = 1;          // solo cuentan los agentes de servicio
    patrolBonus = 0;             // prima al cumplir la patrulla (0 = sin prima), para los agentes que pasaron por algún punto
    alertRedIdTypes[] = {"MilitaryID", "IDCard", "MPBadge", "IABadge"};   // en alerta roja los keypads exigen además uno de estos documentos
    // Vehículos, licencias y fianza
    dealerVehicles[] = {{"C_Quadbike_01_F", 800}, {"C_Hatchback_01_F", 2500}, {"C_Offroad_01_F", 4000}, {"C_SUV_01_F", 6500}, {"C_Van_01_transport_F", 7000}, {"C_Heli_Light_01_civil_F", 45000}};
    platePrefix = "ET";          // prefijo de las matrículas
    licensePrices[] = {{"WeaponLicense", 1500}, {"DriverLicense", 300}, {"PilotLicense", 5000}};
    bailPerMinute = 50;          // fianza por minuto de condena pendiente (0 = sin fianza)
    // Corrupción y AA.II.
    suspiciousAmount = 2000;     // importe a partir del cual un movimiento con un agente es sospechoso
    weaponRegistryStrict = 1;    // 1 = un casquillo de arma sin registrar no identifica al titular
    shopRegistersWeapons = 1;    // las armas compradas en tiendas legales quedan registradas
    blackMarketItems[] = {{"hgun_Pistol_heavy_01_F", 1800}, {"11Rnd_45ACP_Mag", 80}, {"SMG_02_F", 3500}, {"30Rnd_9x21_Mag_SMG_02", 90}, {"APERSMine_Range_Mag", 900}, {"DemoCharge_Remote_Mag", 1500}};
    // K9 y radar
    k9Class = "Alsatian_Random_F";
    k9FindChance = 0.9;          // probabilidad de marcar cada objeto escondido
    speedLimit = 90;             // km/h
    speedFineBase = 100;         // multa base por exceso
    speedFinePerKmh = 5;
    speedCamClass = "cwa_Kamera";  // modelo de los radares fijos (CWR²); si no está cargado, Land_HandyCam_F
    speedCamAuto = 1;            // 1 = toda cámara speedCamClass colocada en la misión es un radar
    speedCamExemptDuty = 1;      // 1 = la PM de servicio no salta en los radares         // y por cada km/h de más
    // Discord (requiere una extensión de webhook en el servidor)
    discordWebhook = "";         // URL del webhook; vacío = desactivado
    discordExtension = "DiscordEmbedBuilder";   // extensión que hace la petición HTTP
    discordEvents[] = {"jail", "wantedAdd", "bail", "suspend", "alertLevel", "panic", "plateStolen"};

    // Checkpoint IA
    illegalItems[] = {};         // clases que provocan multa/detención en un registro
    checkpointFine = 150;        // multa por circular sin documentación válida
    checkpointSearchChance = 1;  // probabilidad de registrar el vehículo tras la documentación
    checkpointPapersTime = 8;    // segundos revisando documentación (barra de progreso)
    checkpointVehicleTime = 15;  // segundos registrando el vehículo
    checkpointUnits = 2;         // agentes que crea un control sin unidades sincronizadas
    checkpointUnitClasses[] = {"B_GEN_Soldier_F", "B_GEN_Commander_F"}; // Gendarmería (si no existe: B_Soldier_F)
    checkpointSide = "west";     // bando de los agentes creados
    checkpointExemptPM = 0;      // 1 = no para a jugadores con placa PM / AA.II. (ni a admins/Zeus)
    checkpointDocs[] = {"IDCard", "Passport", "MilitaryID", "MPBadge", "IABadge"}; // documentos que valen como identificación
};

// Teclas. Con CBA se cambian en Opciones > Controles > Configurar complementos > Advanced Security Systems.
// Sin CBA (o para cambiar los valores por defecto de una misión) se redefinen en description.ext:
//   class ADVSEC_Keys { class fine { key[] = {DIK, shift, ctrl, alt}; }; };   key[] = {0,0,0,0} desactiva la tecla.
class ADVSEC_Keys {
    class pda { name = "$STR_ADVSEC_open_close_pda"; tooltip = "$STR_ADVSEC_military_police_or_internal_affairs"; category = "General"; key[] = {199, 0, 0, 0}; };
    class keyHelp { name = "$STR_ADVSEC_show_advsec_keys"; tooltip = "$STR_ADVSEC_list_of_all_the_mod"; category = "General"; key[] = {199, 0, 0, 1}; };
    class myDocs { name = "$STR_ADVSEC_my_documents"; tooltip = "$STR_ADVSEC_view_and_show_your_documents"; category = "$STR_ADVSEC_citizen"; key[] = {210, 0, 0, 0}; };
    class myFines { name = "$STR_ADVSEC_my_fines"; tooltip = "$STR_ADVSEC_fine_history_and_payment"; category = "$STR_ADVSEC_citizen"; key[] = {210, 1, 0, 0}; };
    class hide { name = "$STR_ADVSEC_hide_object_in_clothing"; tooltip = "$STR_ADVSEC_hides_a_small_object_from"; category = "$STR_ADVSEC_citizen"; key[] = {211, 1, 0, 0}; };
    class pmMenu { name = "$STR_ADVSEC_military_police_menu"; tooltip = "$STR_ADVSEC_duty_actions"; category = "$STR_ADVSEC_military_police"; key[] = {207, 0, 0, 0}; };
    class targetMenu { name = "$STR_ADVSEC_actions_on_target"; tooltip = "$STR_ADVSEC_police_menu_for_the_person"; category = "$STR_ADVSEC_military_police"; key[] = {207, 0, 1, 0}; };
    class restrain { name = "$STR_ADVSEC_handcuff_remove_handcuffs"; tooltip = "$STR_ADVSEC_on_the_person_you_aim"; category = "$STR_ADVSEC_military_police"; key[] = {207, 1, 0, 0}; };
    class escort { name = "$STR_ADVSEC_escort_release"; tooltip = "$STR_ADVSEC_on_the_handcuffed_person_you"; category = "$STR_ADVSEC_military_police"; key[] = {207, 1, 1, 0}; };
    class search { name = "$STR_ADVSEC_frisk_search_vehicle"; tooltip = "$STR_ADVSEC_handcuffed_or_surrendered_person_or"; category = "$STR_ADVSEC_military_police"; key[] = {199, 1, 0, 0}; };
    class query { name = "$STR_ADVSEC_check_record"; tooltip = "$STR_ADVSEC_dispatch_query_aimed_person_or"; category = "$STR_ADVSEC_military_police"; key[] = {199, 0, 1, 0}; };
    class fine { name = "$STR_ADVSEC_fine_5"; tooltip = "$STR_ADVSEC_on_the_person_you_aim"; category = "$STR_ADVSEC_military_police"; key[] = {199, 1, 1, 0}; };
    class askDocs { name = "$STR_ADVSEC_request_documents_2"; tooltip = "$STR_ADVSEC_on_the_person_you_aim"; category = "$STR_ADVSEC_military_police"; key[] = {210, 0, 1, 0}; };
    class scene { name = "$STR_ADVSEC_inspect_scene"; tooltip = "$STR_ADVSEC_shows_nearby_evidence"; category = "$STR_ADVSEC_military_police"; key[] = {211, 0, 0, 0}; };
    class evidence { name = "$STR_ADVSEC_evidence_log"; tooltip = "$STR_ADVSEC_evidence_in_your_custody"; category = "$STR_ADVSEC_military_police"; key[] = {211, 0, 1, 0}; };
    class heat { name = "$STR_ADVSEC_suspicion_index_ia"; tooltip = "$STR_ADVSEC_internal_affairs_panel"; category = "$STR_ADVSEC_internal_affairs"; key[] = {211, 1, 1, 0}; };
    class playerDB { name = "$STR_ADVSEC_player_database"; tooltip = "$STR_ADVSEC_player_list_and_rank_management"; category = "$STR_ADVSEC_military_police"; key[] = {207, 0, 0, 1}; };
    class wallet { name = "$STR_ADVSEC_wallet_and_bank"; tooltip = "$STR_ADVSEC_cash_bank_give_money_atm"; category = "General"; key[] = {210, 0, 0, 1}; };
    class superAdmin { name = "$STR_ADVSEC_superadmin_terminal_2"; tooltip = "$STR_ADVSEC_superadmins_zeus_only"; category = "Zeus"; key[] = {207, 0, 1, 1}; };
    class panic { name = "$STR_ADVSEC_panic_button"; tooltip = "$STR_ADVSEC_alerts_the_whole_mp_with"; category = "$STR_ADVSEC_military_police"; key[] = {211, 0, 0, 1}; };
    class dispatch { name = "$STR_ADVSEC_dispatch_centre"; tooltip = "$STR_ADVSEC_112_calls_and_panics"; category = "$STR_ADVSEC_military_police"; key[] = {210, 0, 1, 1}; };
    class specs { name = "$STR_ADVSEC_specialty_pda"; tooltip = "$STR_ADVSEC_patches_members_requests_joins_and"; category = "General"; key[] = {199, 0, 1, 1}; };
    class zeusPanel { name = "$STR_ADVSEC_security_panel_zeus"; tooltip = "$STR_ADVSEC_zeus_admin_only"; category = "Zeus"; key[] = {210, 1, 1, 0}; };
};

// Especialidades (metopas). traits: setUnitTrait · ace: variables de ACE en la unidad
class ADVSEC_Specialties {
    class JTAC { name = "JTAC"; };
    class RO { name = "$STR_ADVSEC_radio_operator"; };
    class SAN { name = "$STR_ADVSEC_combat_medic"; traits[] = {{"Medic", 1}}; ace[] = {{"ace_medical_medicClass", 1}}; };
    class MED { name = "$STR_ADVSEC_doctor"; traits[] = {{"Medic", 1}}; ace[] = {{"ace_medical_medicClass", 2}}; };
    class AT { name = "$STR_ADVSEC_anti_tank_at"; };
    class MG { name = "$STR_ADVSEC_machine_gunner"; };
    class ENG { name = "$STR_ADVSEC_engineer"; traits[] = {{"Engineer", 1}}; ace[] = {{"ace_isEngineer", 2}}; };
    class EOD { name = "$STR_ADVSEC_eod_disposal"; traits[] = {{"ExplosiveSpecialist", 1}}; ace[] = {{"ace_isEOD", 1}, {"ace_isEngineer", 1}}; };
    class AA { name = "$STR_ADVSEC_anti_air_aa"; };
    class GRN { name = "$STR_ADVSEC_grenadier"; };
    class TANK { name = "$STR_ADVSEC_tank_crew"; };
    class PARA { name = "$STR_ADVSEC_paratrooper"; };
    class PILOT { name = "$STR_ADVSEC_pilot"; };
    class LOG { name = "$STR_ADVSEC_logistics"; traits[] = {{"Engineer", 1}}; ace[] = {{"ace_isEngineer", 1}}; };
    class ART { name = "$STR_ADVSEC_artillery"; };
    class MRK { name = "$STR_ADVSEC_marksman"; };
};

// Rangos (capa de datos sobre CfgORBAT): índice = posición en ranksGlobal
class ADVSEC_Ranks {
    class R1 { abbr = "Rct."; name = "$STR_ADVSEC_recruit"; category = "Tropa"; arma = "PRIVATE"; };
    class R2 { abbr = "Sdo."; name = "$STR_ADVSEC_private"; category = "Tropa"; arma = "PRIVATE"; };
    class R3 { abbr = "Sdo 1º."; name = "$STR_ADVSEC_private_first_class"; category = "Tropa"; arma = "PRIVATE"; };
    class R4 { abbr = "Cbo."; name = "$STR_ADVSEC_corporal"; category = "Suboficial"; arma = "CORPORAL"; };
    class R5 { abbr = "Cbo 1º."; name = "$STR_ADVSEC_lance_corporal"; category = "Suboficial"; arma = "CORPORAL"; };
    class R6 { abbr = "Cbo M."; name = "$STR_ADVSEC_master_corporal"; category = "Suboficial"; arma = "CORPORAL"; };
    class R7 { abbr = "Sgt."; name = "$STR_ADVSEC_sergeant"; category = "Suboficial"; arma = "SERGEANT"; };
    class R8 { abbr = "Sgt 1º."; name = "$STR_ADVSEC_staff_sergeant"; category = "Suboficial"; arma = "SERGEANT"; };
    class R9 { abbr = "Sgt M."; name = "$STR_ADVSEC_master_sergeant"; category = "Suboficial"; arma = "SERGEANT"; };
    class R10 { abbr = "Brig."; name = "$STR_ADVSEC_warrant_officer"; category = "Oficial"; arma = "LIEUTENANT"; };
    class R11 { abbr = "Tte."; name = "$STR_ADVSEC_lieutenant"; category = "Oficial"; arma = "CAPTAIN"; };
    class R12 { abbr = "Cap."; name = "$STR_ADVSEC_captain"; category = "Oficial"; arma = "MAJOR"; };
};
