// Las misiones pueden añadir o sobrescribir tipos con la misma clase en description.ext
class ADVSEC_DocumentTypes {
    class Passport {
        background = "\x\advsec\addons\main\data\doc_passport_ca.paa";
        displayName = "PASAPORTE";
        item = "ADVSEC_Passport";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\documents_ca.paa";
        color[] = {0.10, 0.18, 0.40, 0.95};
        fields[] = {"name", "nationality", "dob", "number", "issuer", "expires", "clearance", "notes"};
        labels[] = {"$STR_ADVSEC_name", "$STR_ADVSEC_nationality", "$STR_ADVSEC_date_of_birth", "$STR_ADVSEC_passport_no", "$STR_ADVSEC_issued_by", "$STR_ADVSEC_expires", "$STR_ADVSEC_level_2", "$STR_ADVSEC_remarks"};
        clearance = 0;
        dark = 0;
    };
    class IDCard {
        background = "\x\advsec\addons\main\data\doc_idcard_ca.paa";
        displayName = "$STR_ADVSEC_identification";
        item = "ADVSEC_IDCard";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\meet_ca.paa";
        color[] = {0.12, 0.30, 0.15, 0.95};
        fields[] = {"name", "dob", "number", "issuer", "expires", "clearance", "notes"};
        labels[] = {"$STR_ADVSEC_name", "$STR_ADVSEC_date_of_birth", "$STR_ADVSEC_id_no", "$STR_ADVSEC_unit", "$STR_ADVSEC_expires", "$STR_ADVSEC_access_level", "$STR_ADVSEC_charge"};
        clearance = 1;
        dark = 0;
    };
    class Permit {
        background = "\x\advsec\addons\main\data\doc_permit_ca.paa";
        displayName = "PERMISO";
        item = "ADVSEC_Permit";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\whiteboard_ca.paa";
        color[] = {0.40, 0.28, 0.08, 0.95};
        fields[] = {"name", "number", "issuer", "expires", "clearance", "notes"};
        labels[] = {"$STR_ADVSEC_holder", "$STR_ADVSEC_permit_no", "$STR_ADVSEC_authority", "$STR_ADVSEC_expires", "$STR_ADVSEC_level_2", "$STR_ADVSEC_scope"};
        clearance = 0;
        dark = 0;
    };
    class Keycard {
        background = "\x\advsec\addons\main\data\doc_keycard_ca.paa";
        displayName = "$STR_ADVSEC_access_card_2";
        item = "ADVSEC_Keycard";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\use_ca.paa";
        color[] = {0.20, 0.20, 0.22, 0.95};
        fields[] = {"name", "number", "clearance", "keys", "expires"};
        labels[] = {"$STR_ADVSEC_holder", "$STR_ADVSEC_card_no", "$STR_ADVSEC_level_2", "$STR_ADVSEC_zones", "$STR_ADVSEC_expires"};
        clearance = 1;
        dark = 1;
    };
    class Key {
        background = "\x\advsec\addons\main\data\doc_key_ca.paa";
        displayName = "LLAVE";
        item = "ADVSEC_Key";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\interact_ca.paa";
        color[] = {0.35, 0.30, 0.10, 0.95};
        fields[] = {"name", "number", "keys"};
        labels[] = {"$STR_ADVSEC_label", "$STR_ADVSEC_no", "$STR_ADVSEC_opens"};
        clearance = -1;
        dark = 1;
    };
    class MilitaryID {
        displayName = "$STR_ADVSEC_military_id_2";
        item = "ADVSEC_MilitaryID";
        background = "\x\advsec\addons\main\data\doc_military_ca.paa";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\meet_ca.paa";
        color[] = {0.25, 0.30, 0.18, 0.95};
        fields[] = {"name", "rank", "unit", "uid", "number", "issuer", "clearance"};
        labels[] = {"$STR_ADVSEC_name", "$STR_ADVSEC_rank", "$STR_ADVSEC_unit", "SteamID", "$STR_ADVSEC_no", "$STR_ADVSEC_issued_by", "$STR_ADVSEC_level_2"};
        clearance = 1;
        dark = 0;
    };
    class MPBadge {
        displayName = "$STR_ADVSEC_military_police_badge_2";
        item = "ADVSEC_MPBadge";
        background = "\x\advsec\addons\main\data\doc_mpbadge_ca.paa";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\defend_ca.paa";
        color[] = {0.45, 0.08, 0.08, 0.95};
        fields[] = {"name", "uid", "number", "clearance", "issuer", "expires", "notes"};
        labels[] = {"$STR_ADVSEC_officer", "SteamID", "$STR_ADVSEC_call_sign", "$STR_ADVSEC_rank_1_5", "$STR_ADVSEC_issued_by_2", "$STR_ADVSEC_expires", "$STR_ADVSEC_remarks"};
        clearance = 1;
        dark = 1;
    };
    class IABadge {
        displayName = "$STR_ADVSEC_internal_affairs_credentials_2";
        item = "ADVSEC_IABadge";
        background = "\x\advsec\addons\main\data\doc_iabadge_ca.paa";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\search_ca.paa";
        color[] = {0.08, 0.08, 0.10, 0.95};
        fields[] = {"name", "uid", "number", "clearance", "issuer", "expires", "notes"};
        labels[] = {"$STR_ADVSEC_investigator", "SteamID", "$STR_ADVSEC_credential_no", "$STR_ADVSEC_rank_1_5", "$STR_ADVSEC_issued_by_2", "$STR_ADVSEC_expires", "$STR_ADVSEC_remarks"};
        clearance = 1;
        dark = 1;
    };
    // Licencias de pago (oficina de documentación). Usan la tarjeta de permiso.
    class WeaponLicense: Permit {
        displayName = "$STR_ADVSEC_weapons_licence";
        labels[] = {"$STR_ADVSEC_holder", "$STR_ADVSEC_licence_no", "$STR_ADVSEC_authority", "$STR_ADVSEC_expires", "$STR_ADVSEC_level_2", "$STR_ADVSEC_class"};
    };
    class DriverLicense: Permit {
        displayName = "$STR_ADVSEC_driving_licence";
        color[] = {0.10, 0.25, 0.45, 0.95};
        labels[] = {"$STR_ADVSEC_holder", "$STR_ADVSEC_permit_no", "$STR_ADVSEC_authority", "$STR_ADVSEC_expires", "$STR_ADVSEC_level_2", "$STR_ADVSEC_class"};
    };
    class PilotLicense: Permit {
        displayName = "$STR_ADVSEC_pilot_licence";
        color[] = {0.25, 0.10, 0.40, 0.95};
        labels[] = {"$STR_ADVSEC_holder", "$STR_ADVSEC_licence_no", "$STR_ADVSEC_authority", "$STR_ADVSEC_expires", "$STR_ADVSEC_level_2", "$STR_ADVSEC_class"};
    };
};
