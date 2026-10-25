class CfgWeapons {
    class ItemCore;
    class InventoryItem_Base_F;
    class ADVSEC_ItemBase: ItemCore {
        scope = 1;
        author = "oscar";
        type = 4096;
        detectRange = -1;
        simulation = "ItemMineDetector";
        model = "\A3\Weapons_F\Ammo\mag_univ.p3d";
        picture = "\A3\ui_f\data\igui\cfg\simpleTasks\types\documents_ca.paa";
        class ItemInfo: InventoryItem_Base_F { mass = 1; };
    };
    class ADVSEC_Passport: ADVSEC_ItemBase {
        scope = 2;
        displayName = "Pasaporte";
        descriptionShort = "Documento de viaje personal";
    };
    class ADVSEC_IDCard: ADVSEC_ItemBase {
        scope = 2;
        displayName = "Tarjeta de identificación";
        descriptionShort = "Identificación con nivel de acceso";
    };
    class ADVSEC_Permit: ADVSEC_ItemBase {
        scope = 2;
        displayName = "Permiso";
        descriptionShort = "Permiso / licencia oficial";
    };
    class ADVSEC_Keycard: ADVSEC_ItemBase {
        scope = 2;
        displayName = "Tarjeta de acceso";
        descriptionShort = "Tarjeta magnética";
        picture = "\A3\ui_f\data\igui\cfg\simpleTasks\types\use_ca.paa";
    };
    class ADVSEC_Key: ADVSEC_ItemBase {
        scope = 2;
        displayName = "Llave";
        descriptionShort = "Llave física";
        picture = "\A3\ui_f\data\igui\cfg\simpleTasks\types\interact_ca.paa";
    };
    class ADVSEC_MilitaryID: ADVSEC_ItemBase {
        scope = 2;
        displayName = "Identificación militar";
        descriptionShort = "Tarjeta de identificación militar personal";
        picture = "\A3\ui_f\data\igui\cfg\simpleTasks\types\meet_ca.paa";
    };
    class ADVSEC_MPBadge: ADVSEC_ItemBase {
        scope = 2;
        displayName = "Placa de Policía Militar";
        descriptionShort = "Acredita al agente de PM";
        picture = "\A3\ui_f\data\igui\cfg\simpleTasks\types\defend_ca.paa";
    };
    class ADVSEC_IABadge: ADVSEC_ItemBase {
        scope = 2;
        displayName = "Credencial de Asuntos Internos";
        descriptionShort = "Acredita al investigador de AA.II.";
        picture = "\A3\ui_f\data\igui\cfg\simpleTasks\types\search_ca.paa";
    };
    class ADVSEC_PDA_PM: ADVSEC_ItemBase {
        scope = 2;
        displayName = "PDA de Policía Militar";
        descriptionShort = "Terminal de campo PM: informes, denuncias y buscados. Tecla Inicio.";
        picture = "\x\advsec\addons\main\data\pda_pm_ca.paa";
        model = "\A3\Structures_F\Items\Electronics\MobilePhone_smart_F.p3d";
        class ItemInfo: InventoryItem_Base_F { mass = 8; };
    };
    class ADVSEC_PDA_AI: ADVSEC_PDA_PM {
        displayName = "PDA de Asuntos Internos";
        descriptionShort = "Terminal de campo AA.II.: expedientes y denuncias recibidas. Tecla Inicio.";
        picture = "\x\advsec\addons\main\data\pda_ai_ca.paa";
    };
    class ADVSEC_PDA_SPEC: ADVSEC_PDA_PM {
        displayName = "PDA de especialidad";
        descriptionShort = "Metopas: miembros, solicitudes, altas y bajas. Tecla Inicio (o Ctrl+Alt+Inicio sin PDA).";
        picture = "\x\advsec\addons\main\data\pda_pm_ca.paa";
    };
    class ADVSEC_EvidenceBag: ADVSEC_ItemBase {
        scope = 2;
        displayName = "Bolsa de pruebas";
        descriptionShort = "Prueba precintada con cadena de custodia";
        picture = "\A3\ui_f\data\igui\cfg\simpleTasks\types\box_ca.paa";
    };
};
