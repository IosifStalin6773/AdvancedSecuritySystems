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
        displayName = "$STR_ADVSEC_passport";
        descriptionShort = "$STR_ADVSEC_personal_travel_document";
    };
    class ADVSEC_IDCard: ADVSEC_ItemBase {
        scope = 2;
        displayName = "$STR_ADVSEC_identity_card";
        descriptionShort = "$STR_ADVSEC_id_with_access_level";
    };
    class ADVSEC_Permit: ADVSEC_ItemBase {
        scope = 2;
        displayName = "$STR_ADVSEC_permit";
        descriptionShort = "$STR_ADVSEC_official_permit_licence";
    };
    class ADVSEC_Keycard: ADVSEC_ItemBase {
        scope = 2;
        displayName = "$STR_ADVSEC_access_card";
        descriptionShort = "$STR_ADVSEC_magnetic_card";
        picture = "\A3\ui_f\data\igui\cfg\simpleTasks\types\use_ca.paa";
    };
    class ADVSEC_Key: ADVSEC_ItemBase {
        scope = 2;
        displayName = "$STR_ADVSEC_key_3";
        descriptionShort = "$STR_ADVSEC_physical_key";
        picture = "\A3\ui_f\data\igui\cfg\simpleTasks\types\interact_ca.paa";
    };
    class ADVSEC_MilitaryID: ADVSEC_ItemBase {
        scope = 2;
        displayName = "$STR_ADVSEC_military_id";
        descriptionShort = "$STR_ADVSEC_personal_military_identity_card";
        picture = "\A3\ui_f\data\igui\cfg\simpleTasks\types\meet_ca.paa";
    };
    class ADVSEC_MPBadge: ADVSEC_ItemBase {
        scope = 2;
        displayName = "$STR_ADVSEC_military_police_badge";
        descriptionShort = "$STR_ADVSEC_accredits_the_mp_officer";
        picture = "\A3\ui_f\data\igui\cfg\simpleTasks\types\defend_ca.paa";
    };
    class ADVSEC_IABadge: ADVSEC_ItemBase {
        scope = 2;
        displayName = "$STR_ADVSEC_internal_affairs_credentials";
        descriptionShort = "$STR_ADVSEC_accredits_the_ia_investigator";
        picture = "\A3\ui_f\data\igui\cfg\simpleTasks\types\search_ca.paa";
    };
    class ADVSEC_PDA_PM: ADVSEC_ItemBase {
        scope = 2;
        displayName = "$STR_ADVSEC_military_police_pda";
        descriptionShort = "$STR_ADVSEC_mp_field_terminal_reports_complaints";
        picture = "\x\advsec\addons\main\data\pda_pm_ca.paa";
        model = "\A3\Structures_F\Items\Electronics\MobilePhone_smart_F.p3d";
        class ItemInfo: InventoryItem_Base_F { mass = 8; };
    };
    class ADVSEC_PDA_AI: ADVSEC_PDA_PM {
        displayName = "$STR_ADVSEC_internal_affairs_pda";
        descriptionShort = "$STR_ADVSEC_ia_field_terminal_case_files";
        picture = "\x\advsec\addons\main\data\pda_ai_ca.paa";
    };
    // Una PDA por metopa: abre directamente la gestión de esa especialidad
    class ADVSEC_PDA_SpecBase: ADVSEC_PDA_PM {
        scope = 1;
        descriptionShort = "$STR_ADVSEC_patch_pda_members_requests_joins";
    };
    class ADVSEC_PDA_JTAC: ADVSEC_PDA_SpecBase { scope = 2; displayName = "$STR_ADVSEC_patch_pda_jtac"; picture = "\x\advsec\addons\main\data\pda_spec_jtac_ca.paa"; };
    class ADVSEC_PDA_RO: ADVSEC_PDA_SpecBase { scope = 2; displayName = "$STR_ADVSEC_patch_pda_radio_operator"; picture = "\x\advsec\addons\main\data\pda_spec_ro_ca.paa"; };
    class ADVSEC_PDA_SAN: ADVSEC_PDA_SpecBase { scope = 2; displayName = "$STR_ADVSEC_patch_pda_combat_medic"; picture = "\x\advsec\addons\main\data\pda_spec_san_ca.paa"; };
    class ADVSEC_PDA_MED: ADVSEC_PDA_SpecBase { scope = 2; displayName = "$STR_ADVSEC_patch_pda_doctor"; picture = "\x\advsec\addons\main\data\pda_spec_med_ca.paa"; };
    class ADVSEC_PDA_AT: ADVSEC_PDA_SpecBase { scope = 2; displayName = "$STR_ADVSEC_patch_pda_anti_tank_at"; picture = "\x\advsec\addons\main\data\pda_spec_at_ca.paa"; };
    class ADVSEC_PDA_MG: ADVSEC_PDA_SpecBase { scope = 2; displayName = "$STR_ADVSEC_patch_pda_machine_gunner"; picture = "\x\advsec\addons\main\data\pda_spec_mg_ca.paa"; };
    class ADVSEC_PDA_ENG: ADVSEC_PDA_SpecBase { scope = 2; displayName = "$STR_ADVSEC_patch_pda_engineer"; picture = "\x\advsec\addons\main\data\pda_spec_eng_ca.paa"; };
    class ADVSEC_PDA_EOD: ADVSEC_PDA_SpecBase { scope = 2; displayName = "$STR_ADVSEC_patch_pda_eod_disposal"; picture = "\x\advsec\addons\main\data\pda_spec_eod_ca.paa"; };
    class ADVSEC_PDA_AA: ADVSEC_PDA_SpecBase { scope = 2; displayName = "$STR_ADVSEC_patch_pda_anti_air_aa"; picture = "\x\advsec\addons\main\data\pda_spec_aa_ca.paa"; };
    class ADVSEC_PDA_GRN: ADVSEC_PDA_SpecBase { scope = 2; displayName = "$STR_ADVSEC_patch_pda_grenadier"; picture = "\x\advsec\addons\main\data\pda_spec_grn_ca.paa"; };
    class ADVSEC_PDA_TANK: ADVSEC_PDA_SpecBase { scope = 2; displayName = "$STR_ADVSEC_patch_pda_tank_crew"; picture = "\x\advsec\addons\main\data\pda_spec_tank_ca.paa"; };
    class ADVSEC_PDA_PARA: ADVSEC_PDA_SpecBase { scope = 2; displayName = "$STR_ADVSEC_patch_pda_paratrooper"; picture = "\x\advsec\addons\main\data\pda_spec_para_ca.paa"; };
    class ADVSEC_PDA_PILOT: ADVSEC_PDA_SpecBase { scope = 2; displayName = "$STR_ADVSEC_patch_pda_pilot"; picture = "\x\advsec\addons\main\data\pda_spec_pilot_ca.paa"; };
    class ADVSEC_PDA_LOG: ADVSEC_PDA_SpecBase { scope = 2; displayName = "$STR_ADVSEC_patch_pda_logistics"; picture = "\x\advsec\addons\main\data\pda_spec_log_ca.paa"; };
    class ADVSEC_PDA_ART: ADVSEC_PDA_SpecBase { scope = 2; displayName = "$STR_ADVSEC_patch_pda_artillery"; picture = "\x\advsec\addons\main\data\pda_spec_art_ca.paa"; };
    class ADVSEC_PDA_MRK: ADVSEC_PDA_SpecBase { scope = 2; displayName = "$STR_ADVSEC_patch_pda_marksman"; picture = "\x\advsec\addons\main\data\pda_spec_mrk_ca.paa"; };
    class ADVSEC_SpeedCamKit: ADVSEC_ItemBase {
        scope = 2;
        displayName = "$STR_ADVSEC_portable_traffic_speed_camera";
        descriptionShort = "$STR_ADVSEC_deployable_speed_camera_self_menu";
        picture = "\x\advsec\addons\main\data\speedcam_ca.paa";
        class ItemInfo: InventoryItem_Base_F { mass = 60; };
    };
    class ADVSEC_HackKit: ADVSEC_ItemBase {
        scope = 2;
        displayName = "$STR_ADVSEC_pmc_hackkit";
        descriptionShort = "$STR_ADVSEC_pmc_hackkit_desc";
        picture = "\A3\ui_f\data\igui\cfg\simpleTasks\types\intel_ca.paa";
        class ItemInfo: InventoryItem_Base_F { mass = 20; };
    };
    class ADVSEC_EvidenceBag: ADVSEC_ItemBase {
        scope = 2;
        displayName = "$STR_ADVSEC_evidence_bag";
        descriptionShort = "$STR_ADVSEC_sealed_evidence_with_chain_of";
        picture = "\x\advsec\addons\main\data\item_evbag_ca.paa";
    };
    // 1.24: objetos de la PM (iconos propios)
    class ADVSEC_CellKeys: ADVSEC_ItemBase { scope = 2; displayName = "$STR_ADVSEC_it_cellkeys"; descriptionShort = "$STR_ADVSEC_it_cellkeys_d"; picture = "\x\advsec\addons\main\data\item_cellkeys_ca.paa"; class ItemInfo: InventoryItem_Base_F { mass = 2; }; };
    class ADVSEC_DeskStamp: ADVSEC_ItemBase { scope = 2; displayName = "$STR_ADVSEC_it_deskstamp"; descriptionShort = "$STR_ADVSEC_it_deskstamp_d"; picture = "\x\advsec\addons\main\data\item_stamp_ca.paa"; class ItemInfo: InventoryItem_Base_F { mass = 3; }; };
    class ADVSEC_Handcuffs: ADVSEC_ItemBase { scope = 2; displayName = "$STR_ADVSEC_it_handcuffs"; descriptionShort = "$STR_ADVSEC_it_handcuffs_d"; picture = "\x\advsec\addons\main\data\item_handcuffs_ca.paa"; class ItemInfo: InventoryItem_Base_F { mass = 4; }; };
    class ADVSEC_LegIrons: ADVSEC_ItemBase { scope = 2; displayName = "$STR_ADVSEC_it_legirons"; descriptionShort = "$STR_ADVSEC_it_legirons_d"; picture = "\x\advsec\addons\main\data\item_legirons_ca.paa"; class ItemInfo: InventoryItem_Base_F { mass = 8; }; };
    class ADVSEC_FPKit: ADVSEC_ItemBase { scope = 2; displayName = "$STR_ADVSEC_it_fpkit"; descriptionShort = "$STR_ADVSEC_it_fpkit_d"; picture = "\x\advsec\addons\main\data\item_fpkit_ca.paa"; class ItemInfo: InventoryItem_Base_F { mass = 6; }; };
    class ADVSEC_DrugKit: ADVSEC_ItemBase { scope = 2; displayName = "$STR_ADVSEC_it_drugkit"; descriptionShort = "$STR_ADVSEC_it_drugkit_d"; picture = "\x\advsec\addons\main\data\item_drugkit_ca.paa"; class ItemInfo: InventoryItem_Base_F { mass = 5; }; };
    class ADVSEC_Breathalyzer: ADVSEC_ItemBase { scope = 2; displayName = "$STR_ADVSEC_it_breathalyzer"; descriptionShort = "$STR_ADVSEC_it_breathalyzer_d"; picture = "\x\advsec\addons\main\data\item_breath_ca.paa"; class ItemInfo: InventoryItem_Base_F { mass = 4; }; };
    class ADVSEC_ScentBag: ADVSEC_ItemBase { scope = 2; displayName = "$STR_ADVSEC_it_scentbag"; descriptionShort = "$STR_ADVSEC_it_scentbag_d"; picture = "\x\advsec\addons\main\data\item_scentbag_ca.paa"; class ItemInfo: InventoryItem_Base_F { mass = 2; }; };
    class ADVSEC_RightsCard: ADVSEC_ItemBase { scope = 2; displayName = "$STR_ADVSEC_it_rightscard"; descriptionShort = "$STR_ADVSEC_it_rightscard_d"; picture = "\x\advsec\addons\main\data\item_rightscard_ca.paa"; class ItemInfo: InventoryItem_Base_F { mass = 1; }; };
    class ADVSEC_InspMirror: ADVSEC_ItemBase { scope = 2; displayName = "$STR_ADVSEC_it_inspmirror"; descriptionShort = "$STR_ADVSEC_it_inspmirror_d"; picture = "\x\advsec\addons\main\data\item_mirror_ca.paa"; class ItemInfo: InventoryItem_Base_F { mass = 10; }; };
    class ADVSEC_BoltCutter: ADVSEC_ItemBase { scope = 2; displayName = "$STR_ADVSEC_it_boltcutter"; descriptionShort = "$STR_ADVSEC_it_boltcutter_d"; picture = "\x\advsec\addons\main\data\item_boltcutter_ca.paa"; class ItemInfo: InventoryItem_Base_F { mass = 25; }; };
    class ADVSEC_Stopwatch: ADVSEC_ItemBase { scope = 2; displayName = "$STR_ADVSEC_it_stopwatch"; descriptionShort = "$STR_ADVSEC_it_stopwatch_d"; picture = "\x\advsec\addons\main\data\item_stopwatch_ca.paa"; class ItemInfo: InventoryItem_Base_F { mass = 2; }; };
    class ADVSEC_MeasureTape: ADVSEC_ItemBase { scope = 2; displayName = "$STR_ADVSEC_it_measuretape"; descriptionShort = "$STR_ADVSEC_it_measuretape_d"; picture = "\x\advsec\addons\main\data\item_tape_ca.paa"; class ItemInfo: InventoryItem_Base_F { mass = 3; }; };
    class ADVSEC_CitationBook: ADVSEC_ItemBase { scope = 2; displayName = "$STR_ADVSEC_it_citationbook"; descriptionShort = "$STR_ADVSEC_it_citationbook_d"; picture = "\x\advsec\addons\main\data\item_citation_ca.paa"; class ItemInfo: InventoryItem_Base_F { mass = 2; }; };
    class ADVSEC_Whistle: ADVSEC_ItemBase { scope = 2; displayName = "$STR_ADVSEC_it_whistle"; descriptionShort = "$STR_ADVSEC_it_whistle_d"; picture = "\x\advsec\addons\main\data\item_whistle_ca.paa"; class ItemInfo: InventoryItem_Base_F { mass = 1; }; };
    class ADVSEC_Blotter: ADVSEC_ItemBase { scope = 2; displayName = "$STR_ADVSEC_it_blotter"; descriptionShort = "$STR_ADVSEC_it_blotter_d"; picture = "\x\advsec\addons\main\data\item_blotter_ca.paa"; class ItemInfo: InventoryItem_Base_F { mass = 8; }; };
    class ADVSEC_CastKit: ADVSEC_ItemBase { scope = 2; displayName = "$STR_ADVSEC_it_castkit"; descriptionShort = "$STR_ADVSEC_it_castkit_d"; picture = "\x\advsec\addons\main\data\item_castkit_ca.paa"; class ItemInfo: InventoryItem_Base_F { mass = 10; }; };
    class ADVSEC_Flares: ADVSEC_ItemBase { scope = 2; displayName = "$STR_ADVSEC_it_flares"; descriptionShort = "$STR_ADVSEC_it_flares_d"; picture = "\x\advsec\addons\main\data\item_flares_ca.paa"; class ItemInfo: InventoryItem_Base_F { mass = 6; }; };
    class ADVSEC_PrisonerTags: ADVSEC_ItemBase { scope = 2; displayName = "$STR_ADVSEC_it_prisonertags"; descriptionShort = "$STR_ADVSEC_it_prisonertags_d"; picture = "\x\advsec\addons\main\data\item_tags_ca.paa"; class ItemInfo: InventoryItem_Base_F { mass = 1; }; };
    class ADVSEC_SteeringLock: ADVSEC_ItemBase { scope = 2; displayName = "$STR_ADVSEC_it_steeringlock"; descriptionShort = "$STR_ADVSEC_it_steeringlock_d"; picture = "\x\advsec\addons\main\data\item_chain_ca.paa"; class ItemInfo: InventoryItem_Base_F { mass = 12; }; };
    class ADVSEC_Brassard: ADVSEC_ItemBase { scope = 2; displayName = "$STR_ADVSEC_it_brassard"; descriptionShort = "$STR_ADVSEC_it_brassard_d"; picture = "\x\advsec\addons\main\data\item_brassard_ca.paa"; class ItemInfo: InventoryItem_Base_F { mass = 1; }; };
    class ADVSEC_SeizedCash: ADVSEC_ItemBase { scope = 2; displayName = "$STR_ADVSEC_it_seizedcash"; descriptionShort = "$STR_ADVSEC_it_seizedcash_d"; picture = "\x\advsec\addons\main\data\item_cash_ca.paa"; class ItemInfo: InventoryItem_Base_F { mass = 1; }; };
    class ADVSEC_Penlight: ADVSEC_ItemBase { scope = 2; displayName = "$STR_ADVSEC_it_penlight"; descriptionShort = "$STR_ADVSEC_it_penlight_d"; picture = "\x\advsec\addons\main\data\item_penlight_ca.paa"; class ItemInfo: InventoryItem_Base_F { mass = 1; }; };
    class ADVSEC_Gloves: ADVSEC_ItemBase { scope = 2; displayName = "$STR_ADVSEC_it_gloves"; descriptionShort = "$STR_ADVSEC_it_gloves_d"; picture = "\x\advsec\addons\main\data\item_gloves_ca.paa"; class ItemInfo: InventoryItem_Base_F { mass = 1; }; };
    class ADVSEC_SceneMarkers: ADVSEC_ItemBase { scope = 2; displayName = "$STR_ADVSEC_it_scenemarkers"; descriptionShort = "$STR_ADVSEC_it_scenemarkers_d"; picture = "\x\advsec\addons\main\data\item_chalk_ca.paa"; class ItemInfo: InventoryItem_Base_F { mass = 3; }; };
    class ADVSEC_Notebook: ADVSEC_ItemBase { scope = 2; displayName = "$STR_ADVSEC_it_notebook"; descriptionShort = "$STR_ADVSEC_it_notebook_d"; picture = "\x\advsec\addons\main\data\item_notebook_ca.paa"; class ItemInfo: InventoryItem_Base_F { mass = 1; }; };
    class ADVSEC_SceneTape: ADVSEC_ItemBase { scope = 2; displayName = "$STR_ADVSEC_it_scenetape"; descriptionShort = "$STR_ADVSEC_it_scenetape_d"; picture = "\x\advsec\addons\main\data\item_scenetape_ca.paa"; class ItemInfo: InventoryItem_Base_F { mass = 5; }; };
    class ADVSEC_KeyRing: ADVSEC_ItemBase { scope = 2; displayName = "$STR_ADVSEC_it_keyring"; descriptionShort = "$STR_ADVSEC_it_keyring_d"; picture = "\x\advsec\addons\main\data\item_keyring_ca.paa"; class ItemInfo: InventoryItem_Base_F { mass = 2; }; };
    class ADVSEC_OffLimits: ADVSEC_ItemBase { scope = 2; displayName = "$STR_ADVSEC_it_offlimits"; descriptionShort = "$STR_ADVSEC_it_offlimits_d"; picture = "\x\advsec\addons\main\data\item_offlimits_ca.paa"; class ItemInfo: InventoryItem_Base_F { mass = 1; }; };
};
