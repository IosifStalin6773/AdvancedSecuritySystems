class CfgPatches {
    class AdvancedSecuritySystems {
        name = "Advanced Security Systems";
        author = "oscar";
        version = "1.14.0";
        requiredVersion = 2.14;
        requiredAddons[] = {"A3_Functions_F", "A3_UI_F", "A3_Weapons_F", "A3_Characters_F", "A3_Modules_F", "A3_Modules_F_Curator", "3DEN"};
        units[] = {
            "ADVSEC_ModuleCamera", "ADVSEC_ModuleMonitor", "ADVSEC_ModuleKeypad", "ADVSEC_ModuleDoor", "ADVSEC_ModuleAlarm", "ADVSEC_ModuleIssuer",
            "ADVSEC_ZeusCamera", "ADVSEC_ZeusMonitor", "ADVSEC_ZeusKeypad", "ADVSEC_ZeusDoor", "ADVSEC_ZeusAlarm", "ADVSEC_ZeusIssuer",
            "ADVSEC_ModuleReports", "ADVSEC_ZeusReports",
            "ADVSEC_ModuleJail", "ADVSEC_ZeusJail", "ADVSEC_ZeusPanel", "ADVSEC_ZeusPolice",
            "ADVSEC_ModuleLab", "ADVSEC_ZeusLab", "ADVSEC_ModuleCheckpoint", "ADVSEC_ZeusCheckpoint",
            "ADVSEC_ModuleAdmin", "ADVSEC_ZeusAdmin",
            "ADVSEC_ModuleAtm", "ADVSEC_ZeusAtm", "ADVSEC_ModuleShop", "ADVSEC_ZeusShop",
            "ADVSEC_ModuleDealer", "ADVSEC_ZeusDealer", "ADVSEC_ModuleDuty", "ADVSEC_ZeusDuty", "ADVSEC_ModuleSpeedCam", "ADVSEC_ZeusSpeedCam",
            "ADVSEC_Box_Equipment", "Item_ADVSEC_Passport", "Item_ADVSEC_IDCard", "Item_ADVSEC_Permit", "Item_ADVSEC_Keycard", "Item_ADVSEC_Key", "Item_ADVSEC_MilitaryID", "Item_ADVSEC_MPBadge", "Item_ADVSEC_IABadge", "Item_ADVSEC_PDA_PM", "Item_ADVSEC_PDA_AI", "Item_ADVSEC_PDA_JTAC", "Item_ADVSEC_PDA_RO", "Item_ADVSEC_PDA_SAN", "Item_ADVSEC_PDA_MED", "Item_ADVSEC_PDA_AT", "Item_ADVSEC_PDA_MG", "Item_ADVSEC_PDA_ENG", "Item_ADVSEC_PDA_EOD", "Item_ADVSEC_PDA_AA", "Item_ADVSEC_PDA_GRN", "Item_ADVSEC_PDA_TANK", "Item_ADVSEC_PDA_PARA", "Item_ADVSEC_PDA_PILOT", "Item_ADVSEC_PDA_LOG", "Item_ADVSEC_PDA_ART", "Item_ADVSEC_PDA_MRK", "Item_ADVSEC_EvidenceBag"
        };
        weapons[] = {"ADVSEC_Passport", "ADVSEC_IDCard", "ADVSEC_Permit", "ADVSEC_Keycard", "ADVSEC_Key", "ADVSEC_MilitaryID", "ADVSEC_MPBadge", "ADVSEC_IABadge", "ADVSEC_PDA_PM", "ADVSEC_PDA_AI", "ADVSEC_PDA_JTAC", "ADVSEC_PDA_RO", "ADVSEC_PDA_SAN", "ADVSEC_PDA_MED", "ADVSEC_PDA_AT", "ADVSEC_PDA_MG", "ADVSEC_PDA_ENG", "ADVSEC_PDA_EOD", "ADVSEC_PDA_AA", "ADVSEC_PDA_GRN", "ADVSEC_PDA_TANK", "ADVSEC_PDA_PARA", "ADVSEC_PDA_PILOT", "ADVSEC_PDA_LOG", "ADVSEC_PDA_ART", "ADVSEC_PDA_MRK", "ADVSEC_EvidenceBag"};
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
#include "ui\Cfg3DEN.hpp"
#include "ui\pda.hpp"
