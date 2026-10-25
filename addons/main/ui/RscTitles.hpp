#define ADVSEC_Q(V) #V
#define DOC_X(N) ADVSEC_Q(safeZoneX + safeZoneW / 2 - 0.4 + N)
#define DOC_Y(N) ADVSEC_Q(safeZoneY + safeZoneH / 2 - 0.29 + N)

class RscTitles {
    class ADVSEC_RscDocument {
        idd = 86400;
        duration = 15;
        fadeIn = 0.25;
        fadeOut = 0.4;
        movingEnable = 0;
        onLoad = "uiNamespace setVariable ['ADVSEC_docDisplay', _this select 0]";
        class controls {
            class BGColor: RscText {
                idc = 4005;
                x = DOC_X(0); y = DOC_Y(0); w = 0.8; h = 0.5333;
                colorBackground[] = {0.1, 0.2, 0.45, 0.97};
            };
            class BG: RscPicture {
                idc = 4000;
                x = DOC_X(0); y = DOC_Y(0); w = 0.8; h = 0.5333;
                text = "";
            };
            class Header: RscText {
                idc = 4001;
                x = DOC_X(0.03); y = DOC_Y(0.012); w = 0.52; h = 0.065;
                sizeEx = 0.052;
                font = "RobotoCondensedBold";
                colorText[] = {1, 1, 1, 1};
                shadow = 1;
            };
            class Stamp: RscStructuredText {
                idc = 4008;
                x = DOC_X(0.52); y = DOC_Y(0.018); w = 0.26; h = 0.06;
                size = 0.034;
                colorBackground[] = {0, 0, 0, 0};
            };
            class Photo: RscPicture {
                idc = 4002;
                x = DOC_X(0.0312); y = DOC_Y(0.1125); w = 0.2031; h = 0.3333;
                text = "\x\advsec\addons\main\data\photo_placeholder_ca.paa";
            };
            class PhotoLive: RscPicture {
                idc = 4006;
                x = DOC_X(0.0312); y = DOC_Y(0.1125); w = 0.2031; h = 0.3333;
                text = "";
            };
            class BodyL: RscStructuredText {
                idc = 4003;
                x = DOC_X(0.255); y = DOC_Y(0.11); w = 0.255; h = 0.34;
                size = 0.031;
                colorBackground[] = {0, 0, 0, 0};
            };
            class BodyR: RscStructuredText {
                idc = 4009;
                x = DOC_X(0.515); y = DOC_Y(0.11); w = 0.27; h = 0.34;
                size = 0.031;
                colorBackground[] = {0, 0, 0, 0};
            };
            class Footer: RscStructuredText {
                idc = 4004;
                x = DOC_X(0.025); y = DOC_Y(0.462); w = 0.75; h = 0.068;
                size = 0.026;
                colorBackground[] = {0, 0, 0, 0};
            };
        };
    };
    class ADVSEC_RscCameraHUD {
        idd = 86401;
        duration = 999999;
        fadeIn = 0;
        fadeOut = 0;
        movingEnable = 0;
        onLoad = "uiNamespace setVariable ['ADVSEC_camHUD', _this select 0]";
        class controls {
            class Static: RscText {
                idc = 4104;
                x = "safeZoneX"; y = "safeZoneY"; w = "safeZoneW"; h = "safeZoneH";
                style = 2;
                sizeEx = 0.08;
                text = "SIN SEÑAL";
                colorBackground[] = {0, 0, 0, 1};
                colorText[] = {0.8, 0.8, 0.8, 1};
            };
            class CamName: RscText {
                idc = 4101;
                x = "safeZoneX + 0.02"; y = "safeZoneY + 0.02"; w = 0.7; h = 0.05;
                sizeEx = 0.045;
                font = "EtelkaMonospacePro";
                colorText[] = {1, 1, 1, 1};
                colorBackground[] = {0, 0, 0, 0.4};
            };
            class Clock: RscText {
                idc = 4102;
                x = "safeZoneX + safeZoneW - 0.42"; y = "safeZoneY + 0.02"; w = 0.4; h = 0.05;
                style = 1;
                sizeEx = 0.045;
                font = "EtelkaMonospacePro";
                colorText[] = {1, 1, 1, 1};
                colorBackground[] = {0, 0, 0, 0.4};
            };
            class Alarm: RscText {
                idc = 4103;
                x = "safeZoneX"; y = "safeZoneY + safeZoneH - 0.14"; w = "safeZoneW"; h = 0.06;
                style = 2;
                sizeEx = 0.05;
                font = "RobotoCondensedBold";
                colorText[] = {1, 0.15, 0.15, 1};
            };
            class Help: RscText {
                idc = 4105;
                x = "safeZoneX"; y = "safeZoneY + safeZoneH - 0.07"; w = "safeZoneW"; h = 0.05;
                style = 2;
                sizeEx = 0.032;
                text = "Flechas izq./der.: cambiar cámara  -  N: visión nocturna/térmica  -  Retroceso: salir";
                colorText[] = {1, 1, 1, 0.8};
            };
        };
    };

    class ADVSEC_RscJail {
        idd = 86402;
        duration = 1e+011;
        fadeIn = 0.3;
        fadeOut = 0.3;
        movingEnable = 0;
        onLoad = "uiNamespace setVariable ['ADVSEC_jailHUD', _this select 0]";
        class controls {
            class Bar: RscText {
                idc = -1;
                x = "safeZoneX + safeZoneW / 2 - 0.3"; y = "safeZoneY + 0.03"; w = 0.005; h = 0.075;
                colorBackground[] = {1, 1, 1, 1};
            };
            class Text: RscStructuredText {
                idc = 4201;
                x = "safeZoneX + safeZoneW / 2 - 0.295"; y = "safeZoneY + 0.03"; w = 0.595; h = 0.075;
                size = 0.032;
                colorBackground[] = {0, 0, 0, 0.5};
                class Attributes {
                    font = "RobotoCondensed";
                    color = "#FFFFFF";
                    align = "left";
                    shadow = "0";
                };
            };
        };
    };
    class ADVSEC_RscProgress {
        idd = 86450;
        duration = 1e6;
        fadeIn = 0.15;
        fadeOut = 0.2;
        movingEnable = 0;
        onLoad = "uiNamespace setVariable ['ADVSEC_progDisplay', _this select 0]";
        class controls {
            class BG: RscText { idc = -1; x = 0.3; y = 0.78; w = 0.4; h = 0.075; colorBackground[] = ADVSEC_COL_PANEL; };
            class Accent: RscText { idc = -1; x = 0.3; y = 0.78; w = 0.004; h = 0.075; colorBackground[] = ADVSEC_COL_ACCENT; };
            class Title: RscText {
                idc = 86451; x = 0.31; y = 0.782; w = 0.3; h = 0.035;
                sizeEx = 0.03; font = "RobotoCondensedBold"; colorText[] = ADVSEC_COL_TEXT; text = "";
            };
            class Time: RscText {
                idc = 86452; x = 0.6; y = 0.782; w = 0.095; h = 0.035;
                sizeEx = 0.028; style = 1; colorText[] = {0.55, 0.55, 0.55, 1}; text = "";
            };
            class Track: RscText { idc = -1; x = 0.31; y = 0.825; w = 0.38; h = 0.018; colorBackground[] = ADVSEC_COL_DARK; };
            class Fill: RscText { idc = 86453; x = 0.31; y = 0.825; w = 0; h = 0.018; colorBackground[] = ADVSEC_COL_ACCENT; };
        };
    };
    class ADVSEC_RscStop {
        idd = 86460;
        duration = 6;
        fadeIn = 0.2;
        fadeOut = 0.8;
        movingEnable = 0;
        onLoad = "uiNamespace setVariable ['ADVSEC_stopDisplay', _this select 0]";
        class controls {
            class BG: RscText { idc = -1; x = 0.3; y = 0.12; w = 0.4; h = 0.19; colorBackground[] = {0.55, 0.04, 0.04, 0.92}; };
            class Frame: RscText { idc = -1; x = 0.3; y = 0.12; w = 0.4; h = 0.012; colorBackground[] = {1, 1, 1, 0.9}; };
            class Frame2: RscText { idc = -1; x = 0.3; y = 0.298; w = 0.4; h = 0.012; colorBackground[] = {1, 1, 1, 0.9}; };
            class Icon: RscPicture { idc = -1; x = 0.315; y = 0.155; w = 0.08; h = 0.107; text = "\A3\ui_f\data\igui\cfg\simpleTasks\types\danger_ca.paa"; colorText[] = {1, 1, 1, 1}; };
            class Big: RscText {
                idc = 86461; x = 0.405; y = 0.14; w = 0.29; h = 0.09;
                sizeEx = 0.085; font = "RobotoCondensedBold"; colorText[] = {1, 1, 1, 1}; text = "ALTO";
            };
            class Sub: RscStructuredText {
                idc = 86462; x = 0.405; y = 0.228; w = 0.29; h = 0.07;
                size = 0.03; colorText[] = {1, 1, 1, 1}; text = "";
            };
        };
    };
};
