// Las misiones pueden añadir o sobrescribir tipos con la misma clase en description.ext
class ADVSEC_DocumentTypes {
    class Passport {
        background = "\x\advsec\addons\main\data\doc_passport_ca.paa";
        displayName = "PASAPORTE";
        item = "ADVSEC_Passport";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\documents_ca.paa";
        color[] = {0.10, 0.18, 0.40, 0.95};
        fields[] = {"name", "nationality", "dob", "number", "issuer", "expires", "clearance", "notes"};
        labels[] = {"Nombre", "Nacionalidad", "Nacimiento", "Nº pasaporte", "Expedido por", "Caduca", "Nivel", "Observaciones"};
        clearance = 0;
        dark = 0;
    };
    class IDCard {
        background = "\x\advsec\addons\main\data\doc_idcard_ca.paa";
        displayName = "IDENTIFICACIÓN";
        item = "ADVSEC_IDCard";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\meet_ca.paa";
        color[] = {0.12, 0.30, 0.15, 0.95};
        fields[] = {"name", "dob", "number", "issuer", "expires", "clearance", "notes"};
        labels[] = {"Nombre", "Nacimiento", "Nº ID", "Unidad", "Caduca", "Nivel de acceso", "Cargo"};
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
        labels[] = {"Titular", "Nº permiso", "Autoridad", "Caduca", "Nivel", "Ámbito"};
        clearance = 0;
        dark = 0;
    };
    class Keycard {
        background = "\x\advsec\addons\main\data\doc_keycard_ca.paa";
        displayName = "TARJETA DE ACCESO";
        item = "ADVSEC_Keycard";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\use_ca.paa";
        color[] = {0.20, 0.20, 0.22, 0.95};
        fields[] = {"name", "number", "clearance", "keys", "expires"};
        labels[] = {"Titular", "Nº tarjeta", "Nivel", "Zonas", "Caduca"};
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
        labels[] = {"Etiqueta", "Nº", "Abre"};
        clearance = -1;
        dark = 1;
    };
    class MilitaryID {
        displayName = "IDENTIFICACIÓN MILITAR";
        item = "ADVSEC_MilitaryID";
        background = "\x\advsec\addons\main\data\doc_military_ca.paa";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\meet_ca.paa";
        color[] = {0.25, 0.30, 0.18, 0.95};
        fields[] = {"name", "rank", "unit", "uid", "number", "issuer", "clearance"};
        labels[] = {"Nombre", "Empleo", "Unidad", "SteamID", "Nº", "Expedido por", "Nivel"};
        clearance = 1;
        dark = 0;
    };
    class MPBadge {
        displayName = "PLACA DE POLICÍA MILITAR";
        item = "ADVSEC_MPBadge";
        background = "\x\advsec\addons\main\data\doc_mpbadge_ca.paa";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\defend_ca.paa";
        color[] = {0.45, 0.08, 0.08, 0.95};
        fields[] = {"name", "uid", "number", "clearance", "issuer", "expires", "notes"};
        labels[] = {"Agente", "SteamID", "Indicativo", "Rango (1-5)", "Expedida por", "Caduca", "Observaciones"};
        clearance = 1;
        dark = 1;
    };
    class IABadge {
        displayName = "CREDENCIAL DE ASUNTOS INTERNOS";
        item = "ADVSEC_IABadge";
        background = "\x\advsec\addons\main\data\doc_iabadge_ca.paa";
        icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\search_ca.paa";
        color[] = {0.08, 0.08, 0.10, 0.95};
        fields[] = {"name", "uid", "number", "clearance", "issuer", "expires", "notes"};
        labels[] = {"Investigador", "SteamID", "Nº credencial", "Rango (1-5)", "Expedida por", "Caduca", "Observaciones"};
        clearance = 1;
        dark = 1;
    };
    // Licencias de pago (oficina de documentación). Usan la tarjeta de permiso.
    class WeaponLicense: Permit {
        displayName = "LICENCIA DE ARMAS";
        labels[] = {"Titular", "Nº licencia", "Autoridad", "Caduca", "Nivel", "Clase"};
    };
    class DriverLicense: Permit {
        displayName = "PERMISO DE CONDUCIR";
        color[] = {0.10, 0.25, 0.45, 0.95};
        labels[] = {"Titular", "Nº permiso", "Autoridad", "Caduca", "Nivel", "Clase"};
    };
    class PilotLicense: Permit {
        displayName = "LICENCIA DE PILOTO";
        color[] = {0.25, 0.10, 0.40, 0.95};
        labels[] = {"Titular", "Nº licencia", "Autoridad", "Caduca", "Nivel", "Clase"};
    };
};
