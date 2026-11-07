class CfgPatches {
    class TS_Lockers {
        name = "[TS] Lockers";
        author = "TS";
        requiredVersion = 2.2;
        requiredAddons[] = {
            "A3_Structures_F",
            "A3_Weapons_F",
            "ace_interact_menu",
            "cba_main"
        };
        units[] = {"Land_TS_Locker_F", "Land_TS_Locker_Velcro_F", "Land_TS_Locker_Decorated_F"};
        weapons[] = {};
        // Integrado en Advanced Security Systems: sin ACE/CBA esta parte no se carga y el resto del mod sigue funcionando
        skipWhenMissingDependencies = 1;
    };
};
class CfgFunctions {
    class TS_Lockers {
        tag = "TSL";
        class Locker {
            file = "\TS_Lockers\functions";
            class beginCapture {};
            class captureInventory {};
            class resumeCapture {};
            class ack {};
            class watchTransfer {};
            class scenarioKey {};
            class autoResume {};
            class migrateLegacy {};
            class reconcileTransfer {};
            class canonLoadout {};
            class applyTransfer {};
            class cargo {};
            class clear {};
            class clientInit {
                postInit = 1;
            };
            class init {};
            class menu {};
            class notice {};
            class openUI {};
            class cameraStart {};
            class useUI {};
            class useTargets {};
            class useFrame {};
            class useDraw {};
            class gearAllowed {};
            class gearInfo {};
            class gearMenu {};
            class gearActions {};
            class stackKey {};
            class stackState {};
            class stackActions {};
            class stackMenu {};
            class gearTransfer {};
            class editorPick {};
            class editorChrome {};
            class editorViewport {};
            class editorObjects {};
            class editorPreview {};
            class theme {};
            class themeUI {};
            class gearReturn {};
            class gearHomeMenu {};
            class gearClassMatch {};
            class editorSmall {};
            class editorCatalog {};
            class editorModel {};
            class editorSpawn {};
            class editorBounds {};
            class editorScale {};
            class editorCatalogUI {};
            class editorValidate {};
            class presetServer {};
            class presetResponse {};
            class presetUI {};
            class editorDuplicate {};
            class editorPose {};
            class editorRender {};
            class editorCommit {};
            class editorUI {};
            class editorInput {};
            class editorFrame {};
            class editorRotatePose {};
            class personalSnapshot {};
            class editorDraw {};
            class editorRefresh {};
            class cameraStop {};
            class cameraStep {};
            class cameraInput {};
            class cameraPointer {};
            class postInit {
                postInit = 1;
            };
            class preInit {
                preInit = 1;
            };
            class register {};
            class actionTarget {};
            class render {};
            class renderExtras {};
            class placeDisplay {};
            class groundRifle {};
            class fitRifle {};
            class normalizeCustom {};
            class renderSourcePistol {};
            class localize {};
            class createAction {};
            class modifyAction {};
            class setLanguage {};
            class lockDisplay {};
            class menuPosition {};
            class publishVisuals {};
            class syncVisuals {};
            class renderClamps {};
            class renderDecor {};
            class renderPanels {};
            class request {};
            class restoreCargo {};
            class save {};
            class uiBack {};
            class uiExecute {};
            class uiFill {};
        };
    };
};
class CfgRemoteExec {
    class Functions {
        class TSL_fnc_captureInventory {
            allowedTargets = 0;
        };
        class TSL_fnc_resumeCapture {
            allowedTargets = 2;
        };
        class TSL_fnc_personalSnapshot {
            allowedTargets = 0;
        };
        class TSL_fnc_presetResponse {
            allowedTargets = 0;
        };
        class TSL_fnc_publishVisuals {
            allowedTargets = 2;
        };
        class TSL_fnc_request {
            allowedTargets = 2;
        };
        class TSL_fnc_ack {
            allowedTargets = 2;
        };
        class TSL_fnc_applyTransfer {
            allowedTargets = 0;
        };
        class TSL_fnc_notice {
            allowedTargets = 0;
        };
        class TSL_fnc_lockDisplay {
            allowedTargets = 0;
            jip = 1;
        };
    };
};
class CfgEditorCategories {
    class TS_Lockers {
        displayName = "[TS] Lockers";
    };
};
class CfgEditorSubcategories {
    class TS_LockersGear {
        displayName = "Personal gear lockers";
    };
};
class CfgVehicles {
    class GroundWeaponHolder_Scripted;
    class TSL_VestDisplayHolder: GroundWeaponHolder_Scripted {
        scope = 1;
        scopeCurator = 0;
        model = "\A3\Weapons_f\dummyweapon_single.p3d";
    };
    class WeaponHolder_Single_F;
    class TSL_WeaponDisplayHolder: GroundWeaponHolder_Scripted {
        scope = 1;
        scopeCurator = 0;
        model = "\TS_Lockers\TSL_WeaponDisplayHolder.p3d";
    };
    class House_F;
    class ThingX;
    class Land_TS_Locker_F: House_F {
        TSL_hasVelcro = 0;
        TSL_defaultDecor = 0;
        ace_dragging_canDrag = 0;
        ace_dragging_canCarry = 0;
        ace_cargo_canLoad = 0;
        simulation = "house";
        scope = 2;
        scopeCurator = 2;
        author = "TS";
        displayName = "Personal Locker - Plywood (No Velcro)";
        model = "\TS_Lockers\TS_Locker_Bare.p3d";
        editorPreview = "\TS_Lockers\data\preview.jpg";
        editorCategory = "TS_Lockers";
        editorSubcategory = "TS_LockersGear";
        armor = 1000;
        destrType = "DestructNo";
        mapSize = 1;
        class EventHandlers {
            init = "[_this select 0] call TSL_fnc_init;";
        };
        class ACE_Actions {
            class ItemAction0 {
                displayName = "Helmet";
                modifierFunction = "_this call TSL_fnc_modifyAction";
                distance = 3;
                position = "[-0.4944308400154114, -0.61, 1.6392053365707397]";
                doNotCheckLOS = 1;
                enableInside = 1;
                condition = "alive _player && {(_target getVariable ['TSL_owner',''])==getPlayerUID _player}";
                statement = "";
                insertChildren = "[_target,_player,['slot',0]] call TSL_fnc_menu";
            };
            class ItemAction1 {
                displayName = "Primary weapon 1";
                modifierFunction = "_this call TSL_fnc_modifyAction";
                distance = 3;
                position = "[0.17743515968322754, -0.61, 0.9164830446243286]";
                doNotCheckLOS = 1;
                enableInside = 1;
                condition = "alive _player && {(_target getVariable ['TSL_owner',''])==getPlayerUID _player}";
                statement = "";
                insertChildren = "[_target,_player,['slot',1]] call TSL_fnc_menu";
            };
            class ItemAction2 {
                displayName = "Primary weapon 2";
                modifierFunction = "_this call TSL_fnc_modifyAction";
                distance = 3;
                position = "[0.34271132946014404, -0.61, 0.9164830446243286]";
                doNotCheckLOS = 1;
                enableInside = 1;
                condition = "alive _player && {(_target getVariable ['TSL_owner',''])==getPlayerUID _player}";
                statement = "";
                insertChildren = "[_target,_player,['slot',2]] call TSL_fnc_menu";
            };
            class ItemAction3 {
                displayName = "Pistol 1";
                modifierFunction = "_this call TSL_fnc_modifyAction";
                distance = 3;
                position = "[0.0037373602390289307, -0.61, 1.4278570413589478]";
                doNotCheckLOS = 1;
                enableInside = 1;
                condition = "alive _player && {(_target getVariable ['TSL_owner',''])==getPlayerUID _player}";
                statement = "";
                insertChildren = "[_target,_player,['slot',3]] call TSL_fnc_menu";
            };
            class ItemAction4 {
                displayName = "Pistol 2";
                modifierFunction = "_this call TSL_fnc_modifyAction";
                distance = 3;
                position = "[0.0665905773639679, -0.61, 1.4278568029403687]";
                doNotCheckLOS = 1;
                enableInside = 1;
                condition = "alive _player && {(_target getVariable ['TSL_owner',''])==getPlayerUID _player}";
                statement = "";
                insertChildren = "[_target,_player,['slot',4]] call TSL_fnc_menu";
            };
            class ItemAction5 {
                displayName = "Vest";
                modifierFunction = "_this call TSL_fnc_modifyAction";
                distance = 3;
                position = "[-0.30321723222732544, -0.61, 1.0739597082138062]";
                doNotCheckLOS = 1;
                enableInside = 1;
                condition = "alive _player && {(_target getVariable ['TSL_owner',''])==getPlayerUID _player}";
                statement = "";
                insertChildren = "[_target,_player,['slot',5]] call TSL_fnc_menu";
            };
            class ItemAction6 {
                displayName = "Backpack";
                modifierFunction = "_this call TSL_fnc_modifyAction";
                distance = 3;
                position = "[-0.30321723222732544, -0.61, 0.3532761335372925]";
                doNotCheckLOS = 1;
                enableInside = 1;
                condition = "alive _player && {(_target getVariable ['TSL_owner',''])==getPlayerUID _player}";
                statement = "";
                insertChildren = "[_target,_player,['slot',6]] call TSL_fnc_menu";
            };
            class ItemAction7 {
                displayName = "Uniform";
                modifierFunction = "_this call TSL_fnc_modifyAction";
                distance = 3;
                position = "[-0.46, -0.61, 0.64]";
                doNotCheckLOS = 1;
                enableInside = 1;
                condition = "alive _player && {(_target getVariable ['TSL_owner',''])==getPlayerUID _player}";
                statement = "";
                insertChildren = "[_target,_player,['slot',7]] call TSL_fnc_menu";
            };
            class ItemAction8 {
                displayName = "NVG 1";
                modifierFunction = "_this call TSL_fnc_modifyAction";
                distance = 3;
                position = "[-0.4944308400154114, -0.61, 1.6733920574188232]";
                doNotCheckLOS = 1;
                enableInside = 1;
                condition = "alive _player && {(_target getVariable ['TSL_owner',''])==getPlayerUID _player}";
                statement = "";
                insertChildren = "[_target,_player,['slot',8]] call TSL_fnc_menu";
            };
            class ItemAction9 {
                displayName = "NVG 2";
                modifierFunction = "_this call TSL_fnc_modifyAction";
                distance = 3;
                position = "[-0.2572788596153259, -0.61, 1.4741748571395874]";
                doNotCheckLOS = 1;
                enableInside = 1;
                condition = "alive _player && {(_target getVariable ['TSL_owner',''])==getPlayerUID _player}";
                statement = "";
                insertChildren = "[_target,_player,['slot',9]] call TSL_fnc_menu";
            };
            class ItemAction10 {
                displayName = "Facewear";
                modifierFunction = "_this call TSL_fnc_modifyAction";
                distance = 3;
                position = "[-0.12, -0.61, 1.45]";
                doNotCheckLOS = 1;
                enableInside = 1;
                condition = "alive _player && {(_target getVariable ['TSL_owner',''])==getPlayerUID _player}";
                statement = "";
                insertChildren = "[_target,_player,['slot',10]] call TSL_fnc_menu";
            };
            class ItemAction11 {
                displayName = "Launcher";
                modifierFunction = "_this call TSL_fnc_modifyAction";
                distance = 3;
                position = "[0.26, -0.61, 0.94]";
                doNotCheckLOS = 1;
                enableInside = 1;
                condition = "alive _player && {(_target getVariable ['TSL_owner',''])==getPlayerUID _player}";
                statement = "";
                insertChildren = "[_target,_player,['slot',11]] call TSL_fnc_menu";
            };
            class ItemAction12 {
                displayName = "Binoculars / rangefinder";
                modifierFunction = "_this call TSL_fnc_modifyAction";
                distance = 3;
                position = "[-0.13, -0.61, 1.46]";
                doNotCheckLOS = 1;
                enableInside = 1;
                condition = "alive _player && {(_target getVariable ['TSL_owner',''])==getPlayerUID _player}";
                statement = "";
                insertChildren = "[_target,_player,['slot',12]] call TSL_fnc_menu";
            };
            class ItemAction13 {
                displayName = "Backpack 2";
                modifierFunction = "_this call TSL_fnc_modifyAction";
                distance = 3;
                position = "[0.11, -0.61, 0.9]";
                doNotCheckLOS = 1;
                enableInside = 1;
                condition = "alive _player && {(_target getVariable ['TSL_owner',''])==getPlayerUID _player}";
                statement = "";
                insertChildren = "[_target,_player,['slot',13]] call TSL_fnc_menu";
            };
            class ItemAction14 {
                displayName = "Primary weapon 3";
                modifierFunction = "_this call TSL_fnc_modifyAction";
                distance = 3;
                position = "[-0.3, -0.61, 1.3]";
                doNotCheckLOS = 1;
                enableInside = 1;
                condition = "alive _player && {(_target getVariable ['TSL_owner',''])==getPlayerUID _player}";
                statement = "";
                insertChildren = "[_target,_player,['slot',14]] call TSL_fnc_menu";
            };
            class ItemAction15 {
                displayName = "Primary weapon 4";
                modifierFunction = "_this call TSL_fnc_modifyAction";
                distance = 3;
                position = "[0.25, -0.61, 1.0]";
                doNotCheckLOS = 1;
                enableInside = 1;
                condition = "alive _player && {(_target getVariable ['TSL_owner',''])==getPlayerUID _player}";
                statement = "";
                insertChildren = "[_target,_player,['slot',15]] call TSL_fnc_menu";
            };
            class ItemAction16 {
                displayName = "Primary weapon 5";
                modifierFunction = "_this call TSL_fnc_modifyAction";
                distance = 3;
                position = "[-0.1, -0.61, 2.1]";
                doNotCheckLOS = 1;
                enableInside = 1;
                condition = "alive _player && {(_target getVariable ['TSL_owner',''])==getPlayerUID _player}";
                statement = "";
                insertChildren = "[_target,_player,['slot',16]] call TSL_fnc_menu";
            };
            class ItemAction17 {
                displayName = "Backpack 3 (Eagle)";
                modifierFunction = "_this call TSL_fnc_modifyAction";
                distance = 3;
                position = "[-0.3, -0.61, 0.5]";
                doNotCheckLOS = 1;
                enableInside = 1;
                condition = "alive _player && {(_target getVariable ['TSL_owner',''])==getPlayerUID _player}";
                statement = "";
                insertChildren = "[_target,_player,['slot',17]] call TSL_fnc_menu";
            };
            class Details {
                displayName = "Small items";
                modifierFunction = "_this call TSL_fnc_modifyAction";
                distance = 3;
                position = "[-0.45, -0.61, 1.45]";
                doNotCheckLOS = 1;
                enableInside = 1;
                condition = "(_target getVariable ['TSL_owner',''])==getPlayerUID _player";
                statement = "";
                insertChildren = "[_target,_player,['sourceDetails']] call TSL_fnc_menu";
            };
            class Cases {
                displayName = "Cases";
                modifierFunction = "_this call TSL_fnc_modifyAction";
                distance = 3;
                position = "[-0.1, -0.61, 0.15]";
                doNotCheckLOS = 1;
                enableInside = 1;
                condition = "(_target getVariable ['TSL_owner',''])==getPlayerUID _player";
                statement = "";
                insertChildren = "[_target,_player,['caseSettings']] call TSL_fnc_menu";
            };
            class LockerMenu {
                displayName = "Locker";
                modifierFunction = "_this call TSL_fnc_modifyAction";
                distance = 3;
                position = "[-0.0971396416425705,-0.54,1.352109670639038]";
                doNotCheckLOS = 1;
                enableInside = 1;
                condition = "alive _player && {_player distance _target<3}";
                statement = "";
                insertChildren = "[_target,_player,['aceRoot']] call TSL_fnc_menu";
            };
        };
    };
    class Land_TS_Locker_Velcro_F: Land_TS_Locker_F {
        displayName = "Personal Locker - Plywood (Velcro Panels)";
        modifierFunction = "_this call TSL_fnc_modifyAction";
        TSL_hasVelcro = 1;
        model = "\TS_Lockers\TS_Locker_Bare.p3d";
    };
    class Land_TS_Locker_Decorated_F: Land_TS_Locker_Velcro_F {
        displayName = "Personal Locker - Plywood (Patches and Photos)";
        modifierFunction = "_this call TSL_fnc_modifyAction";
        TSL_defaultDecor = 1;
    };
    class Box_NATO_Equip_F;
    class TSL_Storage: Box_NATO_Equip_F {
        scope = 1;
        scopeCurator = 0;
        displayName = "Locker storage";
        modifierFunction = "_this call TSL_fnc_modifyAction";
        model = "\A3\weapons_f\empty.p3d";
        maximumLoad = 10000;
        transportMaxWeapons = 1000;
        transportMaxMagazines = 10000;
        transportMaxBackpacks = 100;
        ace_cargo_canLoad = 0;
        ace_dragging_canDrag = 0;
        ace_dragging_canCarry = 0;
        class TransportItems {};
        class TransportWeapons {};
        class TransportMagazines {};
        class TransportBackpacks {};
    };
    class TSL_Decor: House_F {
        scope = 1;
        scopeCurator = 0;
        armor = 100;
        destrType = "DestructNo";
    };
    class TSL_IR_US_BW: TSL_Decor {
        model = "\TS_Lockers\TSL_IR_US_BW.p3d";
    };
    class TSL_IR_US_ColorReverse: TSL_Decor {
        model = "\TS_Lockers\TSL_IR_US_ColorReverse.p3d";
    };
    class TSL_IR_US_Subdued: TSL_Decor {
        model = "\TS_Lockers\TSL_IR_US_Subdued.p3d";
    };
    class TSL_PatchAOR1: TSL_Decor {
        model = "\TS_Lockers\TSL_PatchAOR1.p3d";
    };
    class TSL_PatchPaw: TSL_Decor {
        model = "\TS_Lockers\TSL_PatchPaw.p3d";
    };
    class TSL_PatchHoneycomb: TSL_Decor {
        model = "\TS_Lockers\TSL_PatchHoneycomb.p3d";
    };
    class TSL_NameTape: TSL_Decor {
        model = "\TS_Lockers\TSL_NameTape.p3d";
        hiddenSelections[] = {"label", "badge"};
        hiddenSelectionsTextures[] = {"\TS_Lockers\data\update\name_EA1_co.paa", "\TS_Lockers\data\update\red_squadron_badge_co.paa"};
    };
    class TSL_Backpack1_Pos3: TSL_Decor {
        model = "\TS_Lockers\TSL_Backpack1_Pos3.p3d";
        hiddenSelections[] = {"6500"};
        hiddenSelectionsTextures[] = {"\TS_Lockers\data\backpack_reference\6500_mo_co.paa"};
    };
    class TSL_Backpack1_Pos0: TSL_Decor {
        model = "\TS_Lockers\TSL_Backpack1_Pos0.p3d";
        hiddenSelections[] = {"6500"};
        hiddenSelectionsTextures[] = {"\TS_Lockers\data\backpack_reference\6500_mo_co.paa"};
    };
    class TSL_Backpack1_Pos1: TSL_Decor {
        model = "\TS_Lockers\TSL_Backpack1_Pos1.p3d";
        hiddenSelections[] = {"6500"};
        hiddenSelectionsTextures[] = {"\TS_Lockers\data\backpack_reference\6500_mo_co.paa"};
    };
    class TSL_Backpack1_Pos2: TSL_Decor {
        model = "\TS_Lockers\TSL_Backpack1_Pos2.p3d";
        hiddenSelections[] = {"6500"};
        hiddenSelectionsTextures[] = {"\TS_Lockers\data\backpack_reference\6500_mo_co.paa"};
    };
    class TSL_Backpack2_Pos0: TSL_Decor {
        model = "\TS_Lockers\TSL_Backpack2_Pos0.p3d";
        hiddenSelections[] = {"SATL"};
        hiddenSelectionsTextures[] = {"\TS_Lockers\data\backpack_reference\satl_mo_co.paa"};
    };
    class TSL_Backpack2_Pos1: TSL_Decor {
        model = "\TS_Lockers\TSL_Backpack2_Pos1.p3d";
        hiddenSelections[] = {"SATL"};
        hiddenSelectionsTextures[] = {"\TS_Lockers\data\backpack_reference\satl_mo_co.paa"};
    };
    class TSL_Backpack2_Pos2: TSL_Decor {
        model = "\TS_Lockers\TSL_Backpack2_Pos2.p3d";
        hiddenSelections[] = {"SATL"};
        hiddenSelectionsTextures[] = {"\TS_Lockers\data\backpack_reference\satl_mo_co.paa"};
    };
    class TSL_ItemDisplay_0fb4d6d62099: TSL_Decor {
        model = "\afg_mujahideen_chicoms\afg_muj_chicom_56_sks.p3d";
        hiddenSelections[] = {""};
    };
    class TSL_ItemDisplay_6529370c0ee1: TSL_Decor {
        model = "\afg_mujahideen_chicoms\afg_muj_chicom_56_sks.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_25a1e6000511: TSL_Decor {
        model = "\afg_mujahideen_chicoms\afg_muj_chicom_56_sks_bandolier.p3d";
        hiddenSelections[] = {""};
    };
    class TSL_ItemDisplay_5552e6110d3c: TSL_Decor {
        model = "\afg_mujahideen_chicoms\afg_muj_chicom_56_sks_bandolier.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_45a2fca77764: TSL_Decor {
        model = "\afg_mujahideen_chicoms\afg_muj_chicom_56_sks_bandolier_keattle.p3d";
        hiddenSelections[] = {""};
    };
    class TSL_ItemDisplay_0f7433205582: TSL_Decor {
        model = "\afg_mujahideen_chicoms\afg_muj_chicom_56_sks_bandolier_keattle.p3d";
        hiddenSelections[] = {"camo", "camo1"};
    };
    class TSL_ItemDisplay_14193e7bed55: TSL_Decor {
        model = "\afg_mujahideen_chicoms\afg_muj_chicom_56_b.p3d";
        hiddenSelections[] = {""};
    };
    class TSL_ItemDisplay_8a8ff5d0b6c6: TSL_Decor {
        model = "\afg_mujahideen_chicoms\afg_muj_chicom_56_b.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_706ac87a86ee: TSL_Decor {
        model = "\afg_mujahideen_chicoms\afg_muj_chicom_56_b_keattle.p3d";
        hiddenSelections[] = {""};
    };
    class TSL_ItemDisplay_f6be5cae8130: TSL_Decor {
        model = "\afg_mujahideen_chicoms\afg_muj_chicom_56_b_keattle.p3d";
        hiddenSelections[] = {"camo", "camo1"};
    };
    class TSL_ItemDisplay_afe9f782ea43: TSL_Decor {
        model = "\afg_mujahideen_chicoms\afg_muj_7_62_54_belt.p3d";
        hiddenSelections[] = {""};
    };
    class TSL_ItemDisplay_c722cf9f5f2a: TSL_Decor {
        model = "\afg_mujahideen_chicoms\afg_muj_7_62_54_belt.p3d";
        hiddenSelections[] = {"camo1"};
    };
    class TSL_ItemDisplay_5abf5f2731fd: TSL_Decor {
        model = "\afg_mujahideen_chicoms\afg_muj_7_62_54_belt.p3d";
        hiddenSelections[] = {"camo2"};
    };
    class TSL_ItemDisplay_3e90171c2e4d: TSL_Decor {
        model = "\afg_mujahideen_chicoms\afg_muj_chicom_81_b.p3d";
        hiddenSelections[] = {""};
    };
    class TSL_ItemDisplay_b5cfaa2ce83f: TSL_Decor {
        model = "\afg_mujahideen_chicoms\afg_muj_chicom_81_b.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_dd08b4857aae: TSL_Decor {
        model = "\afg_mujahideen_chicoms\afg_muj_chicom_81_b_id.p3d";
        hiddenSelections[] = {""};
    };
    class TSL_ItemDisplay_4ea72f0ca570: TSL_Decor {
        model = "\afg_mujahideen_chicoms\afg_muj_chicom_81_b_id.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_005c4150dbed: TSL_Decor {
        model = "\afg_mujahideen_chicoms\afg_muj_chicom_56_b_id.p3d";
        hiddenSelections[] = {""};
    };
    class TSL_ItemDisplay_793c3f0a4716: TSL_Decor {
        model = "\afg_mujahideen_chicoms\afg_muj_chicom_56_b_id.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_1411e5cd9d33: TSL_Decor {
        model = "\afg_mujahideen_pakols\afg_pakol_1.p3d";
        hiddenSelections[] = {""};
    };
    class TSL_ItemDisplay_e2580d16a370: TSL_Decor {
        model = "\afg_mujahideen_pakols\afg_pakol_1.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_2a9eeb8bfb4b: TSL_Decor {
        model = "\afg_mujahideen_pakols\afg_pakol_1_shawl.p3d";
        hiddenSelections[] = {""};
    };
    class TSL_ItemDisplay_713defc1478f: TSL_Decor {
        model = "\afg_mujahideen_pakols\afg_pakol_1_shawl.p3d";
        hiddenSelections[] = {"camo1"};
    };
    class TSL_ItemDisplay_8d6beacd9413: TSL_Decor {
        model = "\afg_mujahideen_pakols\afg_pakol_1_shawl.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_dedc048b1690: TSL_Decor {
        model = "\afg_mujahideen_pakols\afg_pakol_1_shawl.p3d";
        hiddenSelections[] = {"camo1", "camo"};
    };
    class TSL_ItemDisplay_02a5da0081a0: TSL_Decor {
        model = "\afg_mujahideen_pakols\afg_pakol_2_headscarf.p3d";
        hiddenSelections[] = {""};
    };
    class TSL_ItemDisplay_16b4212eee62: TSL_Decor {
        model = "\afg_mujahideen_pakols\afg_pakol_2_headscarf.p3d";
        hiddenSelections[] = {"camo1"};
    };
    class TSL_ItemDisplay_d3a40eb4e332: TSL_Decor {
        model = "\afg_mujahideen_pakols\afg_pakol_2_headscarf.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_48927e5e5846: TSL_Decor {
        model = "\afg_mujahideen_pakols\afg_pakol_2_headscarf.p3d";
        hiddenSelections[] = {"camo1", "camo"};
    };
    class TSL_ItemDisplay_d78afabf9b7d: TSL_Decor {
        model = "\afg_mujahideen_pakols\afg_pakol_3.p3d";
        hiddenSelections[] = {""};
    };
    class TSL_ItemDisplay_1342dcc71948: TSL_Decor {
        model = "\afg_mujahideen_pakols\afg_pakol_3.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_cbe647760fcf: TSL_Decor {
        model = "\afg_mujahideen_pakols\afg_turban_1.p3d";
        hiddenSelections[] = {""};
    };
    class TSL_ItemDisplay_cbbee167b371: TSL_Decor {
        model = "\afg_mujahideen_pakols\afg_turban_1.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_424896f83c44: TSL_Decor {
        model = "\afg_mujahideen_pakols\afg_turban_all_1.p3d";
        hiddenSelections[] = {""};
    };
    class TSL_ItemDisplay_8583159de2e1: TSL_Decor {
        model = "\afg_mujahideen_pakols\afg_turban_all_1.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_8b4595658dd0: TSL_Decor {
        model = "\afg_mujahideen_pakols\afg_turban_all_2.p3d";
        hiddenSelections[] = {""};
    };
    class TSL_ItemDisplay_faa424691020: TSL_Decor {
        model = "\afg_mujahideen_pakols\afg_turban_all_2.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_b6b3296a8507: TSL_Decor {
        model = "\bluesquadronuniforms\fs_g2_g.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_61702a364f38: TSL_Decor {
        model = "\bluesquadronvests\lbta.p3d";
        hiddenSelections[] = {""};
    };
    class TSL_ItemDisplay_2324bbadc88d: TSL_Decor {
        model = "\bluesquadronvests\aor1_njpc1.p3d";
        hiddenSelections[] = {""};
    };
    class TSL_ItemDisplay_6643570a6421: TSL_Decor {
        model = "\bluesquadronvests\mc_njpc1.p3d";
        hiddenSelections[] = {""};
    };
    class TSL_ItemDisplay_a00d163cf170: TSL_Decor {
        model = "\bluesquadronvests\mbavrig.p3d";
        hiddenSelections[] = {""};
    };
    class TSL_ItemDisplay_dafefffb2dd6: TSL_Decor {
        model = "\bluesquadronvests\softrig.p3d";
        hiddenSelections[] = {""};
    };
    class TSL_ItemDisplay_2a136ee4e35f: TSL_Decor {
        model = "\bsqdn_caps\cap1.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_dab4c8eaff1e: TSL_Decor {
        model = "\bsqdn_caps\cap2.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_64a70a453649: TSL_Decor {
        model = "\bsqdn_helmet_stone\bsqdn_helmet_stone_carbon.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_8a192e852938: TSL_Decor {
        model = "\bsqdn_helmet_stone\bsqdn_helmet_stone_carbon_nc.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_b51b0a6daab8: TSL_Decor {
        model = "\bsqdn_helmet_stone\bsqdn_helmet_stone_carbon_t.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_a4fe68dfdaae: TSL_Decor {
        model = "\bsqdn_helmet_stone\bsqdn_helmet_stone_carbon_t_nc.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_49ee83b5ee34: TSL_Decor {
        model = "\bsqdn_mh180\mh180.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_ae75e6a7d3e7: TSL_Decor {
        model = "\bsqdn_misc_headwear\squadron_beanie.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_5ea6b1e627c9: TSL_Decor {
        model = "\bsqdn_misc_headwear\squadron_beanie_peltor.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_2c06c3ae563d: TSL_Decor {
        model = "\bsqdn_misc_headwear\ua_beanie.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_87dfd18c1419: TSL_Decor {
        model = "\bsqdn_misc_headwear\ua_beanie_peltor.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_e7ce32425725: TSL_Decor {
        model = "\bsqdn_misc_headwear\ua_fleece_beanie.p3d";
        hiddenSelections[] = {"beanie"};
    };
    class TSL_ItemDisplay_2961c8f49de6: TSL_Decor {
        model = "\bsqdn_misc_headwear\ua_fleece_beanie_peltor.p3d";
        hiddenSelections[] = {"beanie"};
    };
    class TSL_ItemDisplay_a77c2ca6af88: TSL_Decor {
        model = "\bsqdn_misc_headwear\ua_fleece_beanie_oe.p3d";
        hiddenSelections[] = {"beanie"};
    };
    class TSL_ItemDisplay_07b0bccf9e83: TSL_Decor {
        model = "\bsqdn_misc_headwear\ua_fleece_beanie_oe_peltor.p3d";
        hiddenSelections[] = {"beanie"};
    };
    class TSL_ItemDisplay_3c3cde055a7e: TSL_Decor {
        model = "\a3\weapons_f\empty.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_6bae5cc329a6: TSL_Decor {
        model = "\bsqdn_nightvision\nvg_down_underpatch.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_7f5a8f6c46db: TSL_Decor {
        model = "\bsqdn_nightvision\nvg_up_underpatch.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_34b0e99480f2: TSL_Decor {
        model = "\bsqdn_nightvision\nvg_down_underpatch_nr.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_ad7399fd2e0a: TSL_Decor {
        model = "\bsqdn_nightvision\nvg_up_underpatch_nr.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_966c3c6d8031: TSL_Decor {
        model = "\bsqdn_nightvision\nvg_down_arcrail.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_ec477a871596: TSL_Decor {
        model = "\bsqdn_nightvision\nvg_up_arcrail.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_c4b9b1d21e85: TSL_Decor {
        model = "\bsqdn_nightvision\nvg_down_arcrail_nr.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_ca165beb57ff: TSL_Decor {
        model = "\bsqdn_nightvision\nvg_up_arcrail_nr.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_7e138c428bfc: TSL_Decor {
        model = "\bsqdn_nightvision\nvg_stowed_underpatch.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_94e6643cf781: TSL_Decor {
        model = "\bsqdn_nightvision\nvg_stowed_arcrail.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_97573356ae37: TSL_Decor {
        model = "\bsqdn_peltor_tactical\bsqdn_peltor_tactical.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_a61f06076c4c: TSL_Decor {
        model = "\a3\characters_f\blufor\equip_b_bandolier.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_268a68b123a4: TSL_Decor {
        model = "\bsqdn_personal_sem\bsqdn_sem_1961.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_5108915209c2: TSL_Decor {
        model = "\bsqdn_personal_sem\bsqdn_sem_1961_c.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_bb3880071ed7: TSL_Decor {
        model = "\bsqdn_personal_sem\bsqdn_sem_1961_dual.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_20338bb9f11c: TSL_Decor {
        model = "\bsqdn_personal_sem\bsqdn_sem_1961_dual_c.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_48612328b28a: TSL_Decor {
        model = "\bsqdn_sling\bsqdn_sling.p3d";
        hiddenSelections[] = {"sling"};
    };
    class TSL_ItemDisplay_1b343492a488: TSL_Decor {
        model = "\bsqdn_uniform_chimera\bsqdn_uniform_chimera_ut.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_cb27a8aa5bdd: TSL_Decor {
        model = "\bsqdn_uniform_chimera_ss\g2_chimera_ut.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_e0ecc61bf2b4: TSL_Decor {
        model = "\bsqdn_uniform_chimera_ss\g2_chimera_ut_g.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_3e8fe05a295d: TSL_Decor {
        model = "\bsqdn_uniform_marmot\bsqdn_uniform_g2_marmot.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_522f9dddd524: TSL_Decor {
        model = "\bsqdn_uniform_marmot\bsqdn_uniform_g2_marmot_v.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_c26b0153affb: TSL_Decor {
        model = "\bsqdn_uniform_minotaur\bsqdn_uniform_minotaur.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_2cddae6d1645: TSL_Decor {
        model = "\bsqdn_uniform_minotaur\bsqdn_uniform_minotaur_g.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_dd4ff2c7d685: TSL_Decor {
        model = "\bsqdn_uniform_patagonia_r2\bsqdn_uniform_patagonia_r2.p3d";
        hiddenSelections[] = {"r2"};
    };
    class TSL_ItemDisplay_ccbf8758d8cc: TSL_Decor {
        model = "\bsqdn_uniform_patagonia_r2\bsqdn_uniform_patagonia_r2_g.p3d";
        hiddenSelections[] = {"r2"};
    };
    class TSL_ItemDisplay_c8f556d6c742: TSL_Decor {
        model = "\bsqdn_uniform_pcu\bsqdn_uniform_g2_pcu.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_3c3c56e2688c: TSL_Decor {
        model = "\bsqdn_uniform_pcu\bsqdn_uniform_g2_pcu_g.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_a8764260f8fd: TSL_Decor {
        model = "\bsqdn_uniform_pcu\bsqdn_uniform_jeans_pcu.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_ccf56682d807: TSL_Decor {
        model = "\bsqdn_uniform_pcu\bsqdn_uniform_jeans_pcu_g.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_d6d973aea4fa: TSL_Decor {
        model = "\bsqdn_uniform_shirts\g2_tucked.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_13aacc500270: TSL_Decor {
        model = "\bsqdn_uniform_shirts\g2_untucked.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_03d8c39ff2b0: TSL_Decor {
        model = "\bsqdn_uniform_shirts\g2_tucked_g.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_fd67fbcce8f1: TSL_Decor {
        model = "\bsqdn_uniform_shirts\g2_untucked_g.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_7ee0e5ed90b8: TSL_Decor {
        model = "\bsqdn_uniform_sphinx\bsqdn_uniform_sphinx_ut.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_ca6d60ac2aa6: TSL_Decor {
        model = "\bsqdn_uniform_sphinx\bsqdn_uniform_sphinx_ut_g.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_2dbb3f6d8935: TSL_Decor {
        model = "\bsqdn_uniform_sphinx\bsqdn_uniform_sphinx_ss_ut.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_35aa5ff8f3f2: TSL_Decor {
        model = "\bsqdn_uniform_sphinx\bsqdn_uniform_sphinx_ss_ut_g.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_318f68e95066: TSL_Decor {
        model = "\bsqdn_uniform_stone\bsqdn_uniform_stone.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_9d352b6bac50: TSL_Decor {
        model = "\bsqdn_uniform_stone\bsqdn_uniform_stone_ut.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_3e8240e97590: TSL_Decor {
        model = "\bsqdn_uniform_stone\bsqdn_minotaur_stone.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_33c20ee8f37b: TSL_Decor {
        model = "\bsqdn_uniform_stone\bsqdn_ironclad_stone_t.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_fb9b39ba4f2c: TSL_Decor {
        model = "\bsqdn_uniform_stone\bsqdn_ironclad_stone_ut.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_ce6d6d1e23d0: TSL_Decor {
        model = "\bsqdn_uniform_stone\bsqdn_ua_stone_t.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_6103e80c9e5d: TSL_Decor {
        model = "\bsqdn_uniform_stone\bsqdn_ua_stone_ut.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_cc25ca280611: TSL_Decor {
        model = "\bsqdn_vest_stone\bsqdn_vest_stone_m4.p3d";
        hiddenSelections[] = {""};
    };
    class TSL_ItemDisplay_aac23dbc2991: TSL_Decor {
        model = "\bsqdn_vest_stone\bsqdn_vest_stone_mp7.p3d";
        hiddenSelections[] = {""};
    };
    class TSL_ItemDisplay_2016625872d2: TSL_Decor {
        model = "\a3\characters_f\blufor\headgear_b_helmet_light.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_c72d968f3e0b: TSL_Decor {
        model = "\dght\dght1.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_b85fa00713b0: TSL_Decor {
        model = "\dght\dght2.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_b66c4b98b778: TSL_Decor {
        model = "\dght\dght3.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_88a7d35a24a7: TSL_Decor {
        model = "\dght\dght4.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_2d4f4047c81b: TSL_Decor {
        model = "\dght\dght5.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_85fff1dc69cf: TSL_Decor {
        model = "\dght\dght6.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_5fceaafb9a84: TSL_Decor {
        model = "\dght\dght7.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_4338e71658b0: TSL_Decor {
        model = "\dght\dght8.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_3cea96f2d219: TSL_Decor {
        model = "\dght\dght9.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_8d45801104f5: TSL_Decor {
        model = "\dght\dght10.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_f2d122b82225: TSL_Decor {
        model = "\dght\dght11.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_45ce1b125fef: TSL_Decor {
        model = "\dght\dght12.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_7d968a2b2617: TSL_Decor {
        model = "\dght\dght13.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_1dceba4a04ec: TSL_Decor {
        model = "\dght\dght14.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_a796ab8ecdb4: TSL_Decor {
        model = "\dght\dght15.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_dc23c7f10791: TSL_Decor {
        model = "\dght\dght16.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_3bb7ff35081d: TSL_Decor {
        model = "\dght\dght17.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_05499b535216: TSL_Decor {
        model = "\dgodvt\dgodvt1.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_adc4f784ca39: TSL_Decor {
        model = "\dgodvt\dgodvt2.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_bc6ea0c7ffe8: TSL_Decor {
        model = "\dgodvt\dgodvt3.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_5483c5d57d6f: TSL_Decor {
        model = "\dgodvt\dgodvt4.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_090cce6e7e12: TSL_Decor {
        model = "\dgodvt\dgodvt5.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_730b0c793ed7: TSL_Decor {
        model = "\dgodvt\dgodvt6.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_87b4dbc77c77: TSL_Decor {
        model = "\dgodvt\dgodvt7.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_379b77dde30c: TSL_Decor {
        model = "\dgodvt\dgodvt8.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_d8e02dfdfafc: TSL_Decor {
        model = "\dgodvt\dgodvt9.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_e38784ff891a: TSL_Decor {
        model = "\dgodvt\dgodvt10.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_e43e5973aa6d: TSL_Decor {
        model = "\dgodvt\dgodvt11.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_8f28ff8797f0: TSL_Decor {
        model = "\dgodvt\dgodvt12.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_546252f2f4c9: TSL_Decor {
        model = "\dgodvt\dgodvt13.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_b8fa04d8d42e: TSL_Decor {
        model = "\dgodvt\dgodvt14.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_24f82d0a949b: TSL_Decor {
        model = "\dgodvt\dgodvt15.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_254bba6f1362: TSL_Decor {
        model = "\dgodvt\dgodvt16.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_4d327587dc64: TSL_Decor {
        model = "\dgodvt\dgodvt17.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_d79482468ba3: TSL_Decor {
        model = "\dgodvt\dgodvt18.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_8bd9b54759ea: TSL_Decor {
        model = "\dgodvt\dgodvt19.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_86eac089fd0c: TSL_Decor {
        model = "\dgodvt\dgodvt20.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_a6a81bbd84f2: TSL_Decor {
        model = "\dgodvt\dgodvt21.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_3fcd985b9fa8: TSL_Decor {
        model = "\dgodvt\dgodvt22.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_9435cd7fd364: TSL_Decor {
        model = "\dgodvt\dgodvt23.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_87218bd96e1c: TSL_Decor {
        model = "\dgodvt\dgodvt24.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_3240d18ccd28: TSL_Decor {
        model = "\dgodvt\dgodvt25.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_c64d7a91c57f: TSL_Decor {
        model = "\dgodvt\dgodvt26.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_496adb8af28e: TSL_Decor {
        model = "\dgodvt\dgodvt27.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_9bc41de981e2: TSL_Decor {
        model = "\dgplatecarriers\lbt_6094a_1.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_dfa8138a436e: TSL_Decor {
        model = "\dgplatecarriers\lbt_6094a_2.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_7a5bf8df8df7: TSL_Decor {
        model = "\dgplatecarriers\lbt_6094a_3.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_fef5d42f7868: TSL_Decor {
        model = "\dgplatecarriers\lbt_6094a_4.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_05d45d61a964: TSL_Decor {
        model = "\dgplatecarriers\lbt_6094a_5.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_b5d9637eb367: TSL_Decor {
        model = "\dgplatecarriers\lbt_6094a_6.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_7838c2099e6c: TSL_Decor {
        model = "\dgplatecarriers\lbt_6094a_7.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_3c2e712e5ac7: TSL_Decor {
        model = "\dgplatecarriers\lbt_6094k_1.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_611e167981d6: TSL_Decor {
        model = "\dgplatecarriers\lbt_6094k_2.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_f06f38c096f9: TSL_Decor {
        model = "\dgplatecarriers\lbt_6094k_3.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_25612d1bfde3: TSL_Decor {
        model = "\dgplatecarriers\lbt_6094k_4.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_72c6ea734b3c: TSL_Decor {
        model = "\dgplatecarriers\lbt_6094k_5.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_9af84eb033ab: TSL_Decor {
        model = "\dgplatecarriers\lbt_6094k_6.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_89e628af51e5: TSL_Decor {
        model = "\dgplatecarriers\lbt_6094k_7.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_efec7b73f772: TSL_Decor {
        model = "\dgplatecarriers\lbt_6094k_8.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_4fd294213a30: TSL_Decor {
        model = "\dgplatecarriers\lbt_6094k_9.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_ac967d222fec: TSL_Decor {
        model = "\dgplatecarriers\lbt_6094k_10.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_4464675f59c5: TSL_Decor {
        model = "\dgplatecarriers\ncpc_1.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_341da01b120e: TSL_Decor {
        model = "\dgplatecarriers\ncpc_2.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_8e02e764871e: TSL_Decor {
        model = "\dgplatecarriers\ncpc_3.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_71d6dc0dfd45: TSL_Decor {
        model = "\dgplatecarriers\ncpc_4.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_95d9542f2de3: TSL_Decor {
        model = "\dgplatecarriers\lbt_6094s_1961g_1.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_d395243e1189: TSL_Decor {
        model = "\dgplatecarriers\lbt_6094s_chestrig_mg.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_73e91aca9240: TSL_Decor {
        model = "\dgplatecarriers\njpc_1.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_41aa21201b6c: TSL_Decor {
        model = "\dgplatecarriers\njpc_2.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_9fd218e03086: TSL_Decor {
        model = "\dgplatecarriers\njpc_3.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_0c093be9f126: TSL_Decor {
        model = "\dgplatecarriers\njpc_4.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_e8c2ed9220d3: TSL_Decor {
        model = "\dgplatecarriers\njpc_5.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_0110c9678984: TSL_Decor {
        model = "\dgplatecarriers\njpc_6.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_169b602e5bc5: TSL_Decor {
        model = "\dgplatecarriers\njpc_7.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_927048e6ef7a: TSL_Decor {
        model = "\dgplatecarriers\njpc_8.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_b9ef53412bef: TSL_Decor {
        model = "\dgplatecarriers\lbt_94k_007_1.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_2a86317e6613: TSL_Decor {
        model = "\dgplatecarriers\lbt_oldgen_1.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_9e6259cfbbd6: TSL_Decor {
        model = "\dgplatecarriers\lbt_oldgen_2.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_947fc3a04232: TSL_Decor {
        model = "\dgplatecarriers\lbt_oldgen_3.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_6f43dcdc5514: TSL_Decor {
        model = "\dgplatecarriers2\lbt94k_07_1.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_e02911dffe27: TSL_Decor {
        model = "\dgplatecarriers2\lbt94k_07_2.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_5472d962df2a: TSL_Decor {
        model = "\dgplatecarriers2\lbt94a_tanweb_1.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_eb2d459293a6: TSL_Decor {
        model = "\dg_rigs\lbt1961_1.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_4f31b54638ef: TSL_Decor {
        model = "\dg_rigs\lbt1961_1_2.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_649d8b7fa729: TSL_Decor {
        model = "\dg_rigs\lbt1961_navy_1.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_b34268ea3786: TSL_Decor {
        model = "\dht\dht1.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_5d3463a5a9bb: TSL_Decor {
        model = "\dht\dht2.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_5d1d35548391: TSL_Decor {
        model = "\dht\dht3.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_505d6f4d0b98: TSL_Decor {
        model = "\dht\dht4.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_6d565d874670: TSL_Decor {
        model = "\dht\dht5.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_e6f50da5422e: TSL_Decor {
        model = "\dht\dht6.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_deae1cd9afbb: TSL_Decor {
        model = "\dht\dht7.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_1069e02111e0: TSL_Decor {
        model = "\dht\dht8.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_f37bc5f5ad22: TSL_Decor {
        model = "\dht\dht9.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_32136f57bfcc: TSL_Decor {
        model = "\dht\dht10.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_bf2805e1192b: TSL_Decor {
        model = "\dht\dht11.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_c5d94aab8b07: TSL_Decor {
        model = "\dht\dht12.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_1fb2d9ce19fa: TSL_Decor {
        model = "\dht\dht13.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_618f0e647a04: TSL_Decor {
        model = "\dht\dht14.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_64827300c672: TSL_Decor {
        model = "\dht\dht15.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_640effa2fe08: TSL_Decor {
        model = "\ibh_h\ibh_2.p3d";
        hiddenSelections[] = {""};
    };
    class TSL_ItemDisplay_a4f3e8d65d98: TSL_Decor {
        model = "\ibh_h\ibh_3.p3d";
        hiddenSelections[] = {""};
    };
    class TSL_ItemDisplay_9c8b0abeb543: TSL_Decor {
        model = "\ibh_h\ibh_4.p3d";
        hiddenSelections[] = {""};
    };
    class TSL_ItemDisplay_282d1b9a6920: TSL_Decor {
        model = "\ibh_h\ibh_5.p3d";
        hiddenSelections[] = {""};
    };
    class TSL_ItemDisplay_7e6039a88a7b: TSL_Decor {
        model = "\ibh_h\ibh_6.p3d";
        hiddenSelections[] = {""};
    };
    class TSL_ItemDisplay_ce1de3a134f2: TSL_Decor {
        model = "\ibh_h\ibh_7.p3d";
        hiddenSelections[] = {""};
    };
    class TSL_ItemDisplay_c4db8e60592e: TSL_Decor {
        model = "\m_devgru\model\maritime.p3d";
        hiddenSelections[] = {"comtac3", "manta", "strap2"};
    };
    class TSL_ItemDisplay_81693e364eb4: TSL_Decor {
        model = "\m_devgru\model\maritime.p3d";
        hiddenSelections[] = {"comtac3", "manta", "strap"};
    };
    class TSL_ItemDisplay_fb8500eeebb1: TSL_Decor {
        model = "\m_devgru\model\maritime.p3d";
        hiddenSelections[] = {"manta", "strap2"};
    };
    class TSL_ItemDisplay_88fd91b2cd47: TSL_Decor {
        model = "\m_devgru\model\maritime.p3d";
        hiddenSelections[] = {"manta", "strap"};
    };
    class TSL_ItemDisplay_972267d4e4ff: TSL_Decor {
        model = "\m_devgru\model\maritime.p3d";
        hiddenSelections[] = {"comtac3", "strap2"};
    };
    class TSL_ItemDisplay_e0b2a8d26e07: TSL_Decor {
        model = "\m_devgru\model\maritime.p3d";
        hiddenSelections[] = {"comtac3", "strap"};
    };
    class TSL_ItemDisplay_27ae43c65213: TSL_Decor {
        model = "\m_devgru\model\maritime.p3d";
        hiddenSelections[] = {"strap2"};
    };
    class TSL_ItemDisplay_3c911639239a: TSL_Decor {
        model = "\m_devgru\model\maritime.p3d";
        hiddenSelections[] = {"strap"};
    };
    class TSL_ItemDisplay_22f5d91968ae: TSL_Decor {
        model = "\m_devgru\model\maritime_pvs15_on.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_6ed5b9f1ffb5: TSL_Decor {
        model = "\m_devgru\model\pvs15_on.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_1e2c99c856e5: TSL_Decor {
        model = "\m_devgru\model\pvs15_off.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_e8e60228f8a0: TSL_Decor {
        model = "\m_devgru\model\pvs15_on.p3d";
        hiddenSelections[] = {"pvs15_m", "pvs15_b"};
    };
    class TSL_ItemDisplay_3f0f1fcf8aeb: TSL_Decor {
        model = "\m_devgru\model\pvs15_off.p3d";
        hiddenSelections[] = {"pvs15_m", "pvs15_b"};
    };
    class TSL_ItemDisplay_9ba1915670b0: TSL_Decor {
        model = "\m_devgru\model\lbt_6094s_1961a_base.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_93577cff956c: TSL_Decor {
        model = "\m_devgru\model\lbt_6094s_1961g_base.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_d37231f89daa: TSL_Decor {
        model = "\m_devgru\model\lbt_6094s_base.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_e61d3daf7f2c: TSL_Decor {
        model = "\m_devgru\model\lbt_6094a_base.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_c966db97687b: TSL_Decor {
        model = "\m_devgru\model\lbt_1961a_base.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_c5db4ef3f14c: TSL_Decor {
        model = "\m_devgru\model\lbt_1961g_base.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_67b9e40c01e1: TSL_Decor {
        model = "\m_devgru\model\lbt_6094s_ar.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_5a80341b5ad8: TSL_Decor {
        model = "\m_devgru\model\lbt_6094s_mg.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_0d2c66770513: TSL_Decor {
        model = "\m_devgru\model\lbt_6094s_smg.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_baf8f5f2d169: TSL_Decor {
        model = "\m_devgru_v2\model\lbt_6094s_1961a_base1.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_3112825772df: TSL_Decor {
        model = "\m_devgru_v2\model\lbt_6094s_1961g_base1.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_ac6b944ed357: TSL_Decor {
        model = "\m_devgru_v2\model\lbt_6094s_base1.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_e0a50b5afc33: TSL_Decor {
        model = "\m_devgru_v2\model\lbt_1961a_base1.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_9b86095a8d2d: TSL_Decor {
        model = "\m_devgru_v2\model\lbt_1961g_base1.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_4bf47ac5c38e: TSL_Decor {
        model = "\oppi\oppi_mt_hr.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_2b514cb9b67d: TSL_Decor {
        model = "\ramirez\ramirez.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_f3493555854d: TSL_Decor {
        model = "\ramirez\ramirez_b.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_ee6be513462b: TSL_Decor {
        model = "\ramirez\mt_nc.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_9fb44e40a412: TSL_Decor {
        model = "\ramirez\mt_c.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_602b543c2ca4: TSL_Decor {
        model = "\roachshorts\holster.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_9791884ea50b: TSL_Decor {
        model = "\devgru\tacdev\rs_identity_colten\models\beard.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_cd76f6c364b1: TSL_Decor {
        model = "\devgru\tacdev\rs_identity_cutrer\models\beard.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_41067bc5b41a: TSL_Decor {
        model = "\devgru\tacdev\rs_identity_cutrer\models\beard_nh.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_4dab50c59fbb: TSL_Decor {
        model = "\rwht\rwht1.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_6c9f4c9b946b: TSL_Decor {
        model = "\rwht\rwht2.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_f348f9ea1f80: TSL_Decor {
        model = "\rwht\rwht3.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_2fcd00d73b85: TSL_Decor {
        model = "\rwht\rwht4.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_30659484c022: TSL_Decor {
        model = "\rwht\rwht5.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_23e6111895db: TSL_Decor {
        model = "\rwht\rwht6.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_e6877f6a1024: TSL_Decor {
        model = "\rwht\rwht7.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_3b9afcd93877: TSL_Decor {
        model = "\rwnvg\rwnvg1on.p3d";
        hiddenSelections[] = {"camo1"};
    };
    class TSL_ItemDisplay_b5223c2af1cf: TSL_Decor {
        model = "\rwnvg\rwnvg1off.p3d";
        hiddenSelections[] = {"camo1"};
    };
    class TSL_ItemDisplay_be11287938c2: TSL_Decor {
        model = "\rwnvg\rwnvg2on.p3d";
        hiddenSelections[] = {"camo1"};
    };
    class TSL_ItemDisplay_8145a1f391aa: TSL_Decor {
        model = "\rwnvg\rwnvg2off.p3d";
        hiddenSelections[] = {"camo1"};
    };
    class TSL_ItemDisplay_a53d5af3eb3d: TSL_Decor {
        model = "\rwvest\rwvest1.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_c591f41d4ceb: TSL_Decor {
        model = "\rwvest\rwvest2.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_b581456897d9: TSL_Decor {
        model = "\rwvest\rwvest3.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_72b29994c0e4: TSL_Decor {
        model = "\rwvest\rwvest4.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_68cc8c8831b4: TSL_Decor {
        model = "\tacdev5_uniform_ua_ss\ua_ss.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_96625907ce2a: TSL_Decor {
        model = "\tierone_helmets\maritime_gpnvg18_on.p3d";
        hiddenSelections[] = {""};
    };
    class TSL_ItemDisplay_89fb3185a111: TSL_Decor {
        model = "\xyi_tier3\model\anvis_on.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_67fe79b09bca: TSL_Decor {
        model = "\xyi_tier3\model\anvis_v1.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_edfc37f868e9: TSL_Decor {
        model = "\xyi_tier3\model\anvis_v2.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_3156b03f4399: TSL_Decor {
        model = "\xyi_tier3\model\anvis_v3.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_ac579a0a02e8: TSL_Decor {
        model = "\xyi_tier3\model\anvis_v4.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_80e0169aa002: TSL_Decor {
        model = "\xyi_tier3\model\l2g05_on.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_5538b3a50d7d: TSL_Decor {
        model = "\xyi_tier3\model\l2g05_v1.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_bca8c1978ea3: TSL_Decor {
        model = "\xyi_tier3\model\l2g05_v2.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_100d3bdfc282: TSL_Decor {
        model = "\xyi_tier3\model\l3g10_on.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_3a7dfe7583d8: TSL_Decor {
        model = "\xyi_tier3\model\l3g10_v1.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_6c5f75a5be4c: TSL_Decor {
        model = "\xyi_tier3\model\l3g10_v2.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_f648aac6e9e1: TSL_Decor {
        model = "\xyi_tier3\model\l3g10_v3.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_ea7df51b2853: TSL_Decor {
        model = "\xyi_tier3\model\pvs14_on.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_624e796c4c6e: TSL_Decor {
        model = "\xyi_tier3\model\pvs14_v1.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_e74b17da766c: TSL_Decor {
        model = "\xyi_tier3\model\pvs14_v2.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_3ccc96d30b5f: TSL_Decor {
        model = "\xyi_tier3\model\tatm_on.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_87b6da5ee7ef: TSL_Decor {
        model = "\xyi_tier3\model\tatm_v1.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_30ff165324fc: TSL_Decor {
        model = "\xyi_tier3\model\tatm_v2.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_05a0c1bea162: TSL_Decor {
        model = "\xyi_tier3\model\tatm_v3.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_5be407864fcc: TSL_Decor {
        model = "\xyi_tier3\model\mich2000_v1.p3d";
        hiddenSelections[] = {"camo1", "camo3"};
    };
    class TSL_ItemDisplay_72c88a7760a7: TSL_Decor {
        model = "\xyi_tier3\model\mich2000_v2.p3d";
        hiddenSelections[] = {"camo1", "camo3"};
    };
    class TSL_ItemDisplay_a52d0e731be9: TSL_Decor {
        model = "\xyi_tier3\model\mich2000_v3.p3d";
        hiddenSelections[] = {"camo1", "camo3"};
    };
    class TSL_ItemDisplay_186ce1464a3c: TSL_Decor {
        model = "\xyi_tier3\model\mich2000_v4.p3d";
        hiddenSelections[] = {"camo1", "camo3"};
    };
    class TSL_ItemDisplay_817bb67fe251: TSL_Decor {
        model = "\xyi_tier3\model\mich2000_v5.p3d";
        hiddenSelections[] = {"camo1", "camo3"};
    };
    class TSL_ItemDisplay_618f614dcc54: TSL_Decor {
        model = "\xyi_tier3\model\mich2000_v6.p3d";
        hiddenSelections[] = {"camo1", "camo3"};
    };
    class TSL_ItemDisplay_14eb719b95c6: TSL_Decor {
        model = "\xyi_tier3\model\mich2000_v7.p3d";
        hiddenSelections[] = {"camo1", "camo3"};
    };
    class TSL_ItemDisplay_626a4c924d51: TSL_Decor {
        model = "\xyi_tier3\model\mich2000_v8.p3d";
        hiddenSelections[] = {"camo1", "camo3"};
    };
    class TSL_ItemDisplay_18cf4a7c15b4: TSL_Decor {
        model = "\xyi_tier3\model\mich2000_v9.p3d";
        hiddenSelections[] = {"camo1", "camo3"};
    };
    class TSL_ItemDisplay_b17c04bc5cb7: TSL_Decor {
        model = "\xyi_tier3\model\mich2000_v10.p3d";
        hiddenSelections[] = {"camo1", "camo3"};
    };
    class TSL_ItemDisplay_6c9ae90ee7d7: TSL_Decor {
        model = "\xyi_tier3\model\mich2000_v11.p3d";
        hiddenSelections[] = {"camo1", "camo3"};
    };
    class TSL_ItemDisplay_8ce221aeec49: TSL_Decor {
        model = "\xyi_tier3\model\mich2000_v12.p3d";
        hiddenSelections[] = {"camo1", "camo3"};
    };
    class TSL_ItemDisplay_730c6206baa1: TSL_Decor {
        model = "\xyi_tier3\model\mich2000_v13.p3d";
        hiddenSelections[] = {"camo1", "camo3"};
    };
    class TSL_ItemDisplay_7ad04b0c73cd: TSL_Decor {
        model = "\xyi_tier3\model\mich2000_v14.p3d";
        hiddenSelections[] = {"camo1", "camo3"};
    };
    class TSL_ItemDisplay_1638b217f5ae: TSL_Decor {
        model = "\xyi_tier3\model\mich2000_v15.p3d";
        hiddenSelections[] = {"camo1", "camo3"};
    };
    class TSL_ItemDisplay_4bdb5cb1fb60: TSL_Decor {
        model = "\xyi_tier3\model\mich2000_v16.p3d";
        hiddenSelections[] = {"camo1", "camo3"};
    };
    class TSL_ItemDisplay_2bf37028111b: TSL_Decor {
        model = "\xyi_tier3\model\mich2000_v17.p3d";
        hiddenSelections[] = {"camo1", "camo3"};
    };
    class TSL_ItemDisplay_2292979aa88f: TSL_Decor {
        model = "\xyi_tier3\model\mich2000_v18.p3d";
        hiddenSelections[] = {"camo1", "camo3"};
    };
    class TSL_ItemDisplay_d70859bd15dc: TSL_Decor {
        model = "\xyi_tier3\model\ciras_v1.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_70d29ba92b35: TSL_Decor {
        model = "\xyi_tier3\model\ciras_v2.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_ae9cceb966f9: TSL_Decor {
        model = "\xyi_tier3\model\ciras_v3.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_e6493044ce8d: TSL_Decor {
        model = "\xyi_tier3\model\ciras_v4.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_1f152d6f72bd: TSL_Decor {
        model = "\xyi_tier3\model\ciras_v5.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_bc3f5b14c424: TSL_Decor {
        model = "\xyi_tier3\model\ciras_v6.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_95f9c2d147c0: TSL_Decor {
        model = "\xyi_tier3\model\ciras_v7.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_ed2f2eb4da5b: TSL_Decor {
        model = "\xyi_tier3\model\ciras_v8.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_5183a54f95b2: TSL_Decor {
        model = "\xyi_tier3\model\ciras_v9.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_9c07677ef321: TSL_Decor {
        model = "\xyi_tier3\model\ciras_v10.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_574ccc9daff2: TSL_Decor {
        model = "\xyi_tier3\model\mbav_v1.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_bad2df1ed633: TSL_Decor {
        model = "\xyi_tier3\model\mbav_v2.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_bd93f27dfada: TSL_Decor {
        model = "\xyi_tier3\model\mbav_v3.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_e9cd9d937355: TSL_Decor {
        model = "\xyi_tier3\model\mbav_v4.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_98f7dfc5129e: TSL_Decor {
        model = "\xyi_tier3\model\mbav_v5.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_cb2ab033ae7f: TSL_Decor {
        model = "\xyi_tier3\model\mbav_v6.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_bbefdac1ecc1: TSL_Decor {
        model = "\xyi_tier3\model\mbav_v7.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_6bf7941ea06f: TSL_Decor {
        model = "\xyi_tier3\model\mbav_v8.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_e097ec3b6b7a: TSL_Decor {
        model = "\xyi_tier3\model\mbav_v9.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_e78eb6fc6fa0: TSL_Decor {
        model = "\xyi_tier3\model\mbav_v10.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_abf4521f1ece: TSL_Decor {
        model = "\xyi_tier3\model\mbav_v11.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_c48fdaf57e18: TSL_Decor {
        model = "\xyi_tier3\model\mbav_v12.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_0859cc44ad4c: TSL_Decor {
        model = "\xyi_tier3\model\mbav_v13.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_b1ead6eebb9a: TSL_Decor {
        model = "\xyi_tier3\model\mbav_v14.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_e05fd20b4746: TSL_Decor {
        model = "\xyi_tier3\model\mbav_v15.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_fc2baadadcc1: TSL_Decor {
        model = "\xyi_tier3\model\mbav_v16.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_9ff7e56bdd1e: TSL_Decor {
        model = "\xyi_tier3\model\mbav_v17.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_7f040003fdd3: TSL_Decor {
        model = "\xyi_tier3\model\rbav_v1.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_d534dd4dd7f5: TSL_Decor {
        model = "\a3\characters_f\opfor\headgear_o_helmet_ballistic.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_aabf9adfc4e5: TSL_Decor {
        model = "\a3\characters_f_epa\blufor\headgear_b_helmet_kerry.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_8810e090fbf9: TSL_Decor {
        model = "\a3\characters_f\blufor\headgear_b_helmet_ballistic.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_13f3a05bf7ce: TSL_Decor {
        model = "\navspecwargru2\navspecwargru2_tacdev_armory_nod\tm_down.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_d7d9f9961a49: TSL_Decor {
        model = "\navspecwargru2\navspecwargru2_tacdev_armory_nod\tm_down_mt.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_e34ec65e53ee: TSL_Decor {
        model = "\navspecwargru2\navspecwargru2_tacdev_armory_nod\tm_up.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_ded12df4e3b6: TSL_Decor {
        model = "\navspecwargru2\navspecwargru2_tacdev_armory_nod\tm_up_mt.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_2c1e953eb126: TSL_Decor {
        model = "\navspecwargru2\navspecwargru2_tacdev_armory_nod\tm_gpnvg_te_ec_on.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_d3978b5ec469: TSL_Decor {
        model = "\navspecwargru2\navspecwargru2_tacdev_armory_nod\tm_gpnvg_te_ec_off_oe.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_9e1daab13348: TSL_Decor {
        model = "\a3\weapons_f\binocular\nvg_proxy.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_c271b0425eaf: TSL_Decor {
        model = "\navspecwargru2\navspecwargru2_tacdev_armory_nod\tm_gpnvg_te_ec_on_mt.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_facebdd8dcad: TSL_Decor {
        model = "\navspecwargru2\navspecwargru2_tacdev_armory_nod\tm_gpnvg_te_ec_off_oe_mt.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_40ce370552e5: TSL_Decor {
        model = "\navspecwargru2\navspecwargru2_tacdev_armory_nod\tm_gpnvg_te_ec_on_cov.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_b9600b50e2e6: TSL_Decor {
        model = "\navspecwargru2\navspecwargru2_tacdev_armory_nod\tm_gpnvg_te_ec_off_oe_cov.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_8c9cd4497e31: TSL_Decor {
        model = "\navspecwargru2\navspecwargru2_tacdev_armory_nod\tm_gpnvg_te_ec_off_up.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_b73583e71479: TSL_Decor {
        model = "\navspecwargru2\navspecwargru2_tacdev_armory_nod\tm_gpnvg_te_ec_off_up_mt.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_51dc7534b1f0: TSL_Decor {
        model = "\navspecwargru2\navspecwargru2_tacdev_armory_nod\tm_gpnvg_te_ec_off_up_cov.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_b6d5c23f3534: TSL_Decor {
        model = "\navspecwargru2\navspecwargru2_tacdev_armory_nod\tm_pvs31_on.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_6389ba3482ea: TSL_Decor {
        model = "\navspecwargru2\navspecwargru2_tacdev_armory_nod\tm_pvs31_oe.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_1e2673a553d6: TSL_Decor {
        model = "\navspecwargru2\navspecwargru2_tacdev_armory_nod\tm_pvs31_on_mt.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_f25fd75fe0da: TSL_Decor {
        model = "\navspecwargru2\navspecwargru2_tacdev_armory_nod\tm_pvs31_oe_mt.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_40695a8f0ea7: TSL_Decor {
        model = "\navspecwargru2\navspecwargru2_tacdev_armory_nod\tm_pvs31_on_cov.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_c8cb6f235629: TSL_Decor {
        model = "\navspecwargru2\navspecwargru2_tacdev_armory_nod\tm_pvs31_oe_cov.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_00cc1495e6ae: TSL_Decor {
        model = "\navspecwargru2\navspecwargru2_tacdev_armory_nod\tm_pvs31_ou.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_16db8ba035c0: TSL_Decor {
        model = "\navspecwargru2\navspecwargru2_tacdev_armory_nod\tm_pvs31_ou_mt.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_77264fc40190: TSL_Decor {
        model = "\navspecwargru2\navspecwargru2_tacdev_armory_nod\tm_pvs31_ou_cov.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_3af0a485d568: TSL_Decor {
        model = "\taliban_fighters\gear\afghan_01hat.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_f92e0847e3e0: TSL_Decor {
        model = "\taliban_fighters\gear\afghan_02hat.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_f767d775387c: TSL_Decor {
        model = "\taliban_fighters\gear\afghan_03hat.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_458df8d135fe: TSL_Decor {
        model = "\taliban_fighters\gear\afghan_04hat.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_18e2c81ee1ef: TSL_Decor {
        model = "\taliban_fighters\gear\afghan_05hat.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_90a2fe08e55d: TSL_Decor {
        model = "\taliban_fighters\gear\afghan_06hat.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_f9015b36efa9: TSL_Decor {
        model = "\a3\characters_f_kart\civil\c_racinghelmet_f.p3d";
        hiddenSelections[] = {"camo1", "camo2"};
    };
    class TSL_ItemDisplay_2c49ddba2da9: TSL_Decor {
        model = "\a3\characters_f\common\capb_headphones.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_f19b150807e8: TSL_Decor {
        model = "\a3\characters_f\blufor\equip_b_bandolier.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_a8fc37922caa: TSL_Decor {
        model = "\a3\characters_f\blufor\equip_b_carrier_gl_rig.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_5e4a52fdb3c2: TSL_Decor {
        model = "\a3\characters_f\blufor\equip_b_carrier_spec_rig.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_c6fe80a290d1: TSL_Decor {
        model = "\a3\characters_f_beta\indep\equip_ia_vest02.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_2c365a0e8e4d: TSL_Decor {
        model = "\a3\characters_f_beta\indep\equip_ia_ga_carrier_gl_rig.p3d";
        hiddenSelections[] = {"camo1", "camo2"};
    };
    class TSL_ItemDisplay_bfe653542e16: TSL_Decor {
        model = "\a3\characters_f\blufor\equip_b_belt.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_0ac63da69a9f: TSL_Decor {
        model = "\a3\characters_f\blufor\equip_b_vest02.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_66e92f36cbdb: TSL_Decor {
        model = "\a3\characters_f\blufor\equip_b_vest01.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_1d5747c577d9: TSL_Decor {
        model = "\a3\characters_f\blufor\equip_b_vest01.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_dd28a218ac32: TSL_Decor {
        model = "\a3\characters_f\blufor\equip_b_vest02.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_93b326341f8c: TSL_Decor {
        model = "\a3\characters_f\common\equip_chestrig.p3d";
        hiddenSelections[] = {"camo1", "camo2"};
    };
    class TSL_ItemDisplay_13d62211eea0: TSL_Decor {
        model = "\a3\characters_f\common\equip_tacticalvest.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_920eca53c96f: TSL_Decor {
        model = "\a3\characters_f_beta\indep\equip_ir_vest01.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_a8cacb05360c: TSL_Decor {
        model = "\a3\characters_f\opfor\equip_o_vest01.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_5ae0e57ff5b6: TSL_Decor {
        model = "\a3\characters_f\opfor\equip_o_vest_gl.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_8960b4c070d7: TSL_Decor {
        model = "\a3\characters_f\opfor\equip_o_vest01.p3d";
        hiddenSelections[] = {"camo1", "camo2"};
    };
    class TSL_ItemDisplay_3c6cabccecf9: TSL_Decor {
        model = "\a3\characters_f\opfor\equip_o_vest_gl.p3d";
        hiddenSelections[] = {"camo1", "camo2"};
    };
    class TSL_ItemDisplay_4c9ee16f455f: TSL_Decor {
        model = "\a3\characters_f_beta\indep\equip_ia_vest01.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_8cc0f5983874: TSL_Decor {
        model = "\a3\characters_f\common\equip_rebreather.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_741862514487: TSL_Decor {
        model = "\a3\characters_f_epa\blufor\equip_b_vest_kerry.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_70fd8a5cfaf3: TSL_Decor {
        model = "\a3\characters_f_epc\civil\equip_press_vest_01.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_9bacf1f92350: TSL_Decor {
        model = "\a3\characters_f\blufor\headgear_b_helmet_plain.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_7a77c390ae8e: TSL_Decor {
        model = "\a3\characters_f\blufor\headgear_b_helmet_camo.p3d";
        hiddenSelections[] = {"camo1", "camo2"};
    };
    class TSL_ItemDisplay_a5e10df6479a: TSL_Decor {
        model = "\a3\characters_f\common\booniehat.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_7d5e7c400bc2: TSL_Decor {
        model = "\a3\characters_f_epb\common\booniehat_hs.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_d8d84498b88e: TSL_Decor {
        model = "\a3\characters_f_beta\indep\headgear_helmet_canvas.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_e6c9197bdd12: TSL_Decor {
        model = "\a3\characters_f\common\capb.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_8c2e7ed1452e: TSL_Decor {
        model = "\a3\characters_f_epb\common\capb_hs.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_432b5a2d50b6: TSL_Decor {
        model = "\a3\characters_f\blufor\headgear_b_helmet_crew.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_ae2ac93cc0cc: TSL_Decor {
        model = "\a3\characters_f_beta\indep\headgear_ia_helmet_crew.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_ca8e5d7c9c87: TSL_Decor {
        model = "\a3\characters_f\common\headgear_helmet_pilot.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_c9a48f038f28: TSL_Decor {
        model = "\a3\characters_f\common\headgear_helmet_heli.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_f69342e94a38: TSL_Decor {
        model = "\a3\characters_f\common\headgear_helmet_heli_shield.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_b4db641b612d: TSL_Decor {
        model = "\a3\characters_f\opfor\headgear_o_helmet_ballistic_hud.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_f4f0c8950c35: TSL_Decor {
        model = "\a3\characters_f\common\cappatrol.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_d08462628116: TSL_Decor {
        model = "\a3\characters_f\civil\headgear_c_capbandana01.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_d149df21db92: TSL_Decor {
        model = "\a3\characters_f\common\headgear_placeholder.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_078c145d7773: TSL_Decor {
        model = "\a3\characters_f\opfor\headgear_o_helmet_ballistic_spec.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_062e52964616: TSL_Decor {
        model = "\a3\characters_f\civil\headgear_c_bandana1.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_a1ca7f70085c: TSL_Decor {
        model = "\a3\characters_f_epb\civil\headgear_c_bandana1_hs.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_495b4dd1f994: TSL_Decor {
        model = "\a3\characters_f_gamma\guerrilla\headgear_shemagmask.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_7fd0895dcbc0: TSL_Decor {
        model = "\a3\characters_f_epb\guerrilla\headgear_shemagmask_hs.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_926b24d73df9: TSL_Decor {
        model = "\a3\characters_f\common\headgear_beret01.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_d63178e60bb5: TSL_Decor {
        model = "\a3\characters_f_epb\blufor\headgear_beret02.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_af33eae8bf5a: TSL_Decor {
        model = "\a3\characters_f\civil\headgear_beaniehat01.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_15e0785672a9: TSL_Decor {
        model = "\a3\characters_f\civil\headgear_turban.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_6042a3ee252f: TSL_Decor {
        model = "\a3\characters_f\civil\hat_straw.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_a89a381239e6: TSL_Decor {
        model = "\a3\characters_f\civil\hat.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_b4dcde6f3db5: TSL_Decor {
        model = "\afg_shemaghs_f\afg_f_shemagh_insr.p3d";
        hiddenSelections[] = {""};
    };
    class TSL_ItemDisplay_888f0389e5ff: TSL_Decor {
        model = "\afg_shemaghs_f\afg_f_shemagh_insr.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_c9626a6fd9d3: TSL_Decor {
        model = "\afg_shemaghs_f\afg_f_shemagh_mwa.p3d";
        hiddenSelections[] = {""};
    };
    class TSL_ItemDisplay_df3af0836039: TSL_Decor {
        model = "\afg_shemaghs_f\afg_f_shemagh_mwa.p3d";
        hiddenSelections[] = {"camo1"};
    };
    class TSL_ItemDisplay_37548eb5d318: TSL_Decor {
        model = "\afg_shemaghs_f\afg_f_shemagh_mwas.p3d";
        hiddenSelections[] = {""};
    };
    class TSL_ItemDisplay_46354bfd4f35: TSL_Decor {
        model = "\afg_shemaghs_f\afg_f_shemagh_mwas.p3d";
        hiddenSelections[] = {"camo1", "camo2"};
    };
    class TSL_ItemDisplay_3f64f5d80afe: TSL_Decor {
        model = "\afg_shemaghs_f\afg_f_shemagh_mwf.p3d";
        hiddenSelections[] = {""};
    };
    class TSL_ItemDisplay_7d7416143ff8: TSL_Decor {
        model = "\afg_shemaghs_f\afg_f_shemagh_mwf.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_d0e6b7cf88ef: TSL_Decor {
        model = "\afg_shemaghs_f\afg_nshemagh_mwa.p3d";
        hiddenSelections[] = {""};
    };
    class TSL_ItemDisplay_9c33db4480f5: TSL_Decor {
        model = "\afg_shemaghs_f\afg_nshemagh_mwa.p3d";
        hiddenSelections[] = {"camo2"};
    };
    class TSL_ItemDisplay_4131ac48cd2c: TSL_Decor {
        model = "\afg_shemaghs_f\afg_nshemagh_e.p3d";
        hiddenSelections[] = {""};
    };
    class TSL_ItemDisplay_acd2af504852: TSL_Decor {
        model = "\afg_shemaghs_f\afg_nshemagh_e.p3d";
        hiddenSelections[] = {"camo3"};
    };
    class TSL_ItemDisplay_8ca7a52d9807: TSL_Decor {
        model = "\afg_shemaghs_f\afg_nshemagh_f.p3d";
        hiddenSelections[] = {""};
    };
    class TSL_ItemDisplay_1bde826384ac: TSL_Decor {
        model = "\afg_shemaghs_f\afg_nshemagh_f.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_ca5b2c8d4c13: TSL_Decor {
        model = "\bsqdn_facewear\gascan.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_b3541b51f575: TSL_Decor {
        model = "\bsqdn_facewear\gascan_oh.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_1f25802325f9: TSL_Decor {
        model = "\bsqdn_facewear\gasmask.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_9a41cee21295: TSL_Decor {
        model = "\bsqdn_facewear\gascan_oh_peltor.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_835eb9288bc5: TSL_Decor {
        model = "\bsqdn_facewear\gascan_peltor.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_9ff915460ecc: TSL_Decor {
        model = "\me_br\afghan_1_1.p3d";
        hiddenSelections[] = {"camo2"};
    };
    class TSL_ItemDisplay_fd7973b3cd6d: TSL_Decor {
        model = "\me_br\afghan_1_2.p3d";
        hiddenSelections[] = {"camo2"};
    };
    class TSL_ItemDisplay_84d98f997b35: TSL_Decor {
        model = "\me_br\afghan_1_3.p3d";
        hiddenSelections[] = {"camo2"};
    };
    class TSL_ItemDisplay_78d7b3183ce7: TSL_Decor {
        model = "\me_br\afghan_1_4.p3d";
        hiddenSelections[] = {"camo2"};
    };
    class TSL_ItemDisplay_81e64f99a12a: TSL_Decor {
        model = "\me_br\afghan_2_1.p3d";
        hiddenSelections[] = {"camo2"};
    };
    class TSL_ItemDisplay_5900cc530c20: TSL_Decor {
        model = "\me_br\afghan_2_2.p3d";
        hiddenSelections[] = {"camo2"};
    };
    class TSL_ItemDisplay_6531ac45c873: TSL_Decor {
        model = "\me_br\afghan_2_3.p3d";
        hiddenSelections[] = {"camo2"};
    };
    class TSL_ItemDisplay_6ae7a3a52751: TSL_Decor {
        model = "\me_br\arab_1_1.p3d";
        hiddenSelections[] = {"camo2"};
    };
    class TSL_ItemDisplay_de87445b13ba: TSL_Decor {
        model = "\me_br\arab_1_2.p3d";
        hiddenSelections[] = {"camo2"};
    };
    class TSL_ItemDisplay_f4fd4f0d71b6: TSL_Decor {
        model = "\me_br\arab_1_3.p3d";
        hiddenSelections[] = {"camo2"};
    };
    class TSL_ItemDisplay_4f65e9cd7464: TSL_Decor {
        model = "\me_br\arab_1_4.p3d";
        hiddenSelections[] = {"camo2"};
    };
    class TSL_ItemDisplay_9282eeaa679a: TSL_Decor {
        model = "\me_br\arab_2_1.p3d";
        hiddenSelections[] = {"camo2"};
    };
    class TSL_ItemDisplay_ec2ece59081f: TSL_Decor {
        model = "\me_br\arab_2_2.p3d";
        hiddenSelections[] = {"camo2"};
    };
    class TSL_ItemDisplay_de61f93767ad: TSL_Decor {
        model = "\me_br\arab_2_3.p3d";
        hiddenSelections[] = {"camo2"};
    };
    class TSL_ItemDisplay_6159a36c78f1: TSL_Decor {
        model = "\me_br\arab_2_4.p3d";
        hiddenSelections[] = {"camo2"};
    };
    class TSL_ItemDisplay_9cf2663ce61d: TSL_Decor {
        model = "\me_br\arab_2_5.p3d";
        hiddenSelections[] = {"camo2"};
    };
    class TSL_ItemDisplay_99d7dcb97066: TSL_Decor {
        model = "\me_br\arab_3_1.p3d";
        hiddenSelections[] = {"camo2"};
    };
    class TSL_ItemDisplay_5d2b3ed0292b: TSL_Decor {
        model = "\me_br\arab_3_2.p3d";
        hiddenSelections[] = {"camo2"};
    };
    class TSL_ItemDisplay_1904dff9f270: TSL_Decor {
        model = "\me_br\arab_3_3.p3d";
        hiddenSelections[] = {"camo2"};
    };
    class TSL_ItemDisplay_5dedcac5f62c: TSL_Decor {
        model = "\me_br\arab_3_3.p3d";
        hiddenSelections[] = {"camo2", "camo"};
    };
    class TSL_ItemDisplay_b9cdb3bf6beb: TSL_Decor {
        model = "\me_br\arab_3_5.p3d";
        hiddenSelections[] = {"camo2", "camo"};
    };
    class TSL_ItemDisplay_1872d213accc: TSL_Decor {
        model = "\me_br\arab_3_2.p3d";
        hiddenSelections[] = {"camo2", "camo"};
    };
    class TSL_ItemDisplay_2e44346ef929: TSL_Decor {
        model = "\me_br\arab_3_4.p3d";
        hiddenSelections[] = {"camo2"};
    };
    class TSL_ItemDisplay_2c753ed32d66: TSL_Decor {
        model = "\me_br\arab_3_5.p3d";
        hiddenSelections[] = {"camo2"};
    };
    class TSL_ItemDisplay_cdfff05587ed: TSL_Decor {
        model = "\me_br\arab_3_6.p3d";
        hiddenSelections[] = {"camo2"};
    };
    class TSL_ItemDisplay_f896fa7656b5: TSL_Decor {
        model = "\me_br\arab_3_7.p3d";
        hiddenSelections[] = {"camo2"};
    };
    class TSL_ItemDisplay_9b95dda0f2c0: TSL_Decor {
        model = "\me_br\arab_4_1.p3d";
        hiddenSelections[] = {"camo2"};
    };
    class TSL_ItemDisplay_4e6b8819b517: TSL_Decor {
        model = "\me_br\arab_4_2.p3d";
        hiddenSelections[] = {"camo2"};
    };
    class TSL_ItemDisplay_12d389ce2b2a: TSL_Decor {
        model = "\me_br_2\arab_beard_1.p3d";
        hiddenSelections[] = {""};
    };
    class TSL_ItemDisplay_12c56147dd80: TSL_Decor {
        model = "\me_br_2\arab_beard_1nm.p3d";
        hiddenSelections[] = {""};
    };
    class TSL_ItemDisplay_c6189366ae70: TSL_Decor {
        model = "\me_br_2\arab_beard_2.p3d";
        hiddenSelections[] = {""};
    };
    class TSL_ItemDisplay_b1193d2e16cc: TSL_Decor {
        model = "\me_br_2\arab_beard_3.p3d";
        hiddenSelections[] = {""};
    };
    class TSL_ItemDisplay_1650168173d6: TSL_Decor {
        model = "\me_br_2\arab_beard_3nm.p3d";
        hiddenSelections[] = {""};
    };
    class TSL_ItemDisplay_bf0bae7ee640: TSL_Decor {
        model = "\devgru\rs_equip_parachutes\models\solr.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_371f404300af: TSL_Decor {
        model = "\devgru\rs_equip_parachutes\models\solr_notank.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_fb899438fdcd: TSL_Decor {
        model = "\devgru\tacdev\rs_identity_cutrer\models\hair_helmet.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_e9b3a927c1ba: TSL_Decor {
        model = "\devgru\tacdev\rs_identity_cutrer\models\hair_helmetfitted.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_e184b6565cfb: TSL_Decor {
        model = "\rwglass\rwglass1.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_e641a1f6155b: TSL_Decor {
        model = "\rwglass\rwglass2.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_1198c6e5ae04: TSL_Decor {
        model = "\rwglass\rwglass3.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_e2265107bf9b: TSL_Decor {
        model = "\rwglass\rwglass4.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_587cf272dd7f: TSL_Decor {
        model = "\rwglass\rwglass5.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_684c002a0384: TSL_Decor {
        model = "\rwglass\rwglass6.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_5d3f068e932c: TSL_Decor {
        model = "\rwglass\rwglass7.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_f356ec442ecc: TSL_Decor {
        model = "\a3\characters_f_exp\blufor\g_balaclava_ti_f.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_7110b4934757: TSL_Decor {
        model = "\a3\characters_f_exp\blufor\g_balaclava_ti_g_f.p3d";
        hiddenSelections[] = {"camo1", "camo2"};
    };
    class TSL_ItemDisplay_0895efaf4ee4: TSL_Decor {
        model = "\a3\characters_f_beta\heads\glasses\g_combat.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_bdf36e0196f7: TSL_Decor {
        model = "\a3\characters_f_beta\heads\glasses\g_spectacles.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_e0f4197681db: TSL_Decor {
        model = "\a3\characters_f_beta\heads\glasses\g_spectacles_tinted.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_0840a0c8600c: TSL_Decor {
        model = "\a3\characters_f_beta\heads\glasses\g_lowprofile.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_3e4145cf3072: TSL_Decor {
        model = "\a3\characters_f\heads\glasses\g_shades_black.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_fc55dccaf76b: TSL_Decor {
        model = "\a3\characters_f_beta\heads\glasses\g_shades_green.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_d0ffe6d25736: TSL_Decor {
        model = "\a3\characters_f_beta\heads\glasses\g_shades_red.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_19adaf935008: TSL_Decor {
        model = "\a3\characters_f_beta\heads\glasses\g_squares.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_1150642de8b3: TSL_Decor {
        model = "\a3\characters_f_beta\heads\glasses\g_squares_tinted.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_19be87749844: TSL_Decor {
        model = "\a3\characters_f_beta\heads\glasses\g_sport_blackwhite.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_1b85a0118943: TSL_Decor {
        model = "\a3\characters_f_beta\heads\glasses\g_sport_blackyellow.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_eef0a503c7e2: TSL_Decor {
        model = "\a3\characters_f_beta\heads\glasses\g_sport_greenblack.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_860907eabde4: TSL_Decor {
        model = "\a3\characters_f_beta\heads\glasses\g_sport_checkered.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_d2637d405acf: TSL_Decor {
        model = "\a3\characters_f_beta\heads\glasses\g_sport_red.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_5bbcbc1ac079: TSL_Decor {
        model = "\a3\characters_f_beta\heads\glasses\g_tactical_black.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_e4f7dd6f7266: TSL_Decor {
        model = "\a3\characters_f_gamma\heads\glasses\g_aviators.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_49c1142644a8: TSL_Decor {
        model = "\a3\characters_f_gamma\heads\glasses\g_lady_mirror.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_89fd357421a0: TSL_Decor {
        model = "\a3\characters_f_gamma\heads\glasses\g_lady_dark.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_b59b7f33ac53: TSL_Decor {
        model = "\a3\characters_f_gamma\heads\glasses\g_lady_red.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_3c4a20b8aaab: TSL_Decor {
        model = "\a3\characters_f_gamma\heads\glasses\g_lady_blue.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_ce04b86cf54d: TSL_Decor {
        model = "\a3\characters_f_epb\heads\glasses\g_b_diving.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_7518cc233411: TSL_Decor {
        model = "\a3\characters_f_epb\heads\glasses\g_o_diving.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_d5b3def933a0: TSL_Decor {
        model = "\a3\characters_f_epb\heads\glasses\g_i_diving.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_8a851e4fae0c: TSL_Decor {
        model = "\a3\characters_f_bootcamp\common\g_vr.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_42f621313ca5: TSL_Decor {
        model = "\a3\characters_f_bootcamp\guerrilla\g_balaclava_clean.p3d";
        hiddenSelections[] = {"camo"};
    };
    class TSL_ItemDisplay_e810e1e7dc32: TSL_Decor {
        model = "\a3\characters_f_bootcamp\guerrilla\g_balaclava_clean.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_d2750899992b: TSL_Decor {
        model = "\a3\characters_f_bootcamp\guerrilla\g_balaclava_combat.p3d";
        hiddenSelections[] = {"camo1", "camo2"};
    };
    class TSL_ItemDisplay_2e5d18e7ef68: TSL_Decor {
        model = "\a3\characters_f_bootcamp\guerrilla\g_balaclava_lowprofile.p3d";
        hiddenSelections[] = {"camo1", "camo2"};
    };
    class TSL_ItemDisplay_392530948045: TSL_Decor {
        model = "\a3\characters_f_bootcamp\guerrilla\g_bandana_clean.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_33eeb33a6a43: TSL_Decor {
        model = "\a3\characters_f_bootcamp\guerrilla\g_bandana_shades.p3d";
        hiddenSelections[] = {"camo1", "camo2"};
    };
    class TSL_ItemDisplay_a2c81b7ea609: TSL_Decor {
        model = "\a3\characters_f_bootcamp\guerrilla\g_bandana_sport.p3d";
        hiddenSelections[] = {};
    };
    class TSL_ItemDisplay_5d8853408d0c: TSL_Decor {
        model = "\a3\characters_f_bootcamp\guerrilla\g_bandana_aviator.p3d";
        hiddenSelections[] = {};
    };
    class TSL_Backpack3_Pos0: TSL_Decor {
        model = "\TS_Lockers\TSL_Backpack3_Pos0.p3d";
    };
    class TSL_Backpack3_Pos1: TSL_Decor {
        model = "\TS_Lockers\TSL_Backpack3_Pos1.p3d";
    };
    class TSL_Backpack3_Pos2: TSL_Decor {
        model = "\TS_Lockers\TSL_Backpack3_Pos2.p3d";
    };
    class TSL_Backpack4_Pos0: TSL_Decor {
        model = "\TS_Lockers\TSL_Backpack4_Pos0.p3d";
    };
    class TSL_Backpack4_Pos1: TSL_Decor {
        model = "\TS_Lockers\TSL_Backpack4_Pos1.p3d";
    };
    class TSL_Backpack4_Pos2: TSL_Decor {
        model = "\TS_Lockers\TSL_Backpack4_Pos2.p3d";
    };
    class TSL_patch_01: TSL_Decor {
        model = "\TS_Lockers\TSL_patch_01.p3d";
    };
    class TSL_patch_02: TSL_Decor {
        model = "\TS_Lockers\TSL_patch_02.p3d";
    };
    class TSL_patch_03: TSL_Decor {
        model = "\TS_Lockers\TSL_patch_03.p3d";
    };
    class TSL_patch_04: TSL_Decor {
        model = "\TS_Lockers\TSL_patch_04.p3d";
    };
    class TSL_patch_05: TSL_Decor {
        model = "\TS_Lockers\TSL_patch_05.p3d";
    };
    class TSL_patch_06: TSL_Decor {
        model = "\TS_Lockers\TSL_patch_06.p3d";
    };
    class TSL_patch_07: TSL_Decor {
        model = "\TS_Lockers\TSL_patch_07.p3d";
    };
    class TSL_patch_08: TSL_Decor {
        model = "\TS_Lockers\TSL_patch_08.p3d";
    };
    class TSL_patch_09: TSL_Decor {
        model = "\TS_Lockers\TSL_patch_09.p3d";
    };
    class TSL_patch_10: TSL_Decor {
        model = "\TS_Lockers\TSL_patch_10.p3d";
    };
    class TSL_patch_11: TSL_Decor {
        model = "\TS_Lockers\TSL_patch_11.p3d";
    };
    class TSL_patch_12: TSL_Decor {
        model = "\TS_Lockers\TSL_patch_12.p3d";
    };
    class TSL_photo_01: TSL_Decor {
        model = "\TS_Lockers\TSL_photo_01.p3d";
    };
    class TSL_photo_02: TSL_Decor {
        model = "\TS_Lockers\TSL_photo_02.p3d";
    };
    class TSL_photo_03: TSL_Decor {
        model = "\TS_Lockers\TSL_photo_03.p3d";
    };
    class TSL_photo_04: TSL_Decor {
        model = "\TS_Lockers\TSL_photo_04.p3d";
    };
    class TSL_photo_05: TSL_Decor {
        model = "\TS_Lockers\TSL_photo_05.p3d";
    };
    class TSL_photo_06: TSL_Decor {
        model = "\TS_Lockers\TSL_photo_06.p3d";
    };
    class TSL_photo_07: TSL_Decor {
        model = "\TS_Lockers\TSL_photo_07.p3d";
    };
    class TSL_photo_08: TSL_Decor {
        model = "\TS_Lockers\TSL_photo_08.p3d";
    };
    class TSL_photo_09: TSL_Decor {
        model = "\TS_Lockers\TSL_photo_09.p3d";
    };
    class TSL_photo_10: TSL_Decor {
        model = "\TS_Lockers\TSL_photo_10.p3d";
    };
    class TSL_photo_11: TSL_Decor {
        model = "\TS_Lockers\TSL_photo_11.p3d";
    };
    class TSL_photo_12: TSL_Decor {
        model = "\TS_Lockers\TSL_photo_12.p3d";
    };
    class TSL_photo_13: TSL_Decor {
        model = "\TS_Lockers\TSL_photo_13.p3d";
    };
    class TSL_photo_14: TSL_Decor {
        model = "\TS_Lockers\TSL_photo_14.p3d";
    };
    class TSL_RifleClamp: TSL_Decor {
        model = "\TS_Lockers\TSL_RifleClamp.p3d";
    };
    class TSL_VelcroPanel: TSL_Decor {
        model = "\TS_Lockers\TSL_VelcroPanel.p3d";
    };
    class TSL_VelcroSidePanel: TSL_Decor {
        model = "\TS_Lockers\TSL_VelcroSidePanel.p3d";
    };
};
class TSL_Text {
    x = 0;
    y = 0;
    w = 0.1;
    h = 0.1;
    type = 0;
    idc = -1;
    style = 0;
    font = "RobotoCondensed";
    sizeEx = 0.035;
    shadow = 0;
    colorText[] = {0.92, 0.9, 0.84, 1};
    colorBackground[] = {0, 0, 0, 0};
    text = "";
};
class TSL_Button {
    x = 0;
    y = 0;
    w = 0.1;
    h = 0.1;
    type = 1;
    idc = -1;
    style = 2;
    font = "RobotoCondensed";
    sizeEx = 0.035;
    shadow = 0;
    colorText[] = {1, 1, 1, 1};
    colorDisabled[] = {0.5, 0.5, 0.5, 1};
    colorBackground[] = {0, 0, 0, 0};
    colorBackgroundDisabled[] = {0, 0, 0, 0};
    colorBackgroundActive[] = {
        "(((profileNamespace getVariable ['TSL_menuTheme',[[.025,.028,.03,1],[.12,.13,.14,1],[.76,.80,.82,1],[.97,.97,.97,1]]]) select 2) select 0) * 0.3",
        "(((profileNamespace getVariable ['TSL_menuTheme',[[.025,.028,.03,1],[.12,.13,.14,1],[.76,.80,.82,1],[.97,.97,.97,1]]]) select 2) select 1) * 0.3",
        "(((profileNamespace getVariable ['TSL_menuTheme',[[.025,.028,.03,1],[.12,.13,.14,1],[.76,.80,.82,1],[.97,.97,.97,1]]]) select 2) select 2) * 0.3",
        "((profileNamespace getVariable ['TSL_menuTheme',[[.025,.028,.03,1],[.12,.13,.14,1],[.76,.80,.82,1],[.97,.97,.97,1]]]) select 1) select 3"
    };
    colorFocused[] = {
        "(((profileNamespace getVariable ['TSL_menuTheme',[[.025,.028,.03,1],[.12,.13,.14,1],[.76,.80,.82,1],[.97,.97,.97,1]]]) select 2) select 0) * 0.3",
        "(((profileNamespace getVariable ['TSL_menuTheme',[[.025,.028,.03,1],[.12,.13,.14,1],[.76,.80,.82,1],[.97,.97,.97,1]]]) select 2) select 1) * 0.3",
        "(((profileNamespace getVariable ['TSL_menuTheme',[[.025,.028,.03,1],[.12,.13,.14,1],[.76,.80,.82,1],[.97,.97,.97,1]]]) select 2) select 2) * 0.3",
        "((profileNamespace getVariable ['TSL_menuTheme',[[.025,.028,.03,1],[.12,.13,.14,1],[.76,.80,.82,1],[.97,.97,.97,1]]]) select 1) select 3"
    };
    colorShadow[] = {0, 0, 0, 0};
    colorBorder[] = {0, 0, 0, 0};
    borderSize = 0;
    offsetX = 0;
    offsetY = 0;
    offsetPressedX = 0;
    offsetPressedY = 0;
    soundEnter[] = {"", 0, 1};
    soundPush[] = {"", 0, 1};
    soundClick[] = {"", 0, 1};
    soundEscape[] = {"", 0, 1};
    text = "";
};
class TSL_List {
    x = 0;
    y = 0;
    w = 0.1;
    h = 0.1;
    type = 5;
    idc = 78151;
    style = 0;
    font = "RobotoCondensed";
    sizeEx = 0.033;
    shadow = 0;
    rowHeight = 0.042;
    colorText[] = {0.92, 0.92, 0.88, 1};
    colorDisabled[] = {0.4, 0.4, 0.4, 1};
    colorBackground[] = {0.1, 0.11, 0.1, 1};
    colorSelect[] = {1, 1, 1, 1};
    colorSelect2[] = {1, 1, 1, 1};
    colorSelectBackground[] = {
        "(((profileNamespace getVariable ['TSL_menuTheme',[[.025,.028,.03,1],[.12,.13,.14,1],[.76,.80,.82,1],[.97,.97,.97,1]]]) select 2) select 0) * 0.3",
        "(((profileNamespace getVariable ['TSL_menuTheme',[[.025,.028,.03,1],[.12,.13,.14,1],[.76,.80,.82,1],[.97,.97,.97,1]]]) select 2) select 1) * 0.3",
        "(((profileNamespace getVariable ['TSL_menuTheme',[[.025,.028,.03,1],[.12,.13,.14,1],[.76,.80,.82,1],[.97,.97,.97,1]]]) select 2) select 2) * 0.3",
        "((profileNamespace getVariable ['TSL_menuTheme',[[.025,.028,.03,1],[.12,.13,.14,1],[.76,.80,.82,1],[.97,.97,.97,1]]]) select 0) select 3"
    };
    colorSelectBackground2[] = {
        "(((profileNamespace getVariable ['TSL_menuTheme',[[.025,.028,.03,1],[.12,.13,.14,1],[.76,.80,.82,1],[.97,.97,.97,1]]]) select 2) select 0) * 0.3",
        "(((profileNamespace getVariable ['TSL_menuTheme',[[.025,.028,.03,1],[.12,.13,.14,1],[.76,.80,.82,1],[.97,.97,.97,1]]]) select 2) select 1) * 0.3",
        "(((profileNamespace getVariable ['TSL_menuTheme',[[.025,.028,.03,1],[.12,.13,.14,1],[.76,.80,.82,1],[.97,.97,.97,1]]]) select 2) select 2) * 0.3",
        "((profileNamespace getVariable ['TSL_menuTheme',[[.025,.028,.03,1],[.12,.13,.14,1],[.76,.80,.82,1],[.97,.97,.97,1]]]) select 0) select 3"
    };
    colorPicture[] = {1, 1, 1, 1};
    colorPictureSelected[] = {1, 1, 1, 1};
    colorPictureDisabled[] = {0.5, 0.5, 0.5, 1};
    colorScrollbar[] = {0.7, 0.7, 0.7, 1};
    period = 0;
    maxHistoryDelay = 1;
    autoScrollSpeed = -1;
    autoScrollDelay = 5;
    autoScrollRewind = 0;
    soundSelect[] = {"", 0, 1};
    onLBDblClick = "[] call TSL_fnc_uiExecute";
    class ListScrollBar {
        color[] = {1, 1, 1, 1};
        colorActive[] = {1, 1, 1, 1};
        colorDisabled[] = {1, 1, 1, 0.3};
        thumb = "\a3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
        arrowEmpty = "\a3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
        arrowFull = "\a3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
        border = "\a3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
        shadow = 0;
        scrollSpeed = 0.06;
    };
};
class TSL_PresetEdit: TSL_Text {
    type = 2;
    style = 0;
    colorDisabled[] = {0.5, 0.5, 0.5, 1};
    autocomplete = "";
    colorSelection[] = {0.4, 0.4, 0.3, 1};
    canModify = 1;
};
class TSL_EditorList: TSL_List {
    onLBDblClick = "";
    idc = -1;
};
class TSL_Wrapped: TSL_Text {
    style = 16;
    lineSpacing = 1;
};
class TSL_EditorAxisLine: TSL_Text {
    style = 48;
    shadow = 0;
    colorText[] = {1, 1, 1, 1};
    colorDisabled[] = {1, 1, 1, 1};
};
class TSL_EditorAxisLabel: TSL_Text {
    style = 2;
    shadow = 2;
    colorDisabled[] = {1, 1, 1, 1};
};
class TSL_CameraViewport: TSL_Text {
    text = "";
    colorBackground[] = {0, 0, 0, 0};
    colorBackgroundActive[] = {0, 0, 0, 0};
    colorBackgroundDisabled[] = {0, 0, 0, 0};
    colorFocused[] = {0, 0, 0, 0};
    colorBorder[] = {0, 0, 0, 0};
    colorShadow[] = {0, 0, 0, 0};
    borderSize = 0;
    shadow = 0;
    soundEnter[] = {"", 0, 1};
    soundPush[] = {"", 0, 1};
    soundClick[] = {"", 0, 1};
    soundEscape[] = {"", 0, 1};
};
class TSL_LockerDialog {
    idd = 78150;
    movingEnable = 0;
    enableSimulation = 1;
    onKeyDown = "if ((_this select 1)==33) then {['keyDown',_this] call TSL_fnc_cameraInput} else {false}";
    onKeyUp = "if ((_this select 1)==33) then {['keyUp',_this] call TSL_fnc_cameraInput} else {false}";
    onUnload = "[] call TSL_fnc_cameraStop";
    class controlsBackground {
        class Backdrop: TSL_Text {
            idc = 78152;
            x = "safeZoneX+safeZoneW*.70";
            y = "safeZoneY+safeZoneH*.08";
            w = "safeZoneW*.29";
            h = "safeZoneH*.84";
            colorBackground[] = {0.035, 0.045, 0.04, 0.94};
        };
    };
    class controls {
        class Title: TSL_Text {
            idc = 78153;
            x = "safeZoneX+safeZoneW*.71";
            y = "safeZoneY+safeZoneH*.09";
            w = "safeZoneW*.27";
            h = "safeZoneH*.045";
            text = "Locker";
            sizeEx = 0.035;
        };
        class Status: TSL_Text {
            idc = 78154;
            x = "safeZoneX+safeZoneW*.71";
            y = "safeZoneY+safeZoneH*.195";
            w = "safeZoneW*.27";
            h = "safeZoneH*.045";
            sizeEx = 0.025;
        };
        class Entries: TSL_List {
            x = "safeZoneX+safeZoneW*.71";
            y = "safeZoneY+safeZoneH*.25";
            w = "safeZoneW*.27";
            h = "safeZoneH*.43";
        };
        class Execute: TSL_Button {
            idc = 78158;
            x = "safeZoneX+safeZoneW*.71";
            y = "safeZoneY+safeZoneH*.70";
            w = "safeZoneW*.085";
            h = "safeZoneH*.04";
            text = "Select";
            onButtonClick = "[] call TSL_fnc_uiExecute";
        };
        class Previous: TSL_Button {
            idc = 78159;
            x = "safeZoneX+safeZoneW*.802";
            y = "safeZoneY+safeZoneH*.70";
            w = "safeZoneW*.085";
            h = "safeZoneH*.04";
            text = "Back";
            onButtonClick = "[] call TSL_fnc_uiBack";
        };
        class Close: TSL_Button {
            idc = 78160;
            x = "safeZoneX+safeZoneW*.895";
            y = "safeZoneY+safeZoneH*.70";
            w = "safeZoneW*.085";
            h = "safeZoneH*.04";
            text = "Close";
            onButtonClick = "closeDialog 0";
        };
        class Editor: TSL_Button {
            idc = 78157;
            x = "safeZoneX+safeZoneW*.71";
            y = "safeZoneY+safeZoneH*.145";
            w = "safeZoneW*.27";
            h = "safeZoneH*.045";
            text = "Edit layout";
            onButtonClick = "['toggle'] call TSL_fnc_editorUI";
        };
        class Reset: TSL_Button {
            idc = 78156;
            x = "safeZoneX+safeZoneW*.71";
            y = "safeZoneY+safeZoneH*.76";
            w = "safeZoneW*.27";
            h = "safeZoneH*.04";
            text = "Reset camera";
            onButtonClick = "['reset',[]] call TSL_fnc_cameraInput";
        };
        class Help: TSL_Text {
            idc = 78155;
            style = 16;
            lineSpacing = 1;
            x = "safeZoneX+safeZoneW*.71";
            y = "safeZoneY+safeZoneH*.81";
            w = "safeZoneW*.27";
            h = "safeZoneH*.10";
            sizeEx = 0.025;
            text = "WASD: move | Q/E: up/down\nRMB: look | Wheel: zoom\nShift: fast | Ctrl: precise";
        };
    };
};
