// Ajustes de la v1.6. Cualquier clase o valor se puede sobrescribir en description.ext (misma ruta: class ADVSEC_Settings).
class ADVSEC_Settings {
    // Rangos por nivel de placa (1-5). El nivel es el campo "clearance" de la placa/credencial.
    ranksPM[] = {"Agente", "Cabo", "Sargento", "Teniente", "Capitán"};
    ranksAI[] = {"Inspector", "Inspector jefe", "Comisario", "Comisario jefe", "Director"};
    // Rangos globales (base de datos de jugadores). El primero es "sin rango".
    ranksGlobal[] = {"Sin rango", "Soldado", "Cabo", "Cabo primero", "Sargento", "Sargento primero", "Brigada", "Subteniente", "Alférez", "Teniente", "Capitán", "Comandante", "Teniente coronel", "Coronel", "General"};
    // Rango de Arma 3 que recibe la unidad con cada rango global (mismo orden; "" = no cambiar)
    ranksGlobalArma[] = {"", "PRIVATE", "CORPORAL", "CORPORAL", "SERGEANT", "SERGEANT", "SERGEANT", "LIEUTENANT", "LIEUTENANT", "LIEUTENANT", "CAPTAIN", "MAJOR", "MAJOR", "COLONEL", "COLONEL"};
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
        treasury[] = {"PM", 5};     // ver la tesorería de la PM y pagar primas    // asignar rangos globales
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
    class zeusPanel { name = "Panel de seguridad (Zeus)"; tooltip = "Solo Zeus / administrador"; category = "Zeus"; key[] = {210, 1, 1, 0}; };
};
