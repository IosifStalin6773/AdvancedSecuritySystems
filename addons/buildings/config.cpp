class CfgPatches {
    class ADVSEC_Buildings {
        name = "ADVSEC - Edificios";
        author = "oscar";
        requiredVersion = 2.14;
        requiredAddons[] = {"A3_Structures_F"};
        units[] = {"ADVSEC_PM_Edificio"};
        weapons[] = {};
    };
};

class CfgVehicles {
    class House_F;
    class ADVSEC_PM_Edificio: House_F {
        scope = 2;
        scopeCurator = 2;
        author = "oscar";
        displayName = "Comisaría de Policía Militar";
        model = "\advsec_buildings\pm_edificio.p3d";
        editorCategory = "EdCat_Structures";
        editorSubcategory = "EdSubcat_Military";
        vehicleClass = "Structures";
        destrType = "DestructNo";
        armor = 5000;
        numberOfDoors = 9;
        class HitPoints {
            class Glass_1_hitpoint {
                armor = 0.001;
                material = -1;
                name = "glass_1";
                visual = "glass_1_hide";
                passThrough = 0;
                radius = 0.4;
                convexComponent = "glass_1_hide";
                explosionShielding = 3;
                minimalHit = 0.0001;
                class DestructionEffects {
                    class BrokenGlass1 { simulation = "particles"; type = "BrokenGlass1NN"; position = "glass_1_effects"; intensity = 0.15; interval = 1; lifeTime = 0.05; };
                    class BrokenGlass2: BrokenGlass1 { type = "BrokenGlass2NN"; };
                    class BrokenGlass3: BrokenGlass1 { type = "BrokenGlass3NN"; };
                };
            };
            class Glass_2_hitpoint {
                armor = 0.001;
                material = -1;
                name = "glass_2";
                visual = "glass_2_hide";
                passThrough = 0;
                radius = 0.4;
                convexComponent = "glass_2_hide";
                explosionShielding = 3;
                minimalHit = 0.0001;
                class DestructionEffects {
                    class BrokenGlass1 { simulation = "particles"; type = "BrokenGlass1NN"; position = "glass_2_effects"; intensity = 0.15; interval = 1; lifeTime = 0.05; };
                    class BrokenGlass2: BrokenGlass1 { type = "BrokenGlass2NN"; };
                    class BrokenGlass3: BrokenGlass1 { type = "BrokenGlass3NN"; };
                };
            };
            class Glass_3_hitpoint {
                armor = 0.001;
                material = -1;
                name = "glass_3";
                visual = "glass_3_hide";
                passThrough = 0;
                radius = 0.4;
                convexComponent = "glass_3_hide";
                explosionShielding = 3;
                minimalHit = 0.0001;
                class DestructionEffects {
                    class BrokenGlass1 { simulation = "particles"; type = "BrokenGlass1NN"; position = "glass_3_effects"; intensity = 0.15; interval = 1; lifeTime = 0.05; };
                    class BrokenGlass2: BrokenGlass1 { type = "BrokenGlass2NN"; };
                    class BrokenGlass3: BrokenGlass1 { type = "BrokenGlass3NN"; };
                };
            };
            class Glass_4_hitpoint {
                armor = 0.001;
                material = -1;
                name = "glass_4";
                visual = "glass_4_hide";
                passThrough = 0;
                radius = 0.4;
                convexComponent = "glass_4_hide";
                explosionShielding = 3;
                minimalHit = 0.0001;
                class DestructionEffects {
                    class BrokenGlass1 { simulation = "particles"; type = "BrokenGlass1NN"; position = "glass_4_effects"; intensity = 0.15; interval = 1; lifeTime = 0.05; };
                    class BrokenGlass2: BrokenGlass1 { type = "BrokenGlass2NN"; };
                    class BrokenGlass3: BrokenGlass1 { type = "BrokenGlass3NN"; };
                };
            };
            class Glass_5_hitpoint {
                armor = 0.001;
                material = -1;
                name = "glass_5";
                visual = "glass_5_hide";
                passThrough = 0;
                radius = 0.4;
                convexComponent = "glass_5_hide";
                explosionShielding = 3;
                minimalHit = 0.0001;
                class DestructionEffects {
                    class BrokenGlass1 { simulation = "particles"; type = "BrokenGlass1NN"; position = "glass_5_effects"; intensity = 0.15; interval = 1; lifeTime = 0.05; };
                    class BrokenGlass2: BrokenGlass1 { type = "BrokenGlass2NN"; };
                    class BrokenGlass3: BrokenGlass1 { type = "BrokenGlass3NN"; };
                };
            };
            class Glass_6_hitpoint {
                armor = 0.001;
                material = -1;
                name = "glass_6";
                visual = "glass_6_hide";
                passThrough = 0;
                radius = 0.4;
                convexComponent = "glass_6_hide";
                explosionShielding = 3;
                minimalHit = 0.0001;
                class DestructionEffects {
                    class BrokenGlass1 { simulation = "particles"; type = "BrokenGlass1NN"; position = "glass_6_effects"; intensity = 0.15; interval = 1; lifeTime = 0.05; };
                    class BrokenGlass2: BrokenGlass1 { type = "BrokenGlass2NN"; };
                    class BrokenGlass3: BrokenGlass1 { type = "BrokenGlass3NN"; };
                };
            };
            class Glass_7_hitpoint {
                armor = 0.001;
                material = -1;
                name = "glass_7";
                visual = "glass_7_hide";
                passThrough = 0;
                radius = 0.4;
                convexComponent = "glass_7_hide";
                explosionShielding = 3;
                minimalHit = 0.0001;
                class DestructionEffects {
                    class BrokenGlass1 { simulation = "particles"; type = "BrokenGlass1NN"; position = "glass_7_effects"; intensity = 0.15; interval = 1; lifeTime = 0.05; };
                    class BrokenGlass2: BrokenGlass1 { type = "BrokenGlass2NN"; };
                    class BrokenGlass3: BrokenGlass1 { type = "BrokenGlass3NN"; };
                };
            };
            class Glass_8_hitpoint {
                armor = 0.001;
                material = -1;
                name = "glass_8";
                visual = "glass_8_hide";
                passThrough = 0;
                radius = 0.4;
                convexComponent = "glass_8_hide";
                explosionShielding = 3;
                minimalHit = 0.0001;
                class DestructionEffects {
                    class BrokenGlass1 { simulation = "particles"; type = "BrokenGlass1NN"; position = "glass_8_effects"; intensity = 0.15; interval = 1; lifeTime = 0.05; };
                    class BrokenGlass2: BrokenGlass1 { type = "BrokenGlass2NN"; };
                    class BrokenGlass3: BrokenGlass1 { type = "BrokenGlass3NN"; };
                };
            };
            class Glass_9_hitpoint {
                armor = 0.001;
                material = -1;
                name = "glass_9";
                visual = "glass_9_hide";
                passThrough = 0;
                radius = 0.4;
                convexComponent = "glass_9_hide";
                explosionShielding = 3;
                minimalHit = 0.0001;
                class DestructionEffects {
                    class BrokenGlass1 { simulation = "particles"; type = "BrokenGlass1NN"; position = "glass_9_effects"; intensity = 0.15; interval = 1; lifeTime = 0.05; };
                    class BrokenGlass2: BrokenGlass1 { type = "BrokenGlass2NN"; };
                    class BrokenGlass3: BrokenGlass1 { type = "BrokenGlass3NN"; };
                };
            };
            class Glass_10_hitpoint {
                armor = 0.001;
                material = -1;
                name = "glass_10";
                visual = "glass_10_hide";
                passThrough = 0;
                radius = 0.4;
                convexComponent = "glass_10_hide";
                explosionShielding = 3;
                minimalHit = 0.0001;
                class DestructionEffects {
                    class BrokenGlass1 { simulation = "particles"; type = "BrokenGlass1NN"; position = "glass_10_effects"; intensity = 0.15; interval = 1; lifeTime = 0.05; };
                    class BrokenGlass2: BrokenGlass1 { type = "BrokenGlass2NN"; };
                    class BrokenGlass3: BrokenGlass1 { type = "BrokenGlass3NN"; };
                };
            };
            class Glass_11_hitpoint {
                armor = 0.001;
                material = -1;
                name = "glass_11";
                visual = "glass_11_hide";
                passThrough = 0;
                radius = 0.4;
                convexComponent = "glass_11_hide";
                explosionShielding = 3;
                minimalHit = 0.0001;
                class DestructionEffects {
                    class BrokenGlass1 { simulation = "particles"; type = "BrokenGlass1NN"; position = "glass_11_effects"; intensity = 0.15; interval = 1; lifeTime = 0.05; };
                    class BrokenGlass2: BrokenGlass1 { type = "BrokenGlass2NN"; };
                    class BrokenGlass3: BrokenGlass1 { type = "BrokenGlass3NN"; };
                };
            };
        };
        class AnimationSources {
            class Door_1_source { source = "user"; animPeriod = 1; initPhase = 0; sound = "GenericDoorsSound"; };
            class Door_2_source { source = "user"; animPeriod = 1; initPhase = 0; sound = "GenericDoorsSound"; };
            class Door_3_source { source = "user"; animPeriod = 1; initPhase = 0; sound = "GenericDoorsSound"; };
            class Door_4_source { source = "user"; animPeriod = 1; initPhase = 0; sound = "GenericDoorsSound"; };
            class Door_5_source { source = "user"; animPeriod = 1; initPhase = 0; sound = "GenericDoorsSound"; };
            class Door_6_source { source = "user"; animPeriod = 1; initPhase = 0; sound = "GenericDoorsSound"; };
            class Door_7_source { source = "user"; animPeriod = 1; initPhase = 0; sound = "GenericDoorsSound"; };
            class Door_8_source { source = "user"; animPeriod = 1; initPhase = 0; sound = "GenericDoorsSound"; };
            class Door_9_source { source = "user"; animPeriod = 1; initPhase = 0; sound = "GenericDoorsSound"; };
            class Glass_1_source { source = "Hit"; hitpoint = "Glass_1_hitpoint"; raw = 1; };
            class Glass_2_source { source = "Hit"; hitpoint = "Glass_2_hitpoint"; raw = 1; };
            class Glass_3_source { source = "Hit"; hitpoint = "Glass_3_hitpoint"; raw = 1; };
            class Glass_4_source { source = "Hit"; hitpoint = "Glass_4_hitpoint"; raw = 1; };
            class Glass_5_source { source = "Hit"; hitpoint = "Glass_5_hitpoint"; raw = 1; };
            class Glass_6_source { source = "Hit"; hitpoint = "Glass_6_hitpoint"; raw = 1; };
            class Glass_7_source { source = "Hit"; hitpoint = "Glass_7_hitpoint"; raw = 1; };
            class Glass_8_source { source = "Hit"; hitpoint = "Glass_8_hitpoint"; raw = 1; };
            class Glass_9_source { source = "Hit"; hitpoint = "Glass_9_hitpoint"; raw = 1; };
            class Glass_10_source { source = "Hit"; hitpoint = "Glass_10_hitpoint"; raw = 1; };
            class Glass_11_source { source = "Hit"; hitpoint = "Glass_11_hitpoint"; raw = 1; };
        };
        class UserActions {
            class OpenDoor_1 {
                displayNameDefault = "<img image='\A3\Ui_f\data\IGUI\Cfg\Actions\open_door_ca.paa' size='2.5' />";
                displayName = "Abrir puerta";
                position = "door_action_1";
                priority = 11;
                radius = 1.75;
                onlyForPlayer = 0;
                condition = "((this animationSourcePhase 'Door_1_source') < 0.5) && {(this getVariable ['bis_disabled_Door_1', 0]) != 1} && {cameraOn isKindOf 'CAManBase'}";
                statement = "this animateSource ['Door_1_source', 1]";
            };
            class CloseDoor_1: OpenDoor_1 {
                displayName = "Cerrar puerta";
                condition = "((this animationSourcePhase 'Door_1_source') >= 0.5) && {cameraOn isKindOf 'CAManBase'}";
                statement = "this animateSource ['Door_1_source', 0]";
            };
            class OpenDoor_2 {
                displayNameDefault = "<img image='\A3\Ui_f\data\IGUI\Cfg\Actions\open_door_ca.paa' size='2.5' />";
                displayName = "Abrir puerta";
                position = "door_action_2";
                priority = 11;
                radius = 1.75;
                onlyForPlayer = 0;
                condition = "((this animationSourcePhase 'Door_2_source') < 0.5) && {(this getVariable ['bis_disabled_Door_2', 0]) != 1} && {cameraOn isKindOf 'CAManBase'}";
                statement = "this animateSource ['Door_2_source', 1]";
            };
            class CloseDoor_2: OpenDoor_2 {
                displayName = "Cerrar puerta";
                condition = "((this animationSourcePhase 'Door_2_source') >= 0.5) && {cameraOn isKindOf 'CAManBase'}";
                statement = "this animateSource ['Door_2_source', 0]";
            };
            class OpenDoor_3 {
                displayNameDefault = "<img image='\A3\Ui_f\data\IGUI\Cfg\Actions\open_door_ca.paa' size='2.5' />";
                displayName = "Abrir puerta";
                position = "door_action_3";
                priority = 11;
                radius = 1.75;
                onlyForPlayer = 0;
                condition = "((this animationSourcePhase 'Door_3_source') < 0.5) && {(this getVariable ['bis_disabled_Door_3', 0]) != 1} && {cameraOn isKindOf 'CAManBase'}";
                statement = "this animateSource ['Door_3_source', 1]";
            };
            class CloseDoor_3: OpenDoor_3 {
                displayName = "Cerrar puerta";
                condition = "((this animationSourcePhase 'Door_3_source') >= 0.5) && {cameraOn isKindOf 'CAManBase'}";
                statement = "this animateSource ['Door_3_source', 0]";
            };
            class OpenDoor_4 {
                displayNameDefault = "<img image='\A3\Ui_f\data\IGUI\Cfg\Actions\open_door_ca.paa' size='2.5' />";
                displayName = "Abrir puerta";
                position = "door_action_4";
                priority = 11;
                radius = 1.75;
                onlyForPlayer = 0;
                condition = "((this animationSourcePhase 'Door_4_source') < 0.5) && {(this getVariable ['bis_disabled_Door_4', 0]) != 1} && {cameraOn isKindOf 'CAManBase'}";
                statement = "this animateSource ['Door_4_source', 1]";
            };
            class CloseDoor_4: OpenDoor_4 {
                displayName = "Cerrar puerta";
                condition = "((this animationSourcePhase 'Door_4_source') >= 0.5) && {cameraOn isKindOf 'CAManBase'}";
                statement = "this animateSource ['Door_4_source', 0]";
            };
            class OpenDoor_5 {
                displayNameDefault = "<img image='\A3\Ui_f\data\IGUI\Cfg\Actions\open_door_ca.paa' size='2.5' />";
                displayName = "Abrir puerta";
                position = "door_action_5";
                priority = 11;
                radius = 1.75;
                onlyForPlayer = 0;
                condition = "((this animationSourcePhase 'Door_5_source') < 0.5) && {(this getVariable ['bis_disabled_Door_5', 0]) != 1} && {cameraOn isKindOf 'CAManBase'}";
                statement = "this animateSource ['Door_5_source', 1]";
            };
            class CloseDoor_5: OpenDoor_5 {
                displayName = "Cerrar puerta";
                condition = "((this animationSourcePhase 'Door_5_source') >= 0.5) && {cameraOn isKindOf 'CAManBase'}";
                statement = "this animateSource ['Door_5_source', 0]";
            };
            class OpenDoor_6 {
                displayNameDefault = "<img image='\A3\Ui_f\data\IGUI\Cfg\Actions\open_door_ca.paa' size='2.5' />";
                displayName = "Abrir puerta";
                position = "door_action_6";
                priority = 11;
                radius = 1.75;
                onlyForPlayer = 0;
                condition = "((this animationSourcePhase 'Door_6_source') < 0.5) && {(this getVariable ['bis_disabled_Door_6', 0]) != 1} && {cameraOn isKindOf 'CAManBase'}";
                statement = "this animateSource ['Door_6_source', 1]";
            };
            class CloseDoor_6: OpenDoor_6 {
                displayName = "Cerrar puerta";
                condition = "((this animationSourcePhase 'Door_6_source') >= 0.5) && {cameraOn isKindOf 'CAManBase'}";
                statement = "this animateSource ['Door_6_source', 0]";
            };
            class OpenDoor_7 {
                displayNameDefault = "<img image='\A3\Ui_f\data\IGUI\Cfg\Actions\open_door_ca.paa' size='2.5' />";
                displayName = "Abrir puerta";
                position = "door_action_7";
                priority = 11;
                radius = 1.75;
                onlyForPlayer = 0;
                condition = "((this animationSourcePhase 'Door_7_source') < 0.5) && {(this getVariable ['bis_disabled_Door_7', 0]) != 1} && {cameraOn isKindOf 'CAManBase'}";
                statement = "this animateSource ['Door_7_source', 1]";
            };
            class CloseDoor_7: OpenDoor_7 {
                displayName = "Cerrar puerta";
                condition = "((this animationSourcePhase 'Door_7_source') >= 0.5) && {cameraOn isKindOf 'CAManBase'}";
                statement = "this animateSource ['Door_7_source', 0]";
            };
            class OpenDoor_8 {
                displayNameDefault = "<img image='\A3\Ui_f\data\IGUI\Cfg\Actions\open_door_ca.paa' size='2.5' />";
                displayName = "Abrir puerta";
                position = "door_action_8";
                priority = 11;
                radius = 1.75;
                onlyForPlayer = 0;
                condition = "((this animationSourcePhase 'Door_8_source') < 0.5) && {(this getVariable ['bis_disabled_Door_8', 0]) != 1} && {cameraOn isKindOf 'CAManBase'}";
                statement = "this animateSource ['Door_8_source', 1]";
            };
            class CloseDoor_8: OpenDoor_8 {
                displayName = "Cerrar puerta";
                condition = "((this animationSourcePhase 'Door_8_source') >= 0.5) && {cameraOn isKindOf 'CAManBase'}";
                statement = "this animateSource ['Door_8_source', 0]";
            };
            class OpenDoor_9 {
                displayNameDefault = "<img image='\A3\Ui_f\data\IGUI\Cfg\Actions\open_door_ca.paa' size='2.5' />";
                displayName = "Abrir puerta";
                position = "door_action_9";
                priority = 11;
                radius = 1.75;
                onlyForPlayer = 0;
                condition = "((this animationSourcePhase 'Door_9_source') < 0.5) && {(this getVariable ['bis_disabled_Door_9', 0]) != 1} && {cameraOn isKindOf 'CAManBase'}";
                statement = "this animateSource ['Door_9_source', 1]";
            };
            class CloseDoor_9: OpenDoor_9 {
                displayName = "Cerrar puerta";
                condition = "((this animationSourcePhase 'Door_9_source') >= 0.5) && {cameraOn isKindOf 'CAManBase'}";
                statement = "this animateSource ['Door_9_source', 0]";
            };
        };
    };
};
