// Compatibilidad ADVSEC <-> HUD THUD: solo cambia textos de THUD; si THUD no está cargado, Arma ignora este addon.
// THUD lee el rango de Arma (rank): ADVSEC lo fija con ranksGlobalArma; aquí se le da el nombre de rango de la unidad.
class CfgPatches {
    class advsec_thud {
        name = "Advanced Security Systems - THUD";
        author = "oscar";
        requiredVersion = 2.14;
        requiredAddons[] = {"THUD_Antistasi", "AdvancedSecuritySystems"};
        skipWhenMissingDependencies = 1;
        units[] = {};
        weapons[] = {};
    };
};
#define ADVSEC_THUD_TEXTS \
    hr = "PM"; money = "Dinero"; treasury = "Tesorería %1"; boss = "Mando"; bossYou = "Tú"; \
    warLevel = "NIVEL DE ALERTA:"; warLevelC = "Alerta:"; \
    rank_PRIVATE = "TROPA"; rank_CORPORAL = "CABO"; rank_SERGEANT = "SARGENTO"; \
    rank_LIEUTENANT = "BRIGADA"; rank_CAPTAIN = "TENIENTE"; rank_MAJOR = "CAPITÁN"; rank_COLONEL = "CAPITÁN"; \
    rankc_PRIVATE = "Tropa"; rankc_CORPORAL = "Cabo"; rankc_SERGEANT = "Sargento"; \
    rankc_LIEUTENANT = "Brigada"; rankc_CAPTAIN = "Teniente"; rankc_MAJOR = "Capitán"; rankc_COLONEL = "Capitán";
class THUD_Settings {
    class Texts { ADVSEC_THUD_TEXTS };
    class TextsEN { ADVSEC_THUD_TEXTS };
};
