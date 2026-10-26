#define ADVSEC_STR(V) #V
#define REQ_ATTRS(P) \
    class Clearance: Combo { property = ADVSEC_STR(P##_Clearance); displayName = "Nivel mínimo"; typeName = "NUMBER"; defaultValue = "-1"; \
        class Values { \
            class NA { name = "Sin nivel mínimo"; value = -1; }; \
            class L0 { name = "Nivel 0"; value = 0; }; \
            class L1 { name = "Nivel 1 o superior"; value = 1; }; \
            class L2 { name = "Nivel 2 o superior"; value = 2; }; \
            class L3 { name = "Nivel 3 o superior"; value = 3; }; \
            class L4 { name = "Nivel 4 o superior"; value = 4; }; \
            class L5 { name = "Nivel 5"; value = 5; }; \
        }; \
    }; \
    class DocTypes: Edit { property = ADVSEC_STR(P##_DocTypes); displayName = "Tipos de documento"; tooltip = "Separados por coma (vacío = cualquiera): Passport, IDCard, Permit, Keycard, Key, MilitaryID, MPBadge, IABadge"; typeName = "STRING"; defaultValue = """"""; }; \
    class KeyId: Edit { property = ADVSEC_STR(P##_KeyId); displayName = "ID de llave"; tooltip = "Llave/tarjeta que también da acceso (vacío = ninguna)"; typeName = "STRING"; defaultValue = """"""; };

class CfgFactionClasses {
    class NO_CATEGORY;
    class ADVSEC_Modules: NO_CATEGORY {
        displayName = "Advanced Security";
    };
};

class CfgVehicles {
    class Logic;
    class Module_F: Logic {
        class AttributesBase {
            class Default;
            class Edit;
            class Combo;
            class Checkbox;
            class CheckboxNumber;
            class ModuleDescription;
            class Units;
        };
        class ModuleDescription {
            class AnyBrain;
        };
    };

    class ADVSEC_Module_Base: Module_F {
        author = "oscar";
        category = "ADVSEC_Modules";
        scope = 1;
        scopeCurator = 0;
        isGlobal = 2;            // también en jugadores que entran a mitad de partida (JIP): las interacciones son locales
        isTriggerActivated = 0;
        isDisposable = 0;
        is3DEN = 0;
        functionPriority = 1;
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\interact_ca.paa";
        portrait = "\A3\ui_f\data\igui\cfg\simpleTasks\types\interact_ca.paa";
        class Attributes: AttributesBase {};
        class ModuleDescription: ModuleDescription {};
    };

    // ===== Eden =====
    class ADVSEC_ModuleCamera: ADVSEC_Module_Base {
        scope = 2;
        displayName = "Cámara CCTV";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\scout_ca.paa";
        function = "ADVSEC_fnc_moduleCamera";
        class Attributes: AttributesBase {
            class Name: Edit { property = "ADVSEC_Cam_Name"; displayName = "Nombre"; typeName = "STRING"; defaultValue = """CAM"""; };
            class Network: Edit { property = "ADVSEC_Cam_Network"; displayName = "Red CCTV"; tooltip = "Los monitores de la misma red ven esta cámara"; typeName = "STRING"; defaultValue = """default"""; };
            class Pitch: Combo {
                property = "ADVSEC_Cam_Pitch"; displayName = "Inclinación"; typeName = "NUMBER"; defaultValue = "-20";
                class Values {
                    class P0 { name = "Horizontal"; value = 0; };
                    class P10 { name = "Ligera (-10º)"; value = -10; };
                    class P20 { name = "Media (-20º)"; value = -20; };
                    class P35 { name = "Pronunciada (-35º)"; value = -35; };
                    class P60 { name = "Cenital (-60º)"; value = -60; };
                };
            };
            class Yaw: Edit { property = "ADVSEC_Cam_Yaw"; displayName = "Giro extra (º)"; typeName = "NUMBER"; defaultValue = "0"; };
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = "Sincroniza con objetos para usarlos como cámara. Sin sincronizar, el propio módulo (posición y rotación) es la cámara.";
        };
    };
    class ADVSEC_ModuleMonitor: ADVSEC_Module_Base {
        scope = 2;
        displayName = "Monitor CCTV";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\scout_ca.paa";
        function = "ADVSEC_fnc_moduleMonitor";
        class Attributes: AttributesBase {
            class Network: Edit { property = "ADVSEC_Mon_Network"; displayName = "Red CCTV"; typeName = "STRING"; defaultValue = """default"""; };
            REQ_ATTRS(ADVSEC_Mon)
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = "Sincroniza con el objeto monitor/portátil.";
        };
    };
    class ADVSEC_ModuleKeypad: ADVSEC_Module_Base {
        scope = 2;
        displayName = "Keypad / control de acceso";
        function = "ADVSEC_fnc_moduleKeypad";
        class Attributes: AttributesBase {
            class Pin: Edit { property = "ADVSEC_Kp_Pin"; displayName = "PIN"; typeName = "STRING"; defaultValue = """1234"""; };
            class Doors: Edit { property = "ADVSEC_Kp_Doors"; displayName = "Puertas"; tooltip = "Índices separados por coma, o all = todas"; typeName = "STRING"; defaultValue = """all"""; };
            class Zone: Edit { property = "ADVSEC_Kp_Zone"; displayName = "Zona de alarma"; tooltip = "Zona del módulo de alarma vinculado (vacío = ninguna)"; typeName = "STRING"; defaultValue = """"""; };
            class Label: Edit { property = "ADVSEC_Kp_Label"; displayName = "Etiqueta"; typeName = "STRING"; defaultValue = """INTRODUZCA PIN"""; };
            REQ_ATTRS(ADVSEC_Kp)
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = "Sincroniza con el objeto keypad y con el edificio (si no, usa el edificio con puertas más cercano). Nivel/tipos/llave definen qué documentos sirven como tarjeta.";
        };
    };
    class ADVSEC_ModuleDoor: ADVSEC_Module_Base {
        scope = 2;
        displayName = "Cerradura de puerta";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\use_ca.paa";
        function = "ADVSEC_fnc_moduleDoor";
        class Attributes: AttributesBase {
            class Doors: Edit { property = "ADVSEC_Door_Doors"; displayName = "Puertas"; tooltip = "Índices separados por coma, o all = todas"; typeName = "STRING"; defaultValue = """all"""; };
            class Locked: Checkbox { property = "ADVSEC_Door_Locked"; displayName = "Bloqueada al inicio"; typeName = "BOOL"; defaultValue = "true"; };
            REQ_ATTRS(ADVSEC_Door)
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = "Sincroniza con el edificio o colócalo junto a él. Quien cumpla el requisito puede bloquear/desbloquear.";
        };
    };
    class ADVSEC_ModuleAlarm: ADVSEC_Module_Base {
        scope = 2;
        displayName = "Alarma";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\danger_ca.paa";
        function = "ADVSEC_fnc_moduleAlarm";
        class Attributes: AttributesBase {
            class Name: Edit { property = "ADVSEC_Al_Name"; displayName = "Nombre"; typeName = "STRING"; defaultValue = """Alarma"""; };
            class Zone: Edit { property = "ADVSEC_Al_Zone"; displayName = "Zona"; tooltip = "ID para vincular keypads"; typeName = "STRING"; defaultValue = """zona1"""; };
            class Radius: Edit { property = "ADVSEC_Al_Radius"; displayName = "Radio (m)"; typeName = "NUMBER"; defaultValue = "15"; };
            class Doors: Edit { property = "ADVSEC_Al_Doors"; displayName = "Puertas vigiladas"; tooltip = "Índices, all = todas, vacío = ninguna"; typeName = "STRING"; defaultValue = """"""; };
            class Armed: Checkbox { property = "ADVSEC_Al_Armed"; displayName = "Armada al inicio"; typeName = "BOOL"; defaultValue = "true"; };
            REQ_ATTRS(ADVSEC_Al)
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = "Sincroniza con el altavoz (opcional) y el edificio vigilado. El requisito define quién puede estar en la zona y desarmarla.";
        };
    };
    class ADVSEC_ModuleIssuer: ADVSEC_Module_Base {
        scope = 2;
        displayName = "Oficina de documentación";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\documents_ca.paa";
        function = "ADVSEC_fnc_moduleIssuer";
        class Attributes: AttributesBase {
            class Issuer: Edit { property = "ADVSEC_Iss_Name"; displayName = "Emisor"; typeName = "STRING"; defaultValue = """Ministerio del Interior"""; };
            class Types: Edit { property = "ADVSEC_Iss_Types"; displayName = "Tipos emitibles"; tooltip = "Vacío = todos"; typeName = "STRING"; defaultValue = """"""; };
            class MaxClearance: Combo {
                property = "ADVSEC_Iss_Max"; displayName = "Nivel máximo que puede emitir"; typeName = "NUMBER"; defaultValue = "3";
                class Values {
                    class L0 { name = "Nivel 0"; value = 0; };
                    class L1 { name = "Nivel 1"; value = 1; };
                    class L2 { name = "Nivel 2"; value = 2; };
                    class L3 { name = "Nivel 3"; value = 3; };
                    class L4 { name = "Nivel 4"; value = 4; };
                    class L5 { name = "Nivel 5"; value = 5; };
                };
            };
            REQ_ATTRS(ADVSEC_Iss)
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = "Sincroniza con el objeto de la oficina. El requisito se aplica al operador que emite.";
        };
    };

    class ADVSEC_ModuleReports: ADVSEC_Module_Base {
        scope = 2;
        displayName = "Terminal de informes PM / AA.II.";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\documents_ca.paa";
        function = "ADVSEC_fnc_moduleReports";
        class Attributes: AttributesBase {
            class Dept: Combo {
                property = "ADVSEC_Rep_Dept";
                displayName = "Departamento";
                typeName = "STRING";
                defaultValue = """PM""";
                class Values {
                    class PM { name = "Policía Militar"; value = "PM"; };
                    class AI { name = "Asuntos Internos"; value = "AI"; };
                    class BOTH { name = "Ambos"; value = "BOTH"; };
                };
            };
            REQ_ATTRS(ADVSEC_Rep)
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = "Sincroniza con el ordenador/archivo. Acceso: placa PM o credencial AA.II. (y el requisito adicional si se define). Los informes se guardan en el perfil del servidor y persisten entre misiones.";
        };
    };

    class ADVSEC_ModuleAtm: ADVSEC_Module_Base {
        scope = 2;
        displayName = "Cajero automático";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\box_ca.paa";
        function = "ADVSEC_fnc_moduleAtm";
        class Attributes: AttributesBase {
            class Name: Edit { property = "ADVSEC_Atm_Name"; displayName = "Nombre"; typeName = "STRING"; defaultValue = """Cajero automático"""; };
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = "Sincronízalo con cualquier objeto (o déjalo solo y crea un cajero). Permite ingresar, retirar y transferir dinero.";
        };
    };
    class ADVSEC_ModuleShop: ADVSEC_Module_Base {
        scope = 2;
        displayName = "Tienda";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\box_ca.paa";
        function = "ADVSEC_fnc_moduleShop";
        class Attributes: AttributesBase {
            class Name: Edit { property = "ADVSEC_Shop_Name"; displayName = "Nombre"; typeName = "STRING"; defaultValue = """Tienda"""; };
            class Items: Edit { property = "ADVSEC_Shop_Items"; displayName = "Artículos"; tooltip = "Elige categoría y artículo con precio. Vacío = shopItems (o blackMarketItems si es oculta)."; typeName = "STRING"; control = "ADVSEC_CatalogItems"; defaultValue = """"""; };
            class Hidden: CheckboxNumber { property = "ADVSEC_Shop_Hidden"; displayName = "Mercado negro (oculta)"; tooltip = "Sin nombre, solo a menos de 2,5 m; las compras no van a la tesorería ni registran armas."; defaultValue = "0"; };
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = "Sincronízalo con una mesa, un mostrador o un PNJ (o déjalo solo y crea una mesa). Vende y recompra los artículos de la lista.";
        };
    };
    class ADVSEC_ModuleDealer: ADVSEC_Module_Base {
        scope = 2;
        displayName = "Concesionario de vehículos";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\car_ca.paa";
        function = "ADVSEC_fnc_moduleDealer";
        class Attributes: AttributesBase {
            class Name: Edit { property = "ADVSEC_Dealer_Name"; displayName = "Nombre"; typeName = "STRING"; defaultValue = """Concesionario"""; };
            class Items: Edit { property = "ADVSEC_Dealer_Items"; displayName = "Vehículos"; tooltip = "Elige categoría y vehículo con precio. Vacío = dealerVehicles de ADVSEC_Settings."; typeName = "STRING"; control = "ADVSEC_CatalogVehicles"; defaultValue = """"""; };
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = "Vende vehículos matriculados a nombre del comprador (registro consultable por la PM). Se entregan cerca del objeto sincronizado.";
        };
    };
    class ADVSEC_ModuleDuty: ADVSEC_Module_Base {
        scope = 2;
        displayName = "Terminal de fichaje (servicio)";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\wait_ca.paa";
        function = "ADVSEC_fnc_moduleDuty";
        class Attributes: AttributesBase {
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = "La PM y AA.II. fichan entrada y salida de servicio. Con dutyAnywhere = 0 es el único sitio donde se puede fichar.";
        };
    };
    class ADVSEC_ModuleSpeedCam: ADVSEC_Module_Base {
        scope = 2;
        displayName = "Radar fijo de velocidad";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\car_ca.paa";
        function = "ADVSEC_fnc_moduleSpeedCam";
        class Attributes: AttributesBase {
            class Name: Edit { property = "ADVSEC_SC_Name"; displayName = "Nombre"; typeName = "STRING"; defaultValue = """Radar"""; };
            class Limit: Edit { property = "ADVSEC_SC_Limit"; displayName = "Límite (km/h)"; tooltip = "0 = speedLimit de ADVSEC_Settings"; typeName = "NUMBER"; defaultValue = "0"; };
            class Range: Edit { property = "ADVSEC_SC_Range"; displayName = "Alcance (m)"; typeName = "NUMBER"; defaultValue = "40"; };
            class FineBase: Edit { property = "ADVSEC_SC_Base"; displayName = "Multa base"; tooltip = "0 = speedFineBase"; typeName = "NUMBER"; defaultValue = "0"; };
            class FinePer: Edit { property = "ADVSEC_SC_Per"; displayName = "Multa por km/h de más"; tooltip = "0 = speedFinePerKmh"; typeName = "NUMBER"; defaultValue = "0"; };
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = "Radar fijo: multa automáticamente a quien pase por encima del límite. Sincronízalo con una cámara (cwa_Kamera) o déjalo solo y la crea. La PM lo configura interactuando con él. Además, toda cwa_Kamera colocada en la misión ya es un radar (speedCamAuto).";
        };
    };
    class ADVSEC_ModuleAdmin: ADVSEC_Module_Base {
        scope = 2;
        displayName = "Terminal de superadministrador";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\intel_ca.paa";
        function = "ADVSEC_fnc_moduleAdmin";
        class Attributes: AttributesBase {
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = "Sincroniza con un ordenador (o déjalo sin sincronizar y crea un portátil). Solo lo abren Zeus/administradores y los UID de superadministrador. Permite borrar informes, buscados, multas, pruebas, documentos, registros y quitar rangos.";
        };
    };

    class ADVSEC_ModuleJail: ADVSEC_Module_Base {
        scope = 2;
        displayName = "Calabozo / centro de detención";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\wait_ca.paa";
        function = "ADVSEC_fnc_moduleJail";
        class Attributes: AttributesBase {
            class Name: Edit { property = "ADVSEC_Jail_Name"; displayName = "Nombre"; typeName = "STRING"; defaultValue = """Calabozo PM"""; };
            class Radius: Combo {
                property = "ADVSEC_Jail_Radius"; displayName = "Radio"; typeName = "NUMBER"; defaultValue = "6";
                class Values {
                    class R3 { name = "3 m"; value = 3; };
                    class R6 { name = "6 m"; value = 6; };
                    class R10 { name = "10 m"; value = 10; };
                    class R20 { name = "20 m"; value = 20; };
                };
            };
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = "Colócalo dentro de la celda (o sincronízalo con un objeto). Los detenidos aparecen aquí, no pueden salir del radio y el tiempo restante se guarda en el servidor aunque se desconecten o cambie la misión.";
        };
    };

    class ADVSEC_ModuleLab: ADVSEC_Module_Base {
        scope = 2;
        displayName = "Laboratorio forense";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\search_ca.paa";
        function = "ADVSEC_fnc_moduleLab";
        class Attributes: AttributesBase {
            class Name: Edit { property = "ADVSEC_Lab_Name"; displayName = "Nombre"; typeName = "STRING"; defaultValue = """Laboratorio forense"""; };
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = "Sincronízalo con una mesa u ordenador. Allí se analizan las pruebas (casquillos, huellas, sangre) y AA.II. puede auditar la cadena de custodia.";
        };
    };
    class ADVSEC_ModuleCheckpoint: ADVSEC_Module_Base {
        scope = 2;
        isGlobal = 0;
        displayName = "Control de carretera (IA)";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\car_ca.paa";
        function = "ADVSEC_fnc_moduleCheckpoint";
        class Attributes: AttributesBase {
            class Name: Edit { property = "ADVSEC_Cp_Name"; displayName = "Nombre"; typeName = "STRING"; defaultValue = """Control PM"""; };
            class SpawnUnits: Combo {
                property = "ADVSEC_Cp_Units"; displayName = "Agentes nuevos (si no hay unidades sincronizadas)"; typeName = "NUMBER"; defaultValue = "2";
                class Values {
                    class U0 { name = "Ninguno"; value = 0; };
                    class U2 { name = "2"; value = 2; };
                    class U4 { name = "4"; value = 4; };
                };
            };
            class Radius: Combo {
                property = "ADVSEC_Cp_Radius"; displayName = "Radio"; typeName = "NUMBER"; defaultValue = "20";
                class Values {
                    class R10 { name = "10 m"; value = 10; };
                    class R20 { name = "20 m"; value = 20; };
                    class R35 { name = "35 m"; value = 35; };
                };
            };
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = "Colócalo sobre la carretera orientado en el sentido de la vía. Si no lo sincronizas con agentes IA crea los suyos y pone conos. Detiene los vehículos, pide documentación, comprueba la lista de buscados, multa, registra al azar y detiene. Quien se lo salte pasa a buscados.";
        };
    };

    // ===== Zeus =====
    class ADVSEC_Zeus_Base: ADVSEC_Module_Base {
        scope = 1;
        scopeCurator = 2;
        curatorCanAttach = 1;
        isGlobal = 1;            // solo hace falta en la máquina del Zeus; el init se reparte con remoteExec (JIP)
        function = "ADVSEC_fnc_zeusModule";
    };
    class ADVSEC_ZeusCamera: ADVSEC_Zeus_Base {
        displayName = "Cámara CCTV";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\scout_ca.paa";
        ADVSEC_kind = "camera";
    };
    class ADVSEC_ZeusMonitor: ADVSEC_Zeus_Base {
        displayName = "Monitor CCTV";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\scout_ca.paa";
        ADVSEC_kind = "monitor";
    };
    class ADVSEC_ZeusKeypad: ADVSEC_Zeus_Base {
        displayName = "Keypad / control de acceso";
        ADVSEC_kind = "keypad";
    };
    class ADVSEC_ZeusDoor: ADVSEC_Zeus_Base {
        displayName = "Cerradura de puerta";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\use_ca.paa";
        ADVSEC_kind = "door";
    };
    class ADVSEC_ZeusAlarm: ADVSEC_Zeus_Base {
        displayName = "Alarma";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\danger_ca.paa";
        ADVSEC_kind = "alarm";
    };
    class ADVSEC_ZeusIssuer: ADVSEC_Zeus_Base {
        displayName = "Oficina de documentación";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\documents_ca.paa";
        ADVSEC_kind = "issuer";
    };
    class ADVSEC_ZeusReports: ADVSEC_Zeus_Base {
        displayName = "Terminal de informes PM / AA.II.";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\documents_ca.paa";
        ADVSEC_kind = "reports";
    };
    class ADVSEC_ZeusJail: ADVSEC_Zeus_Base {
        displayName = "Calabozo / centro de detención";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\wait_ca.paa";
        ADVSEC_kind = "jail";
    };
    class ADVSEC_ZeusPanel: ADVSEC_Zeus_Base {
        displayName = "Panel de seguridad";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\map_ca.paa";
        ADVSEC_kind = "panel";
    };
    class ADVSEC_ZeusPolice: ADVSEC_Zeus_Base {
        displayName = "Acciones de Policía Militar (sobre unidad)";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\defend_ca.paa";
        ADVSEC_kind = "police";
    };
    class ADVSEC_ZeusLab: ADVSEC_Zeus_Base {
        displayName = "Laboratorio forense";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\search_ca.paa";
        ADVSEC_kind = "lab";
    };
    class ADVSEC_ZeusCheckpoint: ADVSEC_Zeus_Base {
        displayName = "Control de carretera (IA)";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\car_ca.paa";
        ADVSEC_kind = "checkpoint";
    };
    class ADVSEC_ZeusAtm: ADVSEC_Zeus_Base {
        displayName = "Cajero automático";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\box_ca.paa";
        ADVSEC_kind = "atm";
    };
    class ADVSEC_ZeusShop: ADVSEC_Zeus_Base {
        displayName = "Tienda";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\box_ca.paa";
        ADVSEC_kind = "shop";
    };
    class ADVSEC_ZeusDealer: ADVSEC_Zeus_Base {
        displayName = "Concesionario de vehículos";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\car_ca.paa";
        ADVSEC_kind = "dealer";
    };
    class ADVSEC_ZeusDuty: ADVSEC_Zeus_Base {
        displayName = "Terminal de fichaje (servicio)";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\wait_ca.paa";
        ADVSEC_kind = "duty";
    };
    class ADVSEC_ZeusSpeedCam: ADVSEC_Zeus_Base {
        displayName = "Radar fijo de velocidad";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\car_ca.paa";
        ADVSEC_kind = "speedcam";
    };
    class ADVSEC_ZeusAdmin: ADVSEC_Zeus_Base {
        displayName = "Terminal de superadministrador";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\intel_ca.paa";
        ADVSEC_kind = "admin";
    };
    // Objetos sueltos en Eden/Zeus (Equipo > Objetos de inventario) y caja con todo el material ADVSEC
    class Item_Base_F;
#define ADVSEC_GROUND(C,N) class Item_##C: Item_Base_F { scope = 2; scopeCurator = 2; author = "oscar"; displayName = N; editorCategory = "EdCat_Equipment"; editorSubcategory = "EdSubcat_InventoryItems"; vehicleClass = "Items"; class TransportItems { class C { name = #C; count = 1; }; }; }
    ADVSEC_GROUND(ADVSEC_Passport,"Pasaporte");
    ADVSEC_GROUND(ADVSEC_IDCard,"Tarjeta de identificación");
    ADVSEC_GROUND(ADVSEC_Permit,"Permiso");
    ADVSEC_GROUND(ADVSEC_Keycard,"Tarjeta de acceso");
    ADVSEC_GROUND(ADVSEC_Key,"Llave");
    ADVSEC_GROUND(ADVSEC_MilitaryID,"Identificación militar");
    ADVSEC_GROUND(ADVSEC_MPBadge,"Placa de Policía Militar");
    ADVSEC_GROUND(ADVSEC_IABadge,"Credencial de Asuntos Internos");
    ADVSEC_GROUND(ADVSEC_PDA_PM,"PDA de Policía Militar");
    ADVSEC_GROUND(ADVSEC_PDA_AI,"PDA de Asuntos Internos");
    ADVSEC_GROUND(ADVSEC_PDA_JTAC,"PDA de metopa: JTAC");
    ADVSEC_GROUND(ADVSEC_PDA_RO,"PDA de metopa: Radio operador");
    ADVSEC_GROUND(ADVSEC_PDA_SAN,"PDA de metopa: Sanitario");
    ADVSEC_GROUND(ADVSEC_PDA_MED,"PDA de metopa: Médico");
    ADVSEC_GROUND(ADVSEC_PDA_AT,"PDA de metopa: Antitanque (AT)");
    ADVSEC_GROUND(ADVSEC_PDA_MG,"PDA de metopa: Ametrallador");
    ADVSEC_GROUND(ADVSEC_PDA_ENG,"PDA de metopa: Ingeniero");
    ADVSEC_GROUND(ADVSEC_PDA_EOD,"PDA de metopa: EOD (desactivación)");
    ADVSEC_GROUND(ADVSEC_PDA_AA,"PDA de metopa: Antiaéreo (AA)");
    ADVSEC_GROUND(ADVSEC_PDA_GRN,"PDA de metopa: Granadero");
    ADVSEC_GROUND(ADVSEC_PDA_TANK,"PDA de metopa: Carrista");
    ADVSEC_GROUND(ADVSEC_PDA_PARA,"PDA de metopa: Paracaidista");
    ADVSEC_GROUND(ADVSEC_PDA_PILOT,"PDA de metopa: Piloto");
    ADVSEC_GROUND(ADVSEC_PDA_LOG,"PDA de metopa: Logística");
    ADVSEC_GROUND(ADVSEC_PDA_ART,"PDA de metopa: Artillería");
    ADVSEC_GROUND(ADVSEC_PDA_MRK,"PDA de metopa: Tirador");
    ADVSEC_GROUND(ADVSEC_EvidenceBag,"Bolsa de pruebas");
    class Box_NATO_Support_F;
    class ADVSEC_Box_Equipment: Box_NATO_Support_F {
        scope = 2;
        scopeCurator = 2;
        author = "oscar";
        displayName = "Caja de material ADVSEC (PDA, placas, documentos)";
        class TransportWeapons {};
        class TransportMagazines {};
        class TransportBackpacks {};
        class TransportItems {
            class _xx_ADVSEC_Passport { name = "ADVSEC_Passport"; count = 10; };
            class _xx_ADVSEC_IDCard { name = "ADVSEC_IDCard"; count = 10; };
            class _xx_ADVSEC_Permit { name = "ADVSEC_Permit"; count = 10; };
            class _xx_ADVSEC_Keycard { name = "ADVSEC_Keycard"; count = 10; };
            class _xx_ADVSEC_Key { name = "ADVSEC_Key"; count = 10; };
            class _xx_ADVSEC_MilitaryID { name = "ADVSEC_MilitaryID"; count = 10; };
            class _xx_ADVSEC_MPBadge { name = "ADVSEC_MPBadge"; count = 10; };
            class _xx_ADVSEC_IABadge { name = "ADVSEC_IABadge"; count = 5; };
            class _xx_ADVSEC_PDA_PM { name = "ADVSEC_PDA_PM"; count = 10; };
            class _xx_ADVSEC_PDA_AI { name = "ADVSEC_PDA_AI"; count = 5; };
            class _xx_ADVSEC_PDA_JTAC { name = "ADVSEC_PDA_JTAC"; count = 4; };
            class _xx_ADVSEC_PDA_RO { name = "ADVSEC_PDA_RO"; count = 4; };
            class _xx_ADVSEC_PDA_SAN { name = "ADVSEC_PDA_SAN"; count = 4; };
            class _xx_ADVSEC_PDA_MED { name = "ADVSEC_PDA_MED"; count = 4; };
            class _xx_ADVSEC_PDA_AT { name = "ADVSEC_PDA_AT"; count = 4; };
            class _xx_ADVSEC_PDA_MG { name = "ADVSEC_PDA_MG"; count = 4; };
            class _xx_ADVSEC_PDA_ENG { name = "ADVSEC_PDA_ENG"; count = 4; };
            class _xx_ADVSEC_PDA_EOD { name = "ADVSEC_PDA_EOD"; count = 4; };
            class _xx_ADVSEC_PDA_AA { name = "ADVSEC_PDA_AA"; count = 4; };
            class _xx_ADVSEC_PDA_GRN { name = "ADVSEC_PDA_GRN"; count = 4; };
            class _xx_ADVSEC_PDA_TANK { name = "ADVSEC_PDA_TANK"; count = 4; };
            class _xx_ADVSEC_PDA_PARA { name = "ADVSEC_PDA_PARA"; count = 4; };
            class _xx_ADVSEC_PDA_PILOT { name = "ADVSEC_PDA_PILOT"; count = 4; };
            class _xx_ADVSEC_PDA_LOG { name = "ADVSEC_PDA_LOG"; count = 4; };
            class _xx_ADVSEC_PDA_ART { name = "ADVSEC_PDA_ART"; count = 4; };
            class _xx_ADVSEC_PDA_MRK { name = "ADVSEC_PDA_MRK"; count = 4; };
            class _xx_ADVSEC_EvidenceBag { name = "ADVSEC_EvidenceBag"; count = 20; };
        };
    };
};
