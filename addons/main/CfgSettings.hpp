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

    // Perfil PMC (1.20): la compañía va por delante de la PM. Con 0 todo funciona como antes (solo PM/AA.II.)
    pmcProfile = 1;
    companyName = "I.V.M.";      // nombre de la compañía en los menús
    pmcRankLevels[] = {1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 5};   // nivel de compañía (1-5) de cada rango global: Tropa 1, Cabos 2, Sargentos 3, Brigada/Teniente 4, Capitán 5
    // Permisos: {cuerpo ("PMC" compañía: rango en el ORBAT o PM; "PM" admite también AA.II.; "AI" solo AA.II.), nivel mínimo}
    class Permissions {
        restrain[] = {"PMC", 1};
        search[] = {"PMC", 1};
        seize[] = {"PM", 1};
        vehicleSearch[] = {"PMC", 1};
        evidenceCollect[] = {"PM", 1};
        query[] = {"PMC", 1};
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
        playerDB[] = {"PMC", 4};      // abrir la base de datos de jugadores
        rankPM[] = {"PM", 5};        // asignar rangos PM (solo inferiores al propio)
        rankAI[] = {"AI", 5};        // asignar rangos AA.II. (solo inferiores al propio)
        rankGlobal[] = {"PMC", 5};
        treasury[] = {"PMC", 5};     // ver la tesorería de la PM y pagar primas
        dutyView[] = {"PMC", 3};     // ver agentes de servicio y horas
        dispatch[] = {"PMC", 1};     // central de despacho: aceptar y cerrar avisos
        suspend[] = {"AI", 4};      // suspender agentes temporalmente
        alertLevel[] = {"PMC", 4};   // cambiar el nivel de alerta de la base
        plateQuery[] = {"PMC", 1};   // consultar matrículas
        licenseRevoke[] = {"PM", 2}; // retirar licencias
        bankAudit[] = {"AI", 3};    // auditar cuentas y movimientos sospechosos
        bankFreeze[] = {"AI", 4};   // congelar cuentas
        k9[] = {"PM", 2};           // unidad canina
        radar[] = {"PM", 1};        // radar de velocidad
        bodycamView[] = {"AI", 2};  // revisar cámaras corporales
        patrolPlan[] = {"PMC", 3};   // planificar y cancelar patrullas con ruta
        // PMC (1.18)
        contractView[] = {"PMC", 1};   // terminal de contratos: ver ofertas y contratos
        contractAssign[] = {"PMC", 3}; // asignar operadores, ruta y ROE; iniciar contratos
        contractSign[] = {"PMC", 4};   // negociar, firmar y rescindir contratos
        contractGrey[] = {"PMC", 5};   // aceptar contratos de clientes de zona gris
        armoryCheckout[] = {"PMC", 1}; // sacar material de la armería corporativa
        armoryManage[] = {"PMC", 3};   // intendencia: auditorías, bajas y avisos de desgaste
        logisticsOrder[] = {"PMC", 4}; // pedir material a la tesorería
        cellView[] = {"PMC", 1};       // ver las células operativas (CP, QRF, SEC)
        cellManage[] = {"PMC", 4};     // asignar roles de célula
        cyberView[] = {"AI", 2};      // terminal ciber: alertas, registros, cronologías y CCTV
        cyberManage[] = {"AI", 3};    // restaurar sistemas comprometidos
        traffic[] = {"PM", 2};        // 1.22: desvíos, carriles, grúa, depósito, accidentes, ITV y libro de paso
        breath[] = {"PM", 1};         // 1.22: test de alcoholemia
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
        // PMC (1.18)
        contractGrey = 15;       // firmar un contrato de zona gris
        collateralHurt = 5;      // herir a un civil durante un contrato
        collateralKill = 15;     // matar a un civil durante un contrato
        collateralKillRoe = 30;  // matar a un civil con ROE verde
        armoryMismatch = 10;     // descuadre de material corporativo firmado
        armoryUnauthorized = 15; // abrir la armería sin permiso o fuera de servicio
        corpDiversion = 30;      // llevar material corporativo desviado
        qrfIgnored = 5;          // QRF disponible que no responde a un pánico en 3 minutos
        cyberAnomaly = 3;        // anomalía detectada por el terminal ciber (intrusión, accesos fuera de servicio)
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

    // ===== PMC (1.18): contratos, armería corporativa, contrabando, células y ciber =====
    // Contratos. Zonas automáticas: marcadores advsec_ctr_* o poblaciones cerca de un terminal
    contractAuto = 1;            // 1 = el servidor genera ofertas automáticamente
    contractEvery = 20;          // minutos entre ofertas automáticas (las ofertas caducan a 2× este tiempo)
    contractMax = 6;             // ofertas abiertas a la vez como máximo
    contractMaxActive = 3;       // contratos en curso a la vez como máximo
    contractCivilians = 1;       // 1 = vida en los encargos: tráfico que para en el control, visitantes en la vigilancia, camión en la escolta, llamada 112 en la QRF
    contractCivSuspect = 0.3;    // fracción de civiles sospechosos (sin documentación, con requisitoria o con contrabando)
    contractCivEvery = 45;       // segundos entre civiles nuevos (la vigilancia, el doble)
    contractCheckRep = 1;        // 1 = exigir reputación mínima y limitar el riesgo de las ofertas por reputación; 0 = sin límite
    contractCheckSpecs = 1;      // 1 = exigir las especialidades del tipo de contrato; 0 = no
    contractMinOps = -1;         // operadores PM mínimos por contrato; -1 = el de cada tipo (0 = ninguno, para probar en local)
    contractRounds = 2;          // contraofertas que admite un cliente
    contractAdvance = 0.3;       // anticipo por defecto (0-1) al iniciar el contrato
    contractInsurance = 0.05;    // prima del seguro (fracción del pago); el seguro recupera el 50 % del material perdido
    contractOpShare = 0.4;       // parte del beneficio que se reparte entre los operadores de servicio
    contractCivPenalty = 0.25;   // penalización por civil muerto (fracción del pago) cuando Collateral usa penalPct = -1
    contractRepGain = 10;        // reputación por contrato cumplido
    contractRepLoss = 20;        // reputación perdida por contrato fallido o rescindido
    contractRivalLoss = 4;       // reputación que pierden los rivales del cliente al cumplir
    contractRepDecay = 3;        // días para que la reputación baje/suba 1 punto hacia 0 (0 = nunca)
    contractGreyHeat = 15;
    contractHostiles = 3;        // enemigos: 0 ninguno, 1 solo generados, 2 solo los ya colocados en la zona, 3 ambos (genera los que falten)
    contractHostileSide = "east"; // bando de los generados: east, independent o west
    contractHostileScale = 1;    // multiplicador de los grupos de cada tipo de contrato
    contractHostileClasses[] = {"O_Soldier_F", "O_Soldier_AR_F", "O_Soldier_GL_F", "O_Soldier_LAT_F", "O_Soldier_TL_F", "O_medic_F", "O_soldier_M_F"};       // sospecha de AA.II. al firmar un contrato de zona gris
    collateralCaseAt = 2;        // incidentes graves que dejan el contrato en revisión de Compliance (F-AI-01)
    // Protección cercana (contratos VIP)
    cpCloseRadius = 5;           // distancia máxima escolta-VIP para no contar como exposición
    cpExposurePenalty = 0.01;    // penalización por cada 10 s de VIP expuesto (fracción del pago)
    cpAdvanceRadius = 150;       // radio sin enemigos que se exige a la avanzadilla
    cpAdvanceBonus = 0.1;        // bonus (fracción del pago) si la avanzadilla aseguró el destino
    // QRF
    qrfTarget = 8;               // minutos objetivo de llegada
    qrfArriveRadius = 50;        // metros para contar la llegada
    qrfBonus = 250;              // bonus por llegar a tiempo (a cada miembro)
    qrfStandbyPay = 150;         // plus de guardia en la nómina
    qrfStandbyMin = 0.8;         // fracción mínima del servicio en estado Disponible para cobrar el plus

    class ContractTypes {
        // hostiles = grupos enemigos que se generan (× contractHostileScale) si no hay bastantes ya colocados en la zona
        class escort { name = "$STR_ADVSEC_pmc_type_escort"; base = 6000; risk = 1; minutes = 45; minOps = 3; hostiles = 1; };
        class vip { name = "$STR_ADVSEC_pmc_type_vip"; base = 9000; risk = 2; minutes = 60; minOps = 3; specs[] = {}; hostiles = 2; };
        class guard { name = "$STR_ADVSEC_pmc_type_guard"; base = 4000; risk = 1; minutes = 40; minOps = 2; hostiles = 2; };
        class checkpoint { name = "$STR_ADVSEC_pmc_type_checkpoint"; base = 3500; risk = 0; minutes = 30; minOps = 2; hostiles = 0; };
        class qrf { name = "$STR_ADVSEC_pmc_type_qrf"; base = 5000; risk = 2; minutes = 45; minOps = 3; hostiles = 1; };
        class recovery { name = "$STR_ADVSEC_pmc_type_recovery"; base = 7000; risk = 2; minutes = 50; minOps = 3; hostiles = 2; };
        class clear { name = "$STR_ADVSEC_pmc_type_clear"; base = 6500; risk = 2; minutes = 50; minOps = 3; hostiles = 3; };
    };
    // kind: gov, corp, ngo o grey (zona gris: más pago, sospecha y permiso contractGrey)
    class Clients {
        class Gov { name = "$STR_ADVSEC_pmc_cl_gov"; kind = "gov"; payMul = 1; rivals[] = {"Cartel"}; };
        class Corp { name = "$STR_ADVSEC_pmc_cl_corp"; kind = "corp"; payMul = 1.2; rivals[] = {}; };
        class NGO { name = "$STR_ADVSEC_pmc_cl_ngo"; kind = "ngo"; payMul = 0.8; rivals[] = {}; };
        class Cartel { name = "$STR_ADVSEC_pmc_cl_cartel"; kind = "grey"; payMul = 1.6; rivals[] = {"Gov"}; };
    };
    // Daños colaterales: penalPct (fracción del pago; -1 = contractCivPenalty), penalFlat, penalValue (× valor del bien),
    // fine / fineValue (multa al autor), rep / repPer1000 (reputación con el cliente), rule (sospecha de AA.II.)
    class Collateral {
        class civHurt { penalPct = 0.05; rep = -3; rule = "collateralHurt"; };
        class civKill { penalPct = -1; rep = -10; fine = 2000; rule = "collateralKill"; };
        class civKillRoe { penalPct = 0.5; rep = -25; fine = 5000; rule = "collateralKillRoe"; };
        class vehicle { penalValue = 0.5; repPer1000 = -1; fineValue = 0.25; };
        class building { penalValue = 1; rep = -2; fine = 500; };
        class clientProp { penalValue = 1; rep = -8; };
    };

    // Armería corporativa (cajas con el módulo Armería PMC)
    arsenalSerial = 1;           // 1 = las armas sacadas del Arsenal (ACE o vanilla) reciben nº de serie y quedan registradas a nombre del jugador
    armoryNeedDuty = 1;          // 1 = solo se saca material estando de servicio
    armoryLossFactor = 1.5;      // deuda por material no devuelto (× valor)
    armoryDefaultValue = 1000;   // valor de un arma que no está en ninguna lista de precios
    armoryMagValue = 25;         // valor de un cargador sin precio
    armoryAuditEvery = 0;        // minutos entre auditorías automáticas (0 = solo manuales)
    armoryItems[] = {{"arifle_MX_F", 1800}, {"30Rnd_65x39_caseless_mag", 30}, {"hgun_P07_F", 600}, {"16Rnd_9x21_Mag", 15}, {"FirstAidKit", 20}}; // catálogo de pedidos
    // Vida útil en disparos por tipo de arma (desgaste 100 % = Destruida; al 60 % avisa a intendencia)
    class WeaponWear {
        class rifle { life = 6000; };
        class pistol { life = 4000; };
        class mg { life = 10000; };
        class launcher { life = 40; };
    };
    // Contrabando: fine (-1 = precio de WeaponLicense, < -1 = valor × |n|), rule (sospecha), wanted (Baja/Media/Alta/Extrema)
    blackMarketIllegal = 1;      // 1 = lo que vende el mercado negro cuenta como ilegal en registros y controles
    blackMarketTrace = 0.5;      // probabilidad de que vender material corporativo deje rastro en el registro
    contrabandExplosives[] = {"DemoCharge_Remote_Mag", "SatchelCharge_Remote_Mag", "APERSMine_Range_Mag", "ATMine_Range_Mag", "IEDUrbanSmall_Remote_Mag", "IEDLandSmall_Remote_Mag"};
    class ContrabandRules {
        class explosive { fine = 5000; wanted = "Alta"; };
        class corpDiverted { fine = -2; rule = "corpDiversion"; wanted = "Media"; };
        class blackMarket { fine = 1000; wanted = "Baja"; };
        class noLicense { fine = -1; };
    };

    // Inteligencia y Compliance (terminal ciber)
    cyberAlertsMax = 300;        // alertas que se guardan
    cctvSnapEvery = 20;          // segundos entre capturas CCTV para la reconstrucción (0 = desactivado)
    cctvSnapKeep = 300;          // capturas que se guardan en memoria
    cctvSnapRange = 60;          // metros que «ve» cada cámara
    hackChance = 0.5;            // probabilidad de éxito con el kit de intrusión (+0,3 para la célula SEC)
    hackTime = 20;               // segundos de intrusión
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

    // 1.22: mecánicas de tráfico, control de carretera y patrullas
    itvDays = 30;                 // días de validez de la ITV (0 = sin ITV)
    itvFee = 120;
    itvFine = 100;                // multa por ITV caducada detectada en el control
    breathLimit = 0.25;           // g/l admitidos en el test de alcoholemia
    breathFine = 400;
    breathAIChance = 0.15;        // probabilidad de que un conductor IA dé positivo
    towFee = 300;                 // tasa del depósito
    convoyRadius = 80;            // distancia al destino para considerar llegado el convoy
    convoyBonus = 0;              // prima por convoy completado
    divertRadius = 150;           // radio de un desvío
    patrolUnwatchedMin = 0;       // minutos sin patrulla para avisar en una zona (0 = desactivado)
    patrolNightFactor = 1.5;      // multiplicador de la prima de patrulla de noche
    checkpointANPR = 1;           // lectura automática de matrícula en los controles
    checkpointGate = 1;           // barrera física en los controles
    checkpointAlertRigor = 1;     // más registros con la alerta de base alta
    checkpointEveryN = 0;         // registrar cada N vehículos (0 = solo por sorteo)
    evBloodDecayMin = 0;          // minutos hasta que la sangre del suelo desaparece (0 = nunca)
    evDestroyMin = 0;             // minutos en bolsa hasta destruir la prueba con auditoría (0 = nunca)
    fineRecidivism = 0;           // recargo por multa anterior (0.5 = +50 % por cada anterior, tope 3)
    pointsStart = 0;              // puntos de carnet iniciales (0 = sin puntos)
    pointsLicenseType = "";       // tipo de licencia que se retira al llegar a 0 puntos ("" = ninguna)
    finePrescriptionDays = 0;     // días de juego hasta anular una multa pendiente (0 = nunca)
    transferEscapeChance = 0.02;  // probabilidad por cada 30 s de un detenido en vehículo de intentar la fuga (0 = nunca)
    pdaCipherKey = "";            // clave de los mensajes cifrados del canal PM (vacía = sin cifrar)
    bodycamAutoDraw = 0;          // 1 = la cámara corporal se enciende sola al desenfundar (agentes de servicio)
    bodycamBatteryMin = 0;        // minutos de grabación por carga (0 = infinita)
    radarCalibrationMin = 0;      // minutos entre calibraciones del radar (0 = nunca caduca)
};
