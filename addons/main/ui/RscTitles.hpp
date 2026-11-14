#define ADVSEC_Q(V) #V
#define DOC_X(N) ADVSEC_Q(safeZoneX + safeZoneW / 2 + ((N) - 0.4) * safezoneH)
#define DOC_Y(N) ADVSEC_Q(safeZoneY + safeZoneH / 2 + ((N) - 0.29) * safezoneH)
#define DOC_S(N) ADVSEC_Q((N) * safezoneH)

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
                x = DOC_X(0); y = DOC_Y(0); w = DOC_S(0.8); h = DOC_S(0.5333);
                colorBackground[] = {0.1, 0.2, 0.45, 0.97};
            };
            class BG: RscPicture {
                idc = 4000;
                x = DOC_X(0); y = DOC_Y(0); w = DOC_S(0.8); h = DOC_S(0.5333);
                text = "";
            };
            class Header: RscText {
                idc = 4001;
                x = DOC_X(0.03); y = DOC_Y(0.012); w = DOC_S(0.52); h = DOC_S(0.065);
                sizeEx = UIT(0.052);
                font = "RobotoCondensedBold";
                colorText[] = {1, 1, 1, 1};
                shadow = 1;
            };
            class Stamp: RscStructuredText {
                idc = 4008;
                x = DOC_X(0.52); y = DOC_Y(0.018); w = DOC_S(0.26); h = DOC_S(0.06);
                size = UIT(0.034);
                colorBackground[] = {0, 0, 0, 0};
            };
            class Photo: RscPicture {
                idc = 4002;
                x = DOC_X(0.0312); y = DOC_Y(0.1125); w = DOC_S(0.2031); h = DOC_S(0.3333);
                text = "\x\advsec\addons\main\data\photo_placeholder_ca.paa";
            };
            class PhotoLive: RscPicture {
                idc = 4006;
                x = DOC_X(0.0312); y = DOC_Y(0.1125); w = DOC_S(0.2031); h = DOC_S(0.3333);
                text = "";
            };
            class BodyL: RscStructuredText {
                idc = 4003;
                x = DOC_X(0.255); y = DOC_Y(0.11); w = DOC_S(0.255); h = DOC_S(0.34);
                size = UIT(0.031);
                colorBackground[] = {0, 0, 0, 0};
            };
            class BodyR: RscStructuredText {
                idc = 4009;
                x = DOC_X(0.515); y = DOC_Y(0.11); w = DOC_S(0.27); h = DOC_S(0.34);
                size = UIT(0.031);
                colorBackground[] = {0, 0, 0, 0};
            };
            class Footer: RscStructuredText {
                idc = 4004;
                x = DOC_X(0.025); y = DOC_Y(0.462); w = DOC_S(0.75); h = DOC_S(0.068);
                size = UIT(0.026);
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
                sizeEx = UIT(0.08);
                text = "$STR_ADVSEC_no_signal";
                colorBackground[] = {0, 0, 0, 1};
                colorText[] = {0.8, 0.8, 0.8, 1};
            };
            class CamName: RscText {
                idc = 4101;
                x = "safeZoneX + (0.02 * (safezoneH))"; y = "safeZoneY + (0.02 * (safezoneH))"; w = UIF(0.7); h = UIF(0.05);
                sizeEx = UIT(0.045);
                font = "EtelkaMonospacePro";
                colorText[] = {1, 1, 1, 1};
                colorBackground[] = {0, 0, 0, 0.4};
            };
            class Clock: RscText {
                idc = 4102;
                x = "safeZoneX + safeZoneW - (0.42 * (safezoneH))"; y = "safeZoneY + (0.02 * (safezoneH))"; w = UIF(0.4); h = UIF(0.05);
                style = 1;
                sizeEx = UIT(0.045);
                font = "EtelkaMonospacePro";
                colorText[] = {1, 1, 1, 1};
                colorBackground[] = {0, 0, 0, 0.4};
            };
            class Alarm: RscText {
                idc = 4103;
                x = "safeZoneX"; y = "safeZoneY + safeZoneH - (0.14 * (safezoneH))"; w = "safeZoneW"; h = UIF(0.06);
                style = 2;
                sizeEx = UIT(0.05);
                font = "RobotoCondensedBold";
                colorText[] = {1, 0.15, 0.15, 1};
            };
            class Help: RscText {
                idc = 4105;
                x = "safeZoneX"; y = "safeZoneY + safeZoneH - (0.07 * (safezoneH))"; w = "safeZoneW"; h = UIF(0.05);
                style = 2;
                sizeEx = UIT(0.032);
                text = "$STR_ADVSEC_left_right_arrows_switch_camera";
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
                x = "safeZoneX + safeZoneW / 2 - (0.3 * (safezoneH))"; y = "safeZoneY + (0.03 * (safezoneH))"; w = UIF(0.005); h = UIF(0.075);
                colorBackground[] = {1, 1, 1, 1};
            };
            class Text: RscStructuredText {
                idc = 4201;
                x = "safeZoneX + safeZoneW / 2 - (0.295 * (safezoneH))"; y = "safeZoneY + (0.03 * (safezoneH))"; w = UIF(0.595); h = UIF(0.075);
                size = UIT(0.032);
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
            class BG: RscText { idc = -1; x = UIX(0.3); y = UIY(0.78); w = UIW(0.4); h = UIH(0.075); colorBackground[] = ADVSEC_COL_PANEL; };
            class Accent: RscText { idc = -1; x = UIX(0.3); y = UIY(0.78); w = UIW(0.004); h = UIH(0.075); colorBackground[] = ADVSEC_COL_ACCENT; };
            class Title: RscText {
                idc = 86451; x = UIX(0.31); y = UIY(0.782); w = UIW(0.3); h = UIH(0.035);
                sizeEx = UIT(0.03); font = "RobotoCondensedBold"; colorText[] = ADVSEC_COL_TEXT; text = "";
            };
            class Time: RscText {
                idc = 86452; x = UIX(0.6); y = UIY(0.782); w = UIW(0.095); h = UIH(0.035);
                sizeEx = UIT(0.028); style = 1; colorText[] = {0.55, 0.55, 0.55, 1}; text = "";
            };
            class Track: RscText { idc = -1; x = UIX(0.31); y = UIY(0.825); w = UIW(0.38); h = UIH(0.018); colorBackground[] = ADVSEC_COL_DARK; };
            class Fill: RscText { idc = 86453; x = UIX(0.31); y = UIY(0.825); w = UIW(0); h = UIH(0.018); colorBackground[] = ADVSEC_COL_ACCENT; };
        };
    };
    class ADVSEC_RscStop {
        idd = 86460;
        duration = 8;
        fadeIn = 0.2;
        fadeOut = 0.8;
        movingEnable = 0;
        onLoad = "uiNamespace setVariable ['ADVSEC_stopDisplay', _this select 0]";
        class controls {
            // El alto del cartel se ajusta al texto en ADVSEC_fnc_cpAlert
            class BG: RscText { idc = 86463; x = UIX(0.2); y = UIY(0.1); w = UIW(0.6); h = UIH(0.22); colorBackground[] = {0.55, 0.04, 0.04, 0.92}; };
            class Frame: RscText { idc = 86464; x = UIX(0.2); y = UIY(0.1); w = UIW(0.6); h = UIH(0.01); colorBackground[] = {1, 1, 1, 0.9}; };
            class Frame2: RscText { idc = 86465; x = UIX(0.2); y = UIY(0.31); w = UIW(0.6); h = UIH(0.01); colorBackground[] = {1, 1, 1, 0.9}; };
            class Icon: RscPicture { idc = -1; x = UIXP(0.215,0.075); y = UIY(0.13); w = UIF(0.075); h = UIH(0.1); text = "\A3\ui_f\data\igui\cfg\simpleTasks\types\danger_ca.paa"; colorText[] = {1, 1, 1, 1}; };
            class Big: RscText {
                idc = 86461; x = UIX(0.3); y = UIY(0.12); w = UIW(0.49); h = UIH(0.075);
                sizeEx = UIT(0.065); font = "RobotoCondensedBold"; colorText[] = {1, 1, 1, 1}; text = "ALTO";
            };
            class Sub: RscStructuredText {
                idc = 86462; x = UIX(0.3); y = UIY(0.2); w = UIW(0.49); h = UIH(0.1);
                size = UIT(0.034); colorText[] = {1, 1, 1, 1}; text = "";
            };
        };
    };
};
