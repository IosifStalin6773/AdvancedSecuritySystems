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
    // Una PDA por metopa: abre directamente la gestión de esa especialidad
    class ADVSEC_PDA_SpecBase: ADVSEC_PDA_PM {
        scope = 1;
        descriptionShort = "PDA de metopa: miembros, solicitudes, altas y bajas. Tecla Inicio.";
    };
    class ADVSEC_PDA_JTAC: ADVSEC_PDA_SpecBase { scope = 2; displayName = "PDA de metopa: JTAC"; picture = "\x\advsec\addons\main\data\pda_spec_jtac_ca.paa"; };
    class ADVSEC_PDA_RO: ADVSEC_PDA_SpecBase { scope = 2; displayName = "PDA de metopa: Radio operador"; picture = "\x\advsec\addons\main\data\pda_spec_ro_ca.paa"; };
    class ADVSEC_PDA_SAN: ADVSEC_PDA_SpecBase { scope = 2; displayName = "PDA de metopa: Sanitario"; picture = "\x\advsec\addons\main\data\pda_spec_san_ca.paa"; };
    class ADVSEC_PDA_MED: ADVSEC_PDA_SpecBase { scope = 2; displayName = "PDA de metopa: Médico"; picture = "\x\advsec\addons\main\data\pda_spec_med_ca.paa"; };
    class ADVSEC_PDA_AT: ADVSEC_PDA_SpecBase { scope = 2; displayName = "PDA de metopa: Antitanque (AT)"; picture = "\x\advsec\addons\main\data\pda_spec_at_ca.paa"; };
    class ADVSEC_PDA_MG: ADVSEC_PDA_SpecBase { scope = 2; displayName = "PDA de metopa: Ametrallador"; picture = "\x\advsec\addons\main\data\pda_spec_mg_ca.paa"; };
    class ADVSEC_PDA_ENG: ADVSEC_PDA_SpecBase { scope = 2; displayName = "PDA de metopa: Ingeniero"; picture = "\x\advsec\addons\main\data\pda_spec_eng_ca.paa"; };
    class ADVSEC_PDA_EOD: ADVSEC_PDA_SpecBase { scope = 2; displayName = "PDA de metopa: EOD (desactivación)"; picture = "\x\advsec\addons\main\data\pda_spec_eod_ca.paa"; };
    class ADVSEC_PDA_AA: ADVSEC_PDA_SpecBase { scope = 2; displayName = "PDA de metopa: Antiaéreo (AA)"; picture = "\x\advsec\addons\main\data\pda_spec_aa_ca.paa"; };
    class ADVSEC_PDA_GRN: ADVSEC_PDA_SpecBase { scope = 2; displayName = "PDA de metopa: Granadero"; picture = "\x\advsec\addons\main\data\pda_spec_grn_ca.paa"; };
    class ADVSEC_PDA_TANK: ADVSEC_PDA_SpecBase { scope = 2; displayName = "PDA de metopa: Carrista"; picture = "\x\advsec\addons\main\data\pda_spec_tank_ca.paa"; };
    class ADVSEC_PDA_PARA: ADVSEC_PDA_SpecBase { scope = 2; displayName = "PDA de metopa: Paracaidista"; picture = "\x\advsec\addons\main\data\pda_spec_para_ca.paa"; };
    class ADVSEC_PDA_PILOT: ADVSEC_PDA_SpecBase { scope = 2; displayName = "PDA de metopa: Piloto"; picture = "\x\advsec\addons\main\data\pda_spec_pilot_ca.paa"; };
    class ADVSEC_PDA_LOG: ADVSEC_PDA_SpecBase { scope = 2; displayName = "PDA de metopa: Logística"; picture = "\x\advsec\addons\main\data\pda_spec_log_ca.paa"; };
    class ADVSEC_PDA_ART: ADVSEC_PDA_SpecBase { scope = 2; displayName = "PDA de metopa: Artillería"; picture = "\x\advsec\addons\main\data\pda_spec_art_ca.paa"; };
    class ADVSEC_PDA_MRK: ADVSEC_PDA_SpecBase { scope = 2; displayName = "PDA de metopa: Tirador"; picture = "\x\advsec\addons\main\data\pda_spec_mrk_ca.paa"; };
    class ADVSEC_SpeedCamKit: ADVSEC_ItemBase {
        scope = 2;
        displayName = "Radar de tráfico portátil";
        descriptionShort = "Cámara de velocidad desplegable. Menú propio › Mi personaje › Desplegar radar portátil.";
        picture = "\x\advsec\addons\main\data\speedcam_ca.paa";
        class ItemInfo: InventoryItem_Base_F { mass = 60; };
    };
    class ADVSEC_EvidenceBag: ADVSEC_ItemBase {
        scope = 2;
        displayName = "Bolsa de pruebas";
        descriptionShort = "Prueba precintada con cadena de custodia";
        picture = "\A3\ui_f\data\igui\cfg\simpleTasks\types\box_ca.paa";
    };
};
