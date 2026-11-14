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
        displayName = "$STR_ADVSEC_cctv_camera_2";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\scout_ca.paa";
        function = "ADVSEC_fnc_moduleCamera";
        class Attributes: AttributesBase {
            class Name: Edit { property = "ADVSEC_Cam_Name"; displayName = "$STR_ADVSEC_name"; typeName = "STRING"; defaultValue = """CAM"""; };
            class Network: Edit { property = "ADVSEC_Cam_Network"; displayName = "$STR_ADVSEC_cctv_network"; tooltip = "$STR_ADVSEC_monitors_on_the_same_network"; typeName = "STRING"; defaultValue = """default"""; };
            class Pitch: Combo {
                property = "ADVSEC_Cam_Pitch"; displayName = "$STR_ADVSEC_tilt"; typeName = "NUMBER"; defaultValue = "-20";
                class Values {
                    class P0 { name = "Horizontal"; value = 0; };
                    class P10 { name = "$STR_ADVSEC_slight_10o"; value = -10; };
                    class P20 { name = "$STR_ADVSEC_medium_20o"; value = -20; };
                    class P35 { name = "$STR_ADVSEC_steep_35o"; value = -35; };
                    class P60 { name = "$STR_ADVSEC_top_down_60o"; value = -60; };
                };
            };
            class Yaw: Edit { property = "ADVSEC_Cam_Yaw"; displayName = "$STR_ADVSEC_extra_rotation_o"; typeName = "NUMBER"; defaultValue = "0"; };
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = "$STR_ADVSEC_sync_with_objects_to_use";
        };
    };
    class ADVSEC_ModuleMonitor: ADVSEC_Module_Base {
        scope = 2;
        displayName = "$STR_ADVSEC_cctv_monitor_2";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\scout_ca.paa";
        function = "ADVSEC_fnc_moduleMonitor";
        class Attributes: AttributesBase {
            class Network: Edit { property = "ADVSEC_Mon_Network"; displayName = "$STR_ADVSEC_cctv_network"; typeName = "STRING"; defaultValue = """default"""; };
            REQ_ATTRS(ADVSEC_Mon)
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = "$STR_ADVSEC_sync_with_the_monitor_laptop";
        };
    };
    class ADVSEC_ModuleKeypad: ADVSEC_Module_Base {
        scope = 2;
        displayName = "$STR_ADVSEC_keypad_access_control";
        function = "ADVSEC_fnc_moduleKeypad";
        class Attributes: AttributesBase {
            class Pin: Edit { property = "ADVSEC_Kp_Pin"; displayName = "PIN"; typeName = "STRING"; defaultValue = """1234"""; };
            class Doors: Edit { property = "ADVSEC_Kp_Doors"; displayName = "$STR_ADVSEC_doors"; tooltip = "$STR_ADVSEC_comma_separated_indexes_or_all"; typeName = "STRING"; defaultValue = """all"""; };
            class Zone: Edit { property = "ADVSEC_Kp_Zone"; displayName = "$STR_ADVSEC_alarm_zone"; tooltip = "$STR_ADVSEC_zone_of_the_linked_alarm"; typeName = "STRING"; defaultValue = """"""; };
            class Label: Edit { property = "ADVSEC_Kp_Label"; displayName = "$STR_ADVSEC_label"; typeName = "STRING"; defaultValue = """INTRODUZCA PIN"""; };
            REQ_ATTRS(ADVSEC_Kp)
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = "$STR_ADVSEC_sync_with_the_keypad_object";
        };
    };
    class ADVSEC_ModuleDoor: ADVSEC_Module_Base {
        scope = 2;
        displayName = "$STR_ADVSEC_door_lock";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\use_ca.paa";
        function = "ADVSEC_fnc_moduleDoor";
        class Attributes: AttributesBase {
            class Doors: Edit { property = "ADVSEC_Door_Doors"; displayName = "$STR_ADVSEC_doors"; tooltip = "$STR_ADVSEC_comma_separated_indexes_or_all"; typeName = "STRING"; defaultValue = """all"""; };
            class Locked: Checkbox { property = "ADVSEC_Door_Locked"; displayName = "$STR_ADVSEC_locked_at_start"; typeName = "BOOL"; defaultValue = "true"; };
            REQ_ATTRS(ADVSEC_Door)
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = "$STR_ADVSEC_sync_with_the_building_or";
        };
    };
    class ADVSEC_ModuleAlarm: ADVSEC_Module_Base {
        scope = 2;
        displayName = "$STR_ADVSEC_alarm";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\danger_ca.paa";
        function = "ADVSEC_fnc_moduleAlarm";
        class Attributes: AttributesBase {
            class Name: Edit { property = "ADVSEC_Al_Name"; displayName = "$STR_ADVSEC_name"; typeName = "STRING"; defaultValue = """Alarma"""; };
            class Zone: Edit { property = "ADVSEC_Al_Zone"; displayName = "$STR_ADVSEC_zone_2"; tooltip = "$STR_ADVSEC_id_to_link_keypads"; typeName = "STRING"; defaultValue = """zona1"""; };
            class Radius: Edit { property = "ADVSEC_Al_Radius"; displayName = "$STR_ADVSEC_radius_m"; typeName = "NUMBER"; defaultValue = "15"; };
            class Doors: Edit { property = "ADVSEC_Al_Doors"; displayName = "$STR_ADVSEC_watched_doors"; tooltip = "$STR_ADVSEC_indexes_all_every_door_empty"; typeName = "STRING"; defaultValue = """"""; };
            class Armed: Checkbox { property = "ADVSEC_Al_Armed"; displayName = "$STR_ADVSEC_armed_at_start"; typeName = "BOOL"; defaultValue = "true"; };
            REQ_ATTRS(ADVSEC_Al)
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = "$STR_ADVSEC_sync_with_the_speaker_optional";
        };
    };
    class ADVSEC_ModuleIssuer: ADVSEC_Module_Base {
        scope = 2;
        displayName = "$STR_ADVSEC_document_office_2";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\documents_ca.paa";
        function = "ADVSEC_fnc_moduleIssuer";
        class Attributes: AttributesBase {
            class Issuer: Edit { property = "ADVSEC_Iss_Name"; displayName = "$STR_ADVSEC_issuer"; typeName = "STRING"; defaultValue = """Ministerio del Interior"""; };
            class Types: Edit { property = "ADVSEC_Iss_Types"; displayName = "$STR_ADVSEC_issuable_types"; tooltip = "$STR_ADVSEC_empty_all"; typeName = "STRING"; defaultValue = """"""; };
            class MaxClearance: Combo {
                property = "ADVSEC_Iss_Max"; displayName = "$STR_ADVSEC_maximum_level_it_can_issue"; typeName = "NUMBER"; defaultValue = "3";
                class Values {
                    class L0 { name = "$STR_ADVSEC_level_0"; value = 0; };
                    class L1 { name = "$STR_ADVSEC_level_1"; value = 1; };
                    class L2 { name = "$STR_ADVSEC_level_2_2"; value = 2; };
                    class L3 { name = "$STR_ADVSEC_level_3"; value = 3; };
                    class L4 { name = "$STR_ADVSEC_level_4"; value = 4; };
                    class L5 { name = "$STR_ADVSEC_level_5"; value = 5; };
                };
            };
            REQ_ATTRS(ADVSEC_Iss)
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = "$STR_ADVSEC_sync_with_the_office_object";
        };
    };

    class ADVSEC_ModuleReports: ADVSEC_Module_Base {
        scope = 2;
        displayName = "$STR_ADVSEC_mp_ia_reports_terminal";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\documents_ca.paa";
        function = "ADVSEC_fnc_moduleReports";
        class Attributes: AttributesBase {
            class Dept: Combo {
                property = "ADVSEC_Rep_Dept";
                displayName = "$STR_ADVSEC_department";
                typeName = "STRING";
                defaultValue = """PM""";
                class Values {
                    class PM { name = "$STR_ADVSEC_military_police"; value = "PM"; };
                    class AI { name = "$STR_ADVSEC_internal_affairs"; value = "AI"; };
                    class BOTH { name = "$STR_ADVSEC_both"; value = "BOTH"; };
                };
            };
            REQ_ATTRS(ADVSEC_Rep)
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = "$STR_ADVSEC_sync_with_the_computer_archive";
        };
    };

    class ADVSEC_ModuleAtm: ADVSEC_Module_Base {
        scope = 2;
        displayName = "$STR_ADVSEC_cash_machine";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\box_ca.paa";
        function = "ADVSEC_fnc_moduleAtm";
        class Attributes: AttributesBase {
            class Name: Edit { property = "ADVSEC_Atm_Name"; displayName = "$STR_ADVSEC_name"; typeName = "STRING"; defaultValue = """Cajero automático"""; };
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = "$STR_ADVSEC_sync_it_with_any_object";
        };
    };
    class ADVSEC_ModuleShop: ADVSEC_Module_Base {
        scope = 2;
        displayName = "$STR_ADVSEC_shop";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\box_ca.paa";
        function = "ADVSEC_fnc_moduleShop";
        class Attributes: AttributesBase {
            class Name: Edit { property = "ADVSEC_Shop_Name"; displayName = "$STR_ADVSEC_name"; typeName = "STRING"; defaultValue = """Tienda"""; };
            class Items: Edit { property = "ADVSEC_Shop_Items"; displayName = "$STR_ADVSEC_items"; tooltip = "$STR_ADVSEC_pick_category_and_item_with"; typeName = "STRING"; control = "ADVSEC_CatalogItems"; defaultValue = """"""; };
            class Hidden: CheckboxNumber { property = "ADVSEC_Shop_Hidden"; displayName = "$STR_ADVSEC_black_market_hidden"; tooltip = "$STR_ADVSEC_no_name_only_within_2"; defaultValue = "0"; };
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = "$STR_ADVSEC_sync_it_with_a_table";
        };
    };
    class ADVSEC_ModuleDealer: ADVSEC_Module_Base {
        scope = 2;
        displayName = "$STR_ADVSEC_vehicle_dealer";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\car_ca.paa";
        function = "ADVSEC_fnc_moduleDealer";
        class Attributes: AttributesBase {
            class Name: Edit { property = "ADVSEC_Dealer_Name"; displayName = "$STR_ADVSEC_name"; typeName = "STRING"; defaultValue = """Concesionario"""; };
            class Items: Edit { property = "ADVSEC_Dealer_Items"; displayName = "$STR_ADVSEC_vehicles"; tooltip = "$STR_ADVSEC_pick_category_and_vehicle_with"; typeName = "STRING"; control = "ADVSEC_CatalogVehicles"; defaultValue = """"""; };
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = "$STR_ADVSEC_sells_vehicles_registered_to_the";
        };
    };
    class ADVSEC_ModuleDuty: ADVSEC_Module_Base {
        scope = 2;
        displayName = "$STR_ADVSEC_duty_terminal_2";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\wait_ca.paa";
        function = "ADVSEC_fnc_moduleDuty";
        class Attributes: AttributesBase {
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = "$STR_ADVSEC_mp_and_ia_clock_in";
        };
    };
    class ADVSEC_ModuleSpeedCam: ADVSEC_Module_Base {
        scope = 2;
        displayName = "$STR_ADVSEC_fixed_speed_camera_2";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\car_ca.paa";
        function = "ADVSEC_fnc_moduleSpeedCam";
        class Attributes: AttributesBase {
            class Name: Edit { property = "ADVSEC_SC_Name"; displayName = "$STR_ADVSEC_name"; typeName = "STRING"; defaultValue = """Radar"""; };
            class Limit: Edit { property = "ADVSEC_SC_Limit"; displayName = "$STR_ADVSEC_limit_km_h"; tooltip = "$STR_ADVSEC_0_speedlimit_from_advsec_settings"; typeName = "NUMBER"; defaultValue = "0"; };
            class Range: Edit { property = "ADVSEC_SC_Range"; displayName = "$STR_ADVSEC_range_m"; typeName = "NUMBER"; defaultValue = "40"; };
            class FineBase: Edit { property = "ADVSEC_SC_Base"; displayName = "$STR_ADVSEC_base_fine"; tooltip = "0 = speedFineBase"; typeName = "NUMBER"; defaultValue = "0"; };
            class FinePer: Edit { property = "ADVSEC_SC_Per"; displayName = "$STR_ADVSEC_fine_per_km_h_over"; tooltip = "0 = speedFinePerKmh"; typeName = "NUMBER"; defaultValue = "0"; };
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = "$STR_ADVSEC_fixed_speed_camera_automatically_fines";
        };
    };
    class ADVSEC_ModuleAdmin: ADVSEC_Module_Base {
        scope = 2;
        displayName = "$STR_ADVSEC_superadmin_terminal_2";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\intel_ca.paa";
        function = "ADVSEC_fnc_moduleAdmin";
        class Attributes: AttributesBase {
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = "$STR_ADVSEC_sync_with_a_computer_or";
        };
    };

    class ADVSEC_ModuleJail: ADVSEC_Module_Base {
        scope = 2;
        displayName = "$STR_ADVSEC_cell_detention_centre";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\wait_ca.paa";
        function = "ADVSEC_fnc_moduleJail";
        class Attributes: AttributesBase {
            class Name: Edit { property = "ADVSEC_Jail_Name"; displayName = "$STR_ADVSEC_name"; typeName = "STRING"; defaultValue = """Calabozo PM"""; };
            class Radius: Combo {
                property = "ADVSEC_Jail_Radius"; displayName = "$STR_ADVSEC_radius"; typeName = "NUMBER"; defaultValue = "6";
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
            description = "$STR_ADVSEC_place_it_inside_the_cell";
        };
    };

    class ADVSEC_ModuleLab: ADVSEC_Module_Base {
        scope = 2;
        displayName = "$STR_ADVSEC_forensic_lab_2";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\search_ca.paa";
        function = "ADVSEC_fnc_moduleLab";
        class Attributes: AttributesBase {
            class Name: Edit { property = "ADVSEC_Lab_Name"; displayName = "$STR_ADVSEC_name"; typeName = "STRING"; defaultValue = """Laboratorio forense"""; };
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = "$STR_ADVSEC_sync_it_with_a_table_2";
        };
    };
    class ADVSEC_ModuleCheckpoint: ADVSEC_Module_Base {
        scope = 2;
        isGlobal = 0;
        displayName = "$STR_ADVSEC_road_checkpoint_ai_2";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\car_ca.paa";
        function = "ADVSEC_fnc_moduleCheckpoint";
        class Attributes: AttributesBase {
            class Name: Edit { property = "ADVSEC_Cp_Name"; displayName = "$STR_ADVSEC_name"; typeName = "STRING"; defaultValue = """Control PM"""; };
            class SpawnUnits: Combo {
                property = "ADVSEC_Cp_Units"; displayName = "$STR_ADVSEC_new_officers_if_no_units"; typeName = "NUMBER"; defaultValue = "2";
                class Values {
                    class U0 { name = "$STR_ADVSEC_none_2"; value = 0; };
                    class U2 { name = "2"; value = 2; };
                    class U4 { name = "4"; value = 4; };
                };
            };
            class Radius: Combo {
                property = "ADVSEC_Cp_Radius"; displayName = "$STR_ADVSEC_radius"; typeName = "NUMBER"; defaultValue = "20";
                class Values {
                    class R10 { name = "10 m"; value = 10; };
                    class R20 { name = "20 m"; value = 20; };
                    class R35 { name = "35 m"; value = 35; };
                };
            };
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = "$STR_ADVSEC_place_it_on_the_road";
        };
    };

    // ===== Zeus =====
    class ADVSEC_ModuleContractZone: ADVSEC_Module_Base {
        scope = 2;
        isGlobal = 0;
        displayName = "$STR_ADVSEC_pmc_mod_zone";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\interact_ca.paa";
        function = "ADVSEC_fnc_moduleContractZone";
        class Attributes: AttributesBase {
            class Name: Edit { property = "ADVSEC_CtrZone_Name"; displayName = "$STR_ADVSEC_name"; typeName = "STRING"; defaultValue = """Zona de encargos"""; };
            class Radius: Combo {
                property = "ADVSEC_CtrZone_Radius"; displayName = "$STR_ADVSEC_radius"; typeName = "NUMBER"; defaultValue = "300";
                class Values {
                    class R150 { name = "150 m"; value = 150; };
                    class R300 { name = "300 m"; value = 300; };
                    class R600 { name = "600 m"; value = 600; };
                    class R1000 { name = "1000 m"; value = 1000; };
                };
            };
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = "$STR_ADVSEC_pmc_mod_zone_desc";
        };
    };

    class ADVSEC_ModuleContractHostile: ADVSEC_Module_Base {
        scope = 2;
        isGlobal = 0;
        displayName = "$STR_ADVSEC_pmc_mod_hostile";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\interact_ca.paa";
        function = "ADVSEC_fnc_moduleContractHostile";
        class Attributes: AttributesBase {
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = "$STR_ADVSEC_pmc_mod_hostile_desc";
        };
    };

    class ADVSEC_ModuleContractCustom: ADVSEC_Module_Base {
        scope = 2;
        isGlobal = 0;            // solo servidor: crea la oferta del encargo al empezar la misión
        displayName = "$STR_ADVSEC_pmc_mod_custom";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\documents_ca.paa";
        function = "ADVSEC_fnc_moduleContractCustom";
        canSetArea = 1;
        canSetAreaShape = 0;
        class AttributeValues {
            size3[] = {150, 150, -1};
            isRectangle = 0;
        };
        class Attributes: AttributesBase {
            class Type: Combo {
                property = "ADVSEC_CC_Type"; displayName = "$STR_ADVSEC_pmc_type"; typeName = "STRING"; defaultValue = """checkpoint""";
                class Values {
                    class escort { name = "$STR_ADVSEC_pmc_type_escort"; value = "escort"; };
                    class vip { name = "$STR_ADVSEC_pmc_type_vip"; value = "vip"; };
                    class guard { name = "$STR_ADVSEC_pmc_type_guard"; value = "guard"; };
                    class checkpoint { name = "$STR_ADVSEC_pmc_type_checkpoint"; value = "checkpoint"; };
                    class qrf { name = "$STR_ADVSEC_pmc_type_qrf"; value = "qrf"; };
                    class recovery { name = "$STR_ADVSEC_pmc_type_recovery"; value = "recovery"; };
                    class clear { name = "$STR_ADVSEC_pmc_type_clear"; value = "clear"; };
                };
            };
            class ClientName: Edit { property = "ADVSEC_CC_ClientName"; displayName = "$STR_ADVSEC_pmc_cc_clientname"; tooltip = "$STR_ADVSEC_pmc_cc_clientname_tip"; typeName = "STRING"; defaultValue = """"""; };
            class Client: Combo {
                property = "ADVSEC_CC_Client"; displayName = "$STR_ADVSEC_pmc_cc_client"; tooltip = "$STR_ADVSEC_pmc_cc_client_tip"; typeName = "STRING"; defaultValue = """Corp""";
                class Values {
                    class Gov { name = "$STR_ADVSEC_pmc_cl_gov"; value = "Gov"; };
                    class Corp { name = "$STR_ADVSEC_pmc_cl_corp"; value = "Corp"; };
                    class NGO { name = "$STR_ADVSEC_pmc_cl_ngo"; value = "NGO"; };
                    class Cartel { name = "$STR_ADVSEC_pmc_cl_cartel"; value = "Cartel"; };
                };
            };
            class Side: Combo {
                property = "ADVSEC_CC_Side"; displayName = "$STR_ADVSEC_pmc_cc_side"; tooltip = "$STR_ADVSEC_pmc_cc_side_tip"; typeName = "STRING"; defaultValue = """""";
                class Values {
                    class Def { name = "$STR_ADVSEC_pmc_host_m_def"; value = ""; };
                    class East { name = "OPFOR (East)"; value = "east"; };
                    class West { name = "BLUFOR (West)"; value = "west"; };
                    class Indep { name = "INDEP (Independent)"; value = "independent"; };
                    class Civ { name = "$STR_ADVSEC_pmc_side_civ"; value = "civilian"; };
                };
            };
            class Units: Edit { property = "ADVSEC_CC_Units"; displayName = "$STR_ADVSEC_pmc_cc_units"; tooltip = "$STR_ADVSEC_pmc_cc_units_tip"; typeName = "STRING"; control = "ADVSEC_CatalogUnits"; defaultValue = """"""; };
            class Count: Edit { property = "ADVSEC_CC_Count"; displayName = "$STR_ADVSEC_pmc_cc_count"; tooltip = "$STR_ADVSEC_pmc_cc_count_tip"; typeName = "NUMBER"; defaultValue = "-1"; };
            class Pay: Edit { property = "ADVSEC_CC_Pay"; displayName = "$STR_ADVSEC_pmc_pay0"; typeName = "NUMBER"; defaultValue = "0"; };
            class Minutes: Edit { property = "ADVSEC_CC_Minutes"; displayName = "$STR_ADVSEC_pmc_minutes0"; typeName = "NUMBER"; defaultValue = "0"; };
            class Title: Edit { property = "ADVSEC_CC_Title"; displayName = "$STR_ADVSEC_pmc_title"; typeName = "STRING"; defaultValue = """"""; };
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = "$STR_ADVSEC_pmc_mod_custom_desc";
        };
    };

    class ADVSEC_ModuleContract: ADVSEC_Module_Base {
        scope = 2;
        displayName = "$STR_ADVSEC_pmc_terminal";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\documents_ca.paa";
        function = "ADVSEC_fnc_moduleContract";
        class Attributes: AttributesBase {
            class Name: Edit { property = "ADVSEC_Contract_Name"; displayName = "$STR_ADVSEC_name"; typeName = "STRING"; defaultValue = """Terminal de contratos"""; };
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = "$STR_ADVSEC_pmc_mod_contract_desc";
        };
    };
    class ADVSEC_ModuleArmory: ADVSEC_Module_Base {
        scope = 2;
        displayName = "$STR_ADVSEC_pmc_armory";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\rifle_ca.paa";
        function = "ADVSEC_fnc_moduleArmory";
        class Attributes: AttributesBase {
            class Name: Edit { property = "ADVSEC_Armory_Name"; displayName = "$STR_ADVSEC_name"; typeName = "STRING"; defaultValue = """Armería corporativa"""; };
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = "$STR_ADVSEC_pmc_mod_armory_desc";
        };
    };
    class ADVSEC_ModuleCyber: ADVSEC_Module_Base {
        scope = 2;
        displayName = "$STR_ADVSEC_pmc_cy_terminal";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\intel_ca.paa";
        function = "ADVSEC_fnc_moduleCyber";
        class Attributes: AttributesBase {
            class Name: Edit { property = "ADVSEC_Cyber_Name"; displayName = "$STR_ADVSEC_name"; typeName = "STRING"; defaultValue = """Terminal ciber"""; };
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            description = "$STR_ADVSEC_pmc_mod_cyber_desc";
        };
    };
    class ADVSEC_Zeus_Base: ADVSEC_Module_Base {
        scope = 1;
        scopeCurator = 2;
        curatorCanAttach = 1;
        isGlobal = 1;            // solo hace falta en la máquina del Zeus; el init se reparte con remoteExec (JIP)
        function = "ADVSEC_fnc_zeusModule";
    };
    class ADVSEC_ZeusCamera: ADVSEC_Zeus_Base {
        displayName = "$STR_ADVSEC_cctv_camera_2";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\scout_ca.paa";
        ADVSEC_kind = "camera";
    };
    class ADVSEC_ZeusMonitor: ADVSEC_Zeus_Base {
        displayName = "$STR_ADVSEC_cctv_monitor_2";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\scout_ca.paa";
        ADVSEC_kind = "monitor";
    };
    class ADVSEC_ZeusKeypad: ADVSEC_Zeus_Base {
        displayName = "$STR_ADVSEC_keypad_access_control";
        ADVSEC_kind = "keypad";
    };
    class ADVSEC_ZeusDoor: ADVSEC_Zeus_Base {
        displayName = "$STR_ADVSEC_door_lock";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\use_ca.paa";
        ADVSEC_kind = "door";
    };
    class ADVSEC_ZeusAlarm: ADVSEC_Zeus_Base {
        displayName = "$STR_ADVSEC_alarm";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\danger_ca.paa";
        ADVSEC_kind = "alarm";
    };
    class ADVSEC_ZeusIssuer: ADVSEC_Zeus_Base {
        displayName = "$STR_ADVSEC_document_office_2";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\documents_ca.paa";
        ADVSEC_kind = "issuer";
    };
    class ADVSEC_ZeusReports: ADVSEC_Zeus_Base {
        displayName = "$STR_ADVSEC_mp_ia_reports_terminal";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\documents_ca.paa";
        ADVSEC_kind = "reports";
    };
    class ADVSEC_ZeusJail: ADVSEC_Zeus_Base {
        displayName = "$STR_ADVSEC_cell_detention_centre";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\wait_ca.paa";
        ADVSEC_kind = "jail";
    };
    class ADVSEC_ZeusPanel: ADVSEC_Zeus_Base {
        displayName = "$STR_ADVSEC_security_panel";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\map_ca.paa";
        ADVSEC_kind = "panel";
    };
    class ADVSEC_ZeusPolice: ADVSEC_Zeus_Base {
        displayName = "$STR_ADVSEC_military_police_actions_on_unit";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\defend_ca.paa";
        ADVSEC_kind = "police";
    };
    class ADVSEC_ZeusLab: ADVSEC_Zeus_Base {
        displayName = "$STR_ADVSEC_forensic_lab_2";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\search_ca.paa";
        ADVSEC_kind = "lab";
    };
    class ADVSEC_ZeusCheckpoint: ADVSEC_Zeus_Base {
        displayName = "$STR_ADVSEC_road_checkpoint_ai_2";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\car_ca.paa";
        ADVSEC_kind = "checkpoint";
    };
    class ADVSEC_ZeusAtm: ADVSEC_Zeus_Base {
        displayName = "$STR_ADVSEC_cash_machine";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\box_ca.paa";
        ADVSEC_kind = "atm";
    };
    class ADVSEC_ZeusShop: ADVSEC_Zeus_Base {
        displayName = "$STR_ADVSEC_shop";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\box_ca.paa";
        ADVSEC_kind = "shop";
    };
    class ADVSEC_ZeusDealer: ADVSEC_Zeus_Base {
        displayName = "$STR_ADVSEC_vehicle_dealer";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\car_ca.paa";
        ADVSEC_kind = "dealer";
    };
    class ADVSEC_ZeusDuty: ADVSEC_Zeus_Base {
        displayName = "$STR_ADVSEC_duty_terminal_2";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\wait_ca.paa";
        ADVSEC_kind = "duty";
    };
    class ADVSEC_ZeusSpeedCam: ADVSEC_Zeus_Base {
        displayName = "$STR_ADVSEC_fixed_speed_camera_2";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\car_ca.paa";
        ADVSEC_kind = "speedcam";
    };
    class ADVSEC_ZeusAdmin: ADVSEC_Zeus_Base {
        displayName = "$STR_ADVSEC_superadmin_terminal_2";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\intel_ca.paa";
        ADVSEC_kind = "admin";
    };
    class ADVSEC_ZeusContract: ADVSEC_Zeus_Base {
        displayName = "$STR_ADVSEC_pmc_terminal";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\documents_ca.paa";
        ADVSEC_kind = "contract";
    };
    class ADVSEC_ZeusContractOffer: ADVSEC_Zeus_Base {
        displayName = "$STR_ADVSEC_pmc_offer_title";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\documents_ca.paa";
        ADVSEC_kind = "contractOffer";
    };
    class ADVSEC_ZeusArmory: ADVSEC_Zeus_Base {
        displayName = "$STR_ADVSEC_pmc_armory";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\rifle_ca.paa";
        ADVSEC_kind = "armory";
    };
    class ADVSEC_ZeusCyber: ADVSEC_Zeus_Base {
        displayName = "$STR_ADVSEC_pmc_cy_terminal";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\intel_ca.paa";
        ADVSEC_kind = "cyber";
    };
    // Objetos sueltos en Eden/Zeus (Equipo > Objetos de inventario) y caja con todo el material ADVSEC
    class Item_Base_F;
#define ADVSEC_GROUND(C,N) class Item_##C: Item_Base_F { scope = 2; scopeCurator = 2; author = "oscar"; displayName = N; editorCategory = "EdCat_Equipment"; editorSubcategory = "EdSubcat_InventoryItems"; vehicleClass = "Items"; class TransportItems { class C { name = #C; count = 1; }; }; }
    ADVSEC_GROUND(ADVSEC_Passport,"$STR_ADVSEC_passport");
    ADVSEC_GROUND(ADVSEC_IDCard,"$STR_ADVSEC_identity_card");
    ADVSEC_GROUND(ADVSEC_Permit,"$STR_ADVSEC_permit");
    ADVSEC_GROUND(ADVSEC_Keycard,"$STR_ADVSEC_access_card");
    ADVSEC_GROUND(ADVSEC_Key,"$STR_ADVSEC_key_3");
    ADVSEC_GROUND(ADVSEC_MilitaryID,"$STR_ADVSEC_military_id");
    ADVSEC_GROUND(ADVSEC_MPBadge,"$STR_ADVSEC_military_police_badge");
    ADVSEC_GROUND(ADVSEC_IABadge,"$STR_ADVSEC_internal_affairs_credentials");
    ADVSEC_GROUND(ADVSEC_PDA_PM,"$STR_ADVSEC_military_police_pda");
    ADVSEC_GROUND(ADVSEC_PDA_AI,"$STR_ADVSEC_internal_affairs_pda");
    ADVSEC_GROUND(ADVSEC_PDA_JTAC,"$STR_ADVSEC_patch_pda_jtac");
    ADVSEC_GROUND(ADVSEC_PDA_RO,"$STR_ADVSEC_patch_pda_radio_operator");
    ADVSEC_GROUND(ADVSEC_PDA_SAN,"$STR_ADVSEC_patch_pda_combat_medic");
    ADVSEC_GROUND(ADVSEC_PDA_MED,"$STR_ADVSEC_patch_pda_doctor");
    ADVSEC_GROUND(ADVSEC_PDA_AT,"$STR_ADVSEC_patch_pda_anti_tank_at");
    ADVSEC_GROUND(ADVSEC_PDA_MG,"$STR_ADVSEC_patch_pda_machine_gunner");
    ADVSEC_GROUND(ADVSEC_PDA_ENG,"$STR_ADVSEC_patch_pda_engineer");
    ADVSEC_GROUND(ADVSEC_PDA_EOD,"$STR_ADVSEC_patch_pda_eod_disposal");
    ADVSEC_GROUND(ADVSEC_PDA_AA,"$STR_ADVSEC_patch_pda_anti_air_aa");
    ADVSEC_GROUND(ADVSEC_PDA_GRN,"$STR_ADVSEC_patch_pda_grenadier");
    ADVSEC_GROUND(ADVSEC_PDA_TANK,"$STR_ADVSEC_patch_pda_tank_crew");
    ADVSEC_GROUND(ADVSEC_PDA_PARA,"$STR_ADVSEC_patch_pda_paratrooper");
    ADVSEC_GROUND(ADVSEC_PDA_PILOT,"$STR_ADVSEC_patch_pda_pilot");
    ADVSEC_GROUND(ADVSEC_PDA_LOG,"$STR_ADVSEC_patch_pda_logistics");
    ADVSEC_GROUND(ADVSEC_PDA_ART,"$STR_ADVSEC_patch_pda_artillery");
    ADVSEC_GROUND(ADVSEC_PDA_MRK,"$STR_ADVSEC_patch_pda_marksman");
    ADVSEC_GROUND(ADVSEC_EvidenceBag,"$STR_ADVSEC_evidence_bag");
    ADVSEC_GROUND(ADVSEC_SpeedCamKit,"$STR_ADVSEC_portable_traffic_speed_camera");
    ADVSEC_GROUND(ADVSEC_HackKit,"$STR_ADVSEC_pmc_hackkit");
    class Box_NATO_Support_F;
    class ADVSEC_Box_Equipment: Box_NATO_Support_F {
        scope = 2;
        scopeCurator = 2;
        author = "oscar";
        displayName = "$STR_ADVSEC_advsec_equipment_box_pda_badges";
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
            class _xx_ADVSEC_SpeedCamKit { name = "ADVSEC_SpeedCamKit"; count = 2; };
            class _xx_ADVSEC_HackKit { name = "ADVSEC_HackKit"; count = 1; };
            class _xx_ADVSEC_EvidenceBag { name = "ADVSEC_EvidenceBag"; count = 20; };
        };
    };
};
