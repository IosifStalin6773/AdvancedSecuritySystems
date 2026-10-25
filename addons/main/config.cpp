class CfgPatches {
    class AdvancedSecuritySystems {
        name = "Advanced Security Systems";
        author = "oscar";
        version = "1.12.2";
        requiredVersion = 2.14;
        requiredAddons[] = {"A3_Functions_F", "A3_UI_F", "A3_Weapons_F", "A3_Characters_F", "A3_Modules_F", "A3_Modules_F_Curator"};
        units[] = {
            "ADVSEC_ModuleCamera", "ADVSEC_ModuleMonitor", "ADVSEC_ModuleKeypad", "ADVSEC_ModuleDoor", "ADVSEC_ModuleAlarm", "ADVSEC_ModuleIssuer",
            "ADVSEC_ZeusCamera", "ADVSEC_ZeusMonitor", "ADVSEC_ZeusKeypad", "ADVSEC_ZeusDoor", "ADVSEC_ZeusAlarm", "ADVSEC_ZeusIssuer",
            "ADVSEC_ModuleReports", "ADVSEC_ZeusReports",
            "ADVSEC_ModuleJail", "ADVSEC_ZeusJail", "ADVSEC_ZeusPanel", "ADVSEC_ZeusPolice",
            "ADVSEC_ModuleLab", "ADVSEC_ZeusLab", "ADVSEC_ModuleCheckpoint", "ADVSEC_ZeusCheckpoint",
            "ADVSEC_ModuleAdmin", "ADVSEC_ZeusAdmin",
            "ADVSEC_ModuleAtm", "ADVSEC_ZeusAtm", "ADVSEC_ModuleShop", "ADVSEC_ZeusShop",
            "ADVSEC_ModuleDealer", "ADVSEC_ZeusDealer", "ADVSEC_ModuleDuty", "ADVSEC_ZeusDuty",
            "ADVSEC_Box_Equipment", "Item_ADVSEC_Passport", "Item_ADVSEC_IDCard", "Item_ADVSEC_Permit", "Item_ADVSEC_Keycard", "Item_ADVSEC_Key", "Item_ADVSEC_MilitaryID", "Item_ADVSEC_MPBadge", "Item_ADVSEC_IABadge", "Item_ADVSEC_PDA_PM", "Item_ADVSEC_PDA_AI", "Item_ADVSEC_PDA_SPEC", "Item_ADVSEC_EvidenceBag"
        };
        weapons[] = {"ADVSEC_Passport", "ADVSEC_IDCard", "ADVSEC_Permit", "ADVSEC_Keycard", "ADVSEC_Key", "ADVSEC_MilitaryID", "ADVSEC_MPBadge", "ADVSEC_IABadge", "ADVSEC_PDA_PM", "ADVSEC_PDA_AI", "ADVSEC_PDA_SPEC", "ADVSEC_EvidenceBag"};
    };
};

// CBA: los ajustes deben registrarse en el preInit de XEH (después de que CBA prepare su menú; también en el menú principal).
// Sin CBA esta clase se ignora.
class Extended_PreInit_EventHandlers {
    class ADVSEC_settings {
        init = "call ADVSEC_fnc_cbaSettings";
    };
};

#include "CfgFunctions.hpp"
#include "CfgWeapons.hpp"
#include "CfgDocuments.hpp"
#include "CfgModules.hpp"
#include "CfgReports.hpp"
#include "CfgSettings.hpp"
#include "ui\defines.hpp"
#include "ui\RscTitles.hpp"
#include "ui\dialogs.hpp"
#include "ui\pda.hpp"
