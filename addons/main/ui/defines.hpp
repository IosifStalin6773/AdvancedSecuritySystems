class RscText;
class RscStructuredText;
class RscPicture;
class RscButton;
class RscEdit;
class RscListBox;
class RscCombo;
class RscControlsGroup;

// Paleta estilo THUD: panel gris muy oscuro, bordes grises, acento dorado, Roboto Condensed
#define ADVSEC_COL_PANEL {0.110, 0.110, 0.110, 0.98}
#define ADVSEC_COL_BORDER {0.227, 0.227, 0.227, 0.95}
#define ADVSEC_COL_HEADER {0.110, 0.110, 0.110, 0}
#define ADVSEC_COL_ACCENT {0.816, 0.639, 0.188, 1}
#define ADVSEC_COL_FIELD {0.118, 0.118, 0.118, 1}
#define ADVSEC_COL_BTN {0.157, 0.157, 0.157, 1}
#define ADVSEC_COL_BTNHI {0.227, 0.227, 0.227, 1}
#define ADVSEC_COL_ROW {0.173, 0.173, 0.173, 1}
#define ADVSEC_COL_DARK {0.078, 0.078, 0.078, 1}
#define ADVSEC_COL_TEXT {0.922, 0.922, 0.922, 1}
#define ADVSEC_COL_TEXTD {0.667, 0.667, 0.667, 1}
#define ADVSEC_COL_DIM {0.549, 0.549, 0.549, 1}

class ADVSEC_Panel: RscText {
    colorBackground[] = ADVSEC_COL_PANEL;
};
class ADVSEC_Border: RscText {
    style = 64;
    colorText[] = ADVSEC_COL_BORDER;
    colorBackground[] = {0, 0, 0, 0};
};
class ADVSEC_Header: RscText {
    font = "RobotoCondensedBold";
    sizeEx = 0.036;
    colorText[] = ADVSEC_COL_TEXT;
    colorBackground[] = ADVSEC_COL_HEADER;
    shadow = 0;
};
class ADVSEC_Accent: RscText {
    colorBackground[] = ADVSEC_COL_ACCENT;
};
class ADVSEC_Line: RscText {
    colorBackground[] = ADVSEC_COL_BORDER;
};
class ADVSEC_Label: RscText {
    font = "RobotoCondensed";
    sizeEx = 0.031;
    colorText[] = ADVSEC_COL_DIM;
    shadow = 0;
};
class ADVSEC_Struct: RscStructuredText {
    size = 0.031;
    colorBackground[] = {0, 0, 0, 0};
    shadow = 0;
    class Attributes {
        font = "RobotoCondensed";
        color = "#EBEBEB";
        colorLink = "#D0A330";
        align = "left";
        shadow = "0";
    };
};
class ADVSEC_Btn: RscButton {
    style = 2;
    font = "RobotoCondensedBold";
    sizeEx = 0.031;
    shadow = 0;
    colorText[] = ADVSEC_COL_TEXTD;
    colorDisabled[] = {0.667, 0.667, 0.667, 0.35};
    colorBackground[] = ADVSEC_COL_BTN;
    colorBackgroundDisabled[] = {0.133, 0.133, 0.133, 0.6};
    colorBackgroundActive[] = ADVSEC_COL_BTNHI;
    colorFocused[] = ADVSEC_COL_BTNHI;
    colorShadow[] = {0, 0, 0, 0};
    colorBorder[] = {0, 0, 0, 0};
    borderSize = 0;
    offsetX = 0;
    offsetY = 0;
    offsetPressedX = 0;
    offsetPressedY = 0;
    soundEnter[] = {"", 0.09, 1};
    soundPush[] = {"\A3\ui_f\data\sound\RscButton\soundPush", 0.09, 1};
    soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick", 0.09, 1};
    soundEscape[] = {"", 0.09, 1};
};
class ADVSEC_BtnPrimary: ADVSEC_Btn {
    colorText[] = ADVSEC_COL_DARK;
    colorBackground[] = ADVSEC_COL_ACCENT;
    colorBackgroundActive[] = {0.886, 0.709, 0.258, 1};
    colorFocused[] = {0.886, 0.709, 0.258, 1};
};
class ADVSEC_BtnOk: ADVSEC_BtnPrimary {};
class ADVSEC_BtnDanger: ADVSEC_Btn {
    colorText[] = {1, 0.302, 0.302, 1};
};
class ADVSEC_BtnX: ADVSEC_Btn {
    font = "RobotoCondensed";
    sizeEx = 0.042;
    text = "×";
    action = "closeDialog 0";
};
class ADVSEC_Edit: RscEdit {
    font = "RobotoCondensed";
    sizeEx = 0.031;
    shadow = 0;
    colorText[] = ADVSEC_COL_TEXT;
    colorDisabled[] = {0.5, 0.5, 0.5, 1};
    colorBackground[] = ADVSEC_COL_DARK;
    colorSelection[] = {0.816, 0.639, 0.188, 0.55};
};
class ADVSEC_EditMulti: ADVSEC_Edit {
    style = 16;
    lineSpacing = 1;
};
class ADVSEC_Combo: RscCombo {
    font = "RobotoCondensed";
    sizeEx = 0.031;
    shadow = 0;
    colorText[] = ADVSEC_COL_TEXT;
    colorBackground[] = ADVSEC_COL_ROW;
    colorSelect[] = ADVSEC_COL_DARK;
    colorSelectBackground[] = ADVSEC_COL_ACCENT;
    colorScrollbar[] = ADVSEC_COL_ACCENT;
    class ComboScrollBar {
        color[] = {0.816, 0.639, 0.188, 0.75};
        colorActive[] = ADVSEC_COL_ACCENT;
        colorDisabled[] = {0.5, 0.5, 0.5, 0.5};
        thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
        arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
        arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
        border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
        shadow = 0;
    };
};
class ADVSEC_List: RscListBox {
    font = "RobotoCondensed";
    sizeEx = 0.031;
    rowHeight = 0.042;
    shadow = 0;
    colorText[] = ADVSEC_COL_TEXT;
    colorBackground[] = ADVSEC_COL_FIELD;
    colorSelect[] = ADVSEC_COL_DARK;
    colorSelect2[] = ADVSEC_COL_DARK;
    colorSelectBackground[] = ADVSEC_COL_ACCENT;
    colorSelectBackground2[] = {0.816, 0.639, 0.188, 0.8};
    colorScrollbar[] = ADVSEC_COL_ACCENT;
    class ListScrollBar {
        color[] = {0.816, 0.639, 0.188, 0.75};
        colorActive[] = ADVSEC_COL_ACCENT;
        colorDisabled[] = {0.5, 0.5, 0.5, 0.5};
        thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
        arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
        arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
        border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
        shadow = 0;
    };
};
class ADVSEC_ListMulti: ADVSEC_List {
    style = 32;
};

class ADVSEC_KpBtn: ADVSEC_Btn {
    w = 0.0634;
    h = 0.075;
    sizeEx = 0.05;
    font = "RobotoCondensedBold";
    colorText[] = ADVSEC_COL_TEXT;
    colorBackground[] = ADVSEC_COL_ROW;
    onButtonClick = "['press', ctrlText (_this select 0)] call ADVSEC_fnc_keypadUI";
};
