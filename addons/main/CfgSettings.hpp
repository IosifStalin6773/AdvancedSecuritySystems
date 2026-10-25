// Ajustes de la v1.6. Cualquier clase o valor se puede sobrescribir en description.ext (misma ruta: class ADVSEC_Settings).
class ADVSEC_Settings {
    // Rangos por nivel de placa (1-5). El nivel es el campo "clearance" de la placa/credencial.
    ranksPM[] = {"Agente", "Cabo", "Sargento", "Teniente", "Capitán"};
    ranksAI[] = {"Inspector", "Inspector jefe", "Comisario", "Comisario jefe", "Director"};
    // Rangos globales (base de datos de jugadores). El primero es "sin rango".
    ranksGlobal[] = {"Sin rango", "Rct.", "Sdo.", "Sdo 1º.", "Cbo.", "Cbo 1º.", "Cbo M.", "Sgt.", "Sgt 1º.", "Sgt M.", "Brig.", "Tte.", "Cap."};   // ORBAT: Tropa 1-3, Suboficial 4-9, Oficial 10-12 (ver class ADVSEC_Ranks)
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
        bodycamView[] = {"AI", 2};  // revisar cámaras corporales    // asignar rangos globales
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
    sellFactor = 0.5;            // parte del precio que devuelve la tienda al vender
    atmAnywhere = 0;             // 1 = ingresar, retirar y transferir sin cajero
    thudCompat = 1;              // publica resourcesFIA, hr y theBoss para el HUD THUD (solo fuera de Antistasi)
    thudTreasuryName = "PM";     // nombre de la «facción» en la línea de tesorería del HUD
    shopItems[] = {
        {"FirstAidKit", 25}, {"Medikit", 250}, {"ToolKit", 150}, {"ItemMap", 10}, {"ItemCompass", 10}, {"ItemWatch", 10},
        {"ItemRadio", 50}, {"ItemGPS", 150}, {"Binocular", 75}, {"Chemlight_green", 5}, {"SmokeShell", 20}, {"B_AssaultPack_rgr", 120}
    };

    // Servicio, despacho y alerta
    salaryDutyOnly = 1;          // el plus PM/AA.II. de la nómina solo se cobra de servicio
    dutyAnywhere = 1;            // 1 = fichar desde el menú propio; 0 = solo en un terminal de fichaje
    callCooldown = 60;           // segundos entre llamadas al 112 del mismo jugador
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
    speedFinePerKmh = 5;         // y por cada km/h de más
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
    class pda { name = "Abrir / cerrar PDA"; tooltip = "PDA de Policía Militar o Asuntos Internos"; category = "General"; key[] = {199, 0, 0, 0}; };
    class keyHelp { name = "Ver teclas de ADVSEC"; tooltip = "Lista de todas las teclas del mod"; category = "General"; key[] = {199, 0, 0, 1}; };
    class myDocs { name = "Mis documentos"; tooltip = "Ver y mostrar tus documentos"; category = "Ciudadano"; key[] = {210, 0, 0, 0}; };
    class myFines { name = "Mis multas"; tooltip = "Historial y pago de multas"; category = "Ciudadano"; key[] = {210, 1, 0, 0}; };
    class hide { name = "Ocultar objeto entre la ropa"; tooltip = "Esconde un objeto pequeño del uniforme o chaleco"; category = "Ciudadano"; key[] = {211, 1, 0, 0}; };
    class pmMenu { name = "Menú de Policía Militar"; tooltip = "Acciones de servicio"; category = "Policía Militar"; key[] = {207, 0, 0, 0}; };
    class targetMenu { name = "Acciones sobre el objetivo"; tooltip = "Menú policial de la persona o vehículo al que apuntas"; category = "Policía Militar"; key[] = {207, 0, 1, 0}; };
    class restrain { name = "Esposar / quitar esposas"; tooltip = "A la persona a la que apuntas"; category = "Policía Militar"; key[] = {207, 1, 0, 0}; };
    class escort { name = "Escoltar / soltar"; tooltip = "A la persona esposada a la que apuntas"; category = "Policía Militar"; key[] = {207, 1, 1, 0}; };
    class search { name = "Cachear / registrar vehículo"; tooltip = "Persona esposada o rendida, o vehículo al que apuntas"; category = "Policía Militar"; key[] = {199, 1, 0, 0}; };
    class query { name = "Consultar antecedentes"; tooltip = "Consulta a la central (persona apuntada o selector)"; category = "Policía Militar"; key[] = {199, 0, 1, 0}; };
    class fine { name = "Multar"; tooltip = "A la persona a la que apuntas"; category = "Policía Militar"; key[] = {199, 1, 1, 0}; };
    class askDocs { name = "Pedir documentación"; tooltip = "A la persona a la que apuntas"; category = "Policía Militar"; key[] = {210, 0, 1, 0}; };
    class scene { name = "Inspeccionar escena"; tooltip = "Muestra las pruebas cercanas"; category = "Policía Militar"; key[] = {211, 0, 0, 0}; };
    class evidence { name = "Registro de pruebas"; tooltip = "Pruebas bajo tu custodia"; category = "Policía Militar"; key[] = {211, 0, 1, 0}; };
    class heat { name = "Índice de sospecha (AA.II.)"; tooltip = "Panel de Asuntos Internos"; category = "Asuntos Internos"; key[] = {211, 1, 1, 0}; };
    class playerDB { name = "Base de datos de jugadores"; tooltip = "Lista de jugadores y gestión de rangos"; category = "Policía Militar"; key[] = {207, 0, 0, 1}; };
    class wallet { name = "Cartera y banco"; tooltip = "Efectivo, banco, dar dinero (cajero para ingresar y retirar)"; category = "General"; key[] = {210, 0, 0, 1}; };
    class superAdmin { name = "Terminal de superadministrador"; tooltip = "Solo superadministradores / Zeus"; category = "Zeus"; key[] = {207, 0, 1, 1}; };
    class panic { name = "Botón de pánico"; tooltip = "Avisa a toda la PM con tu posición"; category = "Policía Militar"; key[] = {211, 0, 0, 1}; };
    class dispatch { name = "Central de despacho"; tooltip = "Avisos 112 y pánicos"; category = "Policía Militar"; key[] = {210, 0, 1, 1}; };
    class specs { name = "PDA de especialidad"; tooltip = "Metopas: miembros, solicitudes, altas y bajas"; category = "General"; key[] = {199, 0, 1, 1}; };
    class zeusPanel { name = "Panel de seguridad (Zeus)"; tooltip = "Solo Zeus / administrador"; category = "Zeus"; key[] = {210, 1, 1, 0}; };
};

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
