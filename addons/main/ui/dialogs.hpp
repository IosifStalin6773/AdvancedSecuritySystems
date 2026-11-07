// ===== Keypad =====
class ADVSEC_Keypad {
    idd = 86100;
    movingEnable = 0;
    onLoad = "['on'] call ADVSEC_fnc_uiBlur";
    onUnload = "['off'] call ADVSEC_fnc_uiBlur";
    class controlsBackground {
        class BG: ADVSEC_Panel { x = 0.39; y = 0.22; w = 0.22; h = 0.56; };
        class Border: ADVSEC_Border { x = 0.39; y = 0.22; w = 0.22; h = 0.56; };
        class Head: ADVSEC_Header { text = "$STR_ADVSEC_access_control"; x = 0.39; y = 0.22; w = 0.22; h = 0.04; };
        class Line: ADVSEC_Line { x = 0.39; y = 0.26; w = 0.22; h = 0.003; };
    };
    class controls {
        class Screen: RscText {
            idc = 1000;
            x = 0.40; y = 0.272; w = 0.20; h = 0.06;
            style = 2;
            sizeEx = 0.055;
            font = "EtelkaMonospacePro";
            colorText[] = ADVSEC_COL_ACCENT;
            colorBackground[] = ADVSEC_COL_DARK;
        };
        class Status: RscText {
            idc = 1001;
            x = 0.40; y = 0.338; w = 0.20; h = 0.035;
            style = 2;
            sizeEx = 0.027;
            font = "RobotoCondensed";
            colorText[] = ADVSEC_COL_TEXTD;
        };
        class B1: ADVSEC_KpBtn { text = "1"; x = 0.4000; y = 0.385; };
        class B2: ADVSEC_KpBtn { text = "2"; x = 0.4733; y = 0.385; };
        class B3: ADVSEC_KpBtn { text = "3"; x = 0.5466; y = 0.385; };
        class B4: ADVSEC_KpBtn { text = "4"; x = 0.4000; y = 0.470; };
        class B5: ADVSEC_KpBtn { text = "5"; x = 0.4733; y = 0.470; };
        class B6: ADVSEC_KpBtn { text = "6"; x = 0.5466; y = 0.470; };
        class B7: ADVSEC_KpBtn { text = "7"; x = 0.4000; y = 0.555; };
        class B8: ADVSEC_KpBtn { text = "8"; x = 0.4733; y = 0.555; };
        class B9: ADVSEC_KpBtn { text = "9"; x = 0.5466; y = 0.555; };
        class BC: ADVSEC_KpBtn { text = "C"; x = 0.4000; y = 0.640; colorText[] = {1, 0.302, 0.302, 1}; };
        class B0: ADVSEC_KpBtn { text = "0"; x = 0.4733; y = 0.640; };
        class BOK: ADVSEC_KpBtn { text = "OK"; x = 0.5466; y = 0.640; colorText[] = ADVSEC_COL_DARK; colorBackground[] = ADVSEC_COL_ACCENT; colorFocused[] = ADVSEC_COL_ACCENT; colorBackgroundActive[] = ADVSEC_COL_ACCENT; };
        class Close: ADVSEC_Btn {
            text = "$STR_ADVSEC_close";
            x = 0.40; y = 0.725; w = 0.20; h = 0.045;
            action = "closeDialog 0";
        };
        class CloseX: ADVSEC_BtnX { x = 0.58; y = 0.22; w = 0.03; h = 0.04; };
    };
};

// ===== Lista de documentos =====
class ADVSEC_DocList {
    idd = 86300;
    movingEnable = 0;
    onLoad = "['on'] call ADVSEC_fnc_uiBlur";
    onUnload = "['off'] call ADVSEC_fnc_uiBlur";
    class controlsBackground {
        class BG: ADVSEC_Panel { x = 0.20; y = 0.17; w = 0.60; h = 0.62; };
        class Border: ADVSEC_Border { x = 0.20; y = 0.17; w = 0.60; h = 0.62; };
        class Line: ADVSEC_Line { x = 0.20; y = 0.215; w = 0.60; h = 0.003; };
        class PrevBG: RscText { x = 0.475; y = 0.23; w = 0.315; h = 0.48; colorBackground[] = ADVSEC_COL_FIELD; };
        class PrevBGBar: ADVSEC_Accent { x = 0.475; y = 0.23; w = 0.004; h = 0.48; };
    };
    class controls {
        class Title: ADVSEC_Header {
            idc = 3000;
            x = 0.20; y = 0.17; w = 0.60; h = 0.045;
        };
        class List: ADVSEC_List {
            idc = 3001;
            x = 0.21; y = 0.23; w = 0.255; h = 0.48;
            onLBDblClick = "['view'] call ADVSEC_fnc_docListAction";
            onLBSelChanged = "['preview'] call ADVSEC_fnc_docListAction";
        };
        class Preview: ADVSEC_Struct {
            idc = 3002;
            x = 0.48; y = 0.235; w = 0.305; h = 0.47;
        };
        class BtnView: ADVSEC_BtnPrimary {
            idc = 3101;
            text = "$STR_ADVSEC_view_card";
            x = 0.21; y = 0.725; w = 0.14; h = 0.05;
            action = "['view'] call ADVSEC_fnc_docListAction";
        };
        class BtnShow: ADVSEC_Btn {
            idc = 3102;
            text = "$STR_ADVSEC_show";
            x = 0.36; y = 0.725; w = 0.14; h = 0.05;
            action = "['show'] call ADVSEC_fnc_docListAction";
        };
        class BtnClose: ADVSEC_BtnDanger {
            text = "$STR_ADVSEC_close";
            x = 0.65; y = 0.725; w = 0.14; h = 0.05;
            action = "closeDialog 0";
        };
        class CloseX: ADVSEC_BtnX { x = 0.7662; y = 0.17; w = 0.0338; h = 0.045; };
    };
};

// ===== Emisión de documentos =====
#define ED_L(N,I,T,Y) class L##N: ADVSEC_Label { idc = I; text = T; x = 0.27; y = Y; w = 0.15; h = 0.045; };
class ADVSEC_DocEditor {
    idd = 86200;
    movingEnable = 0;
    onLoad = "['on'] call ADVSEC_fnc_uiBlur";
    onUnload = "['off'] call ADVSEC_fnc_uiBlur";
    class controlsBackground {
        class BG: ADVSEC_Panel { x = 0.25; y = 0.05; w = 0.50; h = 0.88; };
        class Border: ADVSEC_Border { x = 0.25; y = 0.05; w = 0.50; h = 0.88; };
        class Line: ADVSEC_Line { x = 0.25; y = 0.095; w = 0.50; h = 0.003; };
        class InfoBG: RscText { x = 0.27; y = 0.72; w = 0.46; h = 0.11; colorBackground[] = ADVSEC_COL_FIELD; };
        class InfoBGBar: ADVSEC_Accent { x = 0.27; y = 0.72; w = 0.004; h = 0.11; };
    };
    class controls {
        ED_L(0,2200,"$STR_ADVSEC_type",0.11)
        ED_L(1,2201,"$STR_ADVSEC_for",0.165)
        ED_L(2,2202,"$STR_ADVSEC_name",0.22)
        ED_L(3,2203,"$STR_ADVSEC_nationality",0.275)
        ED_L(4,2204,"$STR_ADVSEC_date_of_birth",0.33)
        ED_L(5,2205,"$STR_ADVSEC_number_empty_auto",0.385)
        ED_L(6,2206,"$STR_ADVSEC_issuer",0.44)
        ED_L(7,2207,"$STR_ADVSEC_expiry",0.495)
        ED_L(8,2208,"$STR_ADVSEC_access_level",0.55)
        ED_L(9,2209,"$STR_ADVSEC_keys_ids",0.605)
        ED_L(10,2210,"$STR_ADVSEC_notes",0.66)
        class Title: ADVSEC_Header { idc = 2000; text = "$STR_ADVSEC_document_issuance_2"; x = 0.25; y = 0.05; w = 0.50; h = 0.045; };
        class EName: ADVSEC_Edit { idc = 2101; x = 0.43; y = 0.22; w = 0.30; h = 0.045; };
        class ENat: ADVSEC_Edit { idc = 2102; x = 0.43; y = 0.275; w = 0.30; h = 0.045; };
        class EDob: ADVSEC_Edit { idc = 2103; x = 0.43; y = 0.33; w = 0.30; h = 0.045; tooltip = "AAAA-MM-DD"; };
        class ENum: ADVSEC_Edit { idc = 2104; x = 0.43; y = 0.385; w = 0.30; h = 0.045; };
        class EIss: ADVSEC_Edit { idc = 2105; x = 0.43; y = 0.44; w = 0.30; h = 0.045; };
        class EKeys: ADVSEC_Edit { idc = 2108; x = 0.43; y = 0.605; w = 0.30; h = 0.045; tooltip = "$STR_ADVSEC_comma_separated_key_ids"; };
        class ENotes: ADVSEC_Edit { idc = 2109; x = 0.43; y = 0.66; w = 0.30; h = 0.045; };
        class Info: ADVSEC_Struct { idc = 2003; x = 0.275; y = 0.725; w = 0.45; h = 0.10; };
        class BtnOk: ADVSEC_BtnOk {
            text = "$STR_ADVSEC_issue";
            x = 0.43; y = 0.86; w = 0.145; h = 0.05;
            action = "[] call ADVSEC_fnc_docEditorSubmit";
        };
        class BtnCancel: ADVSEC_BtnDanger {
            text = "$STR_ADVSEC_cancel_2";
            x = 0.585; y = 0.86; w = 0.145; h = 0.05;
            action = "closeDialog 0";
        };
        class CClr: ADVSEC_Combo { idc = 2107; x = 0.43; y = 0.55; w = 0.30; h = 0.045; };
        class CExp: ADVSEC_Combo { idc = 2106; x = 0.43; y = 0.495; w = 0.30; h = 0.045; };
        class CTarget: ADVSEC_Combo {
            idc = 2002;
            x = 0.43; y = 0.165; w = 0.30; h = 0.045;
            onLBSelChanged = "['target'] call ADVSEC_fnc_docEditorRefresh";
        };
        class CType: ADVSEC_Combo {
            idc = 2001;
            x = 0.43; y = 0.11; w = 0.30; h = 0.045;
            onLBSelChanged = "['type'] call ADVSEC_fnc_docEditorRefresh";
        };
        class CloseX: ADVSEC_BtnX { x = 0.7162; y = 0.05; w = 0.0338; h = 0.045; };
    };
};

// ===== Formulario genérico (Zeus y diálogos rápidos; los campos se crean al abrir) =====
class ADVSEC_ZeusPrompt {
    idd = 86500;
    movingEnable = 0;
    onLoad = "['on'] call ADVSEC_fnc_uiBlur";
    onUnload = "['off'] call ADVSEC_fnc_uiBlur";
    class controlsBackground {
        class BG: ADVSEC_Panel { idc = 86502; x = 0.27; y = 0.2; w = 0.46; h = 0.6; };
        class Border: ADVSEC_Border { idc = 86506; x = 0.27; y = 0.2; w = 0.46; h = 0.6; };
    };
    class controls {
        class Title: ADVSEC_Header { idc = 86501; x = 0.27; y = 0.2; w = 0.46; h = 0.045; };
        class Line: ADVSEC_Line { idc = 86505; x = 0.27; y = 0.245; w = 0.46; h = 0.003; };
        class BtnOk: ADVSEC_BtnOk {
            idc = 86503;
            text = "$STR_ADVSEC_accept";
            x = 0.45; y = 0.74; w = 0.13; h = 0.045;
            action = "[] call ADVSEC_fnc_zeusPromptOK";
        };
        class BtnCancel: ADVSEC_BtnDanger {
            idc = 86504;
            text = "$STR_ADVSEC_cancel_2";
            x = 0.59; y = 0.74; w = 0.13; h = 0.045;
            action = "closeDialog 0";
        };
        class CloseX: ADVSEC_BtnX { idc = 86507; x = 0.6962; y = 0.2; w = 0.0338; h = 0.045; };
    };
};

// ===== Archivo de informes =====
class ADVSEC_Reports {
    idd = 86600;
    movingEnable = 0;
    onLoad = "['on'] call ADVSEC_fnc_uiBlur";
    onUnload = "['off'] call ADVSEC_fnc_uiBlur";
    class controlsBackground {
        class BG: ADVSEC_Panel { x = 0; y = 0; w = 1; h = 1; };
        class Border: ADVSEC_Border { x = 0; y = 0; w = 1; h = 1; };
        class Line: ADVSEC_Line { x = 0; y = 0.05; w = 1; h = 0.003; };
        class ViewBG: RscText { x = 0.42; y = 0.065; w = 0.57; h = 0.85; colorBackground[] = ADVSEC_COL_FIELD; };
        class ViewBGBar: ADVSEC_Accent { x = 0.42; y = 0.065; w = 0.004; h = 0.85; };
    };
    class controls {
        class Title: ADVSEC_Header {
            idc = 86601;
            x = 0; y = 0; w = 1; h = 0.05;
            
        };
        class Search: ADVSEC_Edit {
            idc = 86611;
            x = 0.16; y = 0.065; w = 0.18; h = 0.04;
            tooltip = "$STR_ADVSEC_search_by_id_name_steamid";
        };
        class BtnSearch: ADVSEC_BtnPrimary {
            text = "$STR_ADVSEC_search_5";
            x = 0.345; y = 0.065; w = 0.065; h = 0.04;
            action = "['refresh'] call ADVSEC_fnc_repAction";
        };
        class List: ADVSEC_List {
            idc = 86602;
            x = 0.01; y = 0.115; w = 0.40; h = 0.80;
            sizeEx = 0.028;
            rowHeight = 0.036;
            onLBSelChanged = "['select'] call ADVSEC_fnc_repAction";
        };
        class ViewGroup: RscControlsGroup {
            idc = 86620;
            x = 0.42; y = 0.065; w = 0.57; h = 0.85;
            class controls {
                class View: ADVSEC_Struct {
                    idc = 86603;
                    x = 0.01; y = 0.005; w = 0.54; h = 0.84;
                };
            };
        };
        class BtnNew: ADVSEC_BtnPrimary {
            text = "$STR_ADVSEC_new_report";
            x = 0.01; y = 0.935; w = 0.13; h = 0.05;
            action = "['new'] call ADVSEC_fnc_repAction";
        };
        class BtnNote: ADVSEC_Btn {
            text = "$STR_ADVSEC_add_note";
            x = 0.15; y = 0.935; w = 0.13; h = 0.05;
            action = "['note'] call ADVSEC_fnc_repAction";
        };
        class BtnStatus: ADVSEC_Btn {
            text = "$STR_ADVSEC_status_sanction_2";
            x = 0.29; y = 0.935; w = 0.13; h = 0.05;
            action = "['status'] call ADVSEC_fnc_repAction";
        };
        class BtnWanted: ADVSEC_Btn {
            text = "$STR_ADVSEC_wanted_2";
            x = 0.43; y = 0.935; w = 0.11; h = 0.05;
            action = "[] call ADVSEC_fnc_wantedOpen";
        };
        class BtnRefresh: ADVSEC_Btn {
            text = "$STR_ADVSEC_refresh";
            x = 0.55; y = 0.935; w = 0.11; h = 0.05;
            action = "['refresh'] call ADVSEC_fnc_repAction";
        };
        class BtnClose: ADVSEC_BtnDanger {
            text = "$STR_ADVSEC_close";
            x = 0.87; y = 0.935; w = 0.12; h = 0.05;
            action = "closeDialog 0";
        };
        class Dept: ADVSEC_Combo {
            idc = 86610;
            x = 0.01; y = 0.065; w = 0.14; h = 0.04;
            onLBSelChanged = "['refresh'] call ADVSEC_fnc_repAction";
        };
        class CloseX: ADVSEC_BtnX { x = 0.9625; y = 0.0; w = 0.0375; h = 0.05; };
    };
};

// ===== Editor de informes =====
#define RE_L(N,T,X,Y,W) class L##N: ADVSEC_Label { text = T; x = X; y = Y; w = W; h = 0.04; };
class ADVSEC_ReportEditor {
    idd = 86700;
    movingEnable = 0;
    onLoad = "['on'] call ADVSEC_fnc_uiBlur";
    onUnload = "['off'] call ADVSEC_fnc_uiBlur";
    class controlsBackground {
        class BG: ADVSEC_Panel { x = 0.08; y = 0.01; w = 0.84; h = 0.98; };
        class Border: ADVSEC_Border { x = 0.08; y = 0.01; w = 0.84; h = 0.98; };
        class Line: ADVSEC_Line { x = 0.08; y = 0.06; w = 0.84; h = 0.003; };
        class HintBG: RscText { x = 0.28; y = 0.18; w = 0.62; h = 0.055; colorBackground[] = ADVSEC_COL_FIELD; };
        class HintBGBar: ADVSEC_Accent { x = 0.28; y = 0.18; w = 0.004; h = 0.055; };
        RE_L(0,"$STR_ADVSEC_form",0.10,0.08,0.17)
        RE_L(1,"$STR_ADVSEC_severity",0.10,0.13,0.17)
        RE_L(2,"$STR_ADVSEC_confidential",0.52,0.13,0.14)
        RE_L(3,"$STR_ADVSEC_add_involved_person",0.10,0.25,0.17)
        RE_L(4,"$STR_ADVSEC_involved_2",0.10,0.30,0.17)
        RE_L(5,"$STR_ADVSEC_subject_title",0.10,0.35,0.17)
        RE_L(6,"$STR_ADVSEC_date_time_place",0.10,0.40,0.17)
        RE_L(7,"$STR_ADVSEC_evidence_witnesses",0.10,0.45,0.17)
        RE_L(8,"$STR_ADVSEC_description_of_the_facts",0.10,0.50,0.17)
        RE_L(9,"$STR_ADVSEC_proposed_sanction",0.10,0.87,0.17)
    };
    class controls {
        class Title: ADVSEC_Header {
            idc = 86701;
            text = "$STR_ADVSEC_new_report_2";
            x = 0.08; y = 0.01; w = 0.84; h = 0.05;
            
        };
        class Hint: ADVSEC_Struct {
            idc = 86719;
            x = 0.285; y = 0.182; w = 0.61; h = 0.05;
            size = 0.027;
        };
        class BtnAdd: ADVSEC_Btn {
            text = "$STR_ADVSEC_add";
            x = 0.77; y = 0.25; w = 0.13; h = 0.04;
            action = "['addSubject'] call ADVSEC_fnc_repEditorAction";
        };
        class ESubjects: ADVSEC_Edit { idc = 86714; x = 0.28; y = 0.30; w = 0.62; h = 0.04; };
        class ETitle: ADVSEC_Edit { idc = 86715; x = 0.28; y = 0.35; w = 0.62; h = 0.04; };
        class EPlace: ADVSEC_Edit { idc = 86716; x = 0.28; y = 0.40; w = 0.62; h = 0.04; };
        class EWitness: ADVSEC_Edit { idc = 86717; x = 0.28; y = 0.45; w = 0.62; h = 0.04; };
        class EBody: ADVSEC_Edit {
            idc = 86718;
            style = 16;
            lineSpacing = 1;
            x = 0.28; y = 0.50; w = 0.62; h = 0.35;
        };
        class BtnSave: ADVSEC_BtnOk {
            text = "$STR_ADVSEC_log_2";
            x = 0.62; y = 0.93; w = 0.14; h = 0.045;
            action = "['save'] call ADVSEC_fnc_repEditorAction";
        };
        class BtnCancel: ADVSEC_BtnDanger {
            text = "$STR_ADVSEC_cancel_2";
            x = 0.77; y = 0.93; w = 0.13; h = 0.045;
            action = "closeDialog 0";
        };
        class CSanction: ADVSEC_Combo { idc = 86720; x = 0.28; y = 0.87; w = 0.35; h = 0.04; };
        class CSubject: ADVSEC_Combo { idc = 86713; x = 0.28; y = 0.25; w = 0.48; h = 0.04; };
        class CConf: ADVSEC_Combo { idc = 86712; x = 0.67; y = 0.13; w = 0.23; h = 0.04; };
        class CGravity: ADVSEC_Combo { idc = 86711; x = 0.28; y = 0.13; w = 0.22; h = 0.04; };
        class CFormat: ADVSEC_Combo {
            idc = 86710;
            x = 0.28; y = 0.08; w = 0.62; h = 0.04;
            onLBSelChanged = "['format'] call ADVSEC_fnc_repEditorAction";
        };
        class CloseX: ADVSEC_BtnX { x = 0.8825; y = 0.01; w = 0.0375; h = 0.05; };
    };
};

// ===== Registro / cacheo =====
class ADVSEC_Search {
    idd = 86800;
    movingEnable = 0;
    onLoad = "['on'] call ADVSEC_fnc_uiBlur";
    onUnload = "['off'] call ADVSEC_fnc_uiBlur";
    class controlsBackground {
        class BG: ADVSEC_Panel { x = 0.20; y = 0.10; w = 0.60; h = 0.80; };
        class Border: ADVSEC_Border { x = 0.20; y = 0.10; w = 0.60; h = 0.80; };
        class Line: ADVSEC_Line { x = 0.20; y = 0.145; w = 0.60; h = 0.003; };
        class InfoBG: RscText { x = 0.21; y = 0.16; w = 0.58; h = 0.09; colorBackground[] = ADVSEC_COL_FIELD; };
        class InfoBGBar: ADVSEC_Accent { x = 0.21; y = 0.16; w = 0.004; h = 0.09; };
    };
    class controls {
        class Title: ADVSEC_Header { idc = 86801; x = 0.20; y = 0.10; w = 0.60; h = 0.045; };
        class Info: ADVSEC_Struct { idc = 86802; x = 0.215; y = 0.165; w = 0.57; h = 0.08; };
        class List: ADVSEC_List {
            idc = 86803;
            x = 0.21; y = 0.26; w = 0.58; h = 0.56;
            onLBDblClick = "['view'] call ADVSEC_fnc_searchAction";
        };
        class BtnSeize: ADVSEC_BtnDanger {
            text = "$STR_ADVSEC_seize";
            x = 0.21; y = 0.835; w = 0.13; h = 0.05;
            action = "['seize'] call ADVSEC_fnc_searchAction";
        };
        class BtnView: ADVSEC_Btn {
            text = "$STR_ADVSEC_search_zone_view";
            x = 0.35; y = 0.835; w = 0.13; h = 0.05;
            action = "['view'] call ADVSEC_fnc_searchAction";
        };
        class BtnReport: ADVSEC_BtnPrimary {
            text = "$STR_ADVSEC_add_to_report";
            x = 0.49; y = 0.835; w = 0.15; h = 0.05;
            action = "['report'] call ADVSEC_fnc_searchAction";
        };
        class BtnClose: ADVSEC_Btn {
            text = "$STR_ADVSEC_close";
            x = 0.66; y = 0.835; w = 0.13; h = 0.05;
            action = "closeDialog 0";
        };
        class CloseX: ADVSEC_BtnX { x = 0.7662; y = 0.1; w = 0.0338; h = 0.045; };
    };
};

// ===== Lista de buscados =====
class ADVSEC_Wanted {
    idd = 86900;
    movingEnable = 0;
    onLoad = "['on'] call ADVSEC_fnc_uiBlur";
    onUnload = "['off'] call ADVSEC_fnc_uiBlur";
    class controlsBackground {
        class BG: ADVSEC_Panel { x = 0.20; y = 0.12; w = 0.60; h = 0.76; };
        class Border: ADVSEC_Border { x = 0.20; y = 0.12; w = 0.60; h = 0.76; };
        class Line: ADVSEC_Line { x = 0.20; y = 0.165; w = 0.60; h = 0.003; };
        class InfoBG: RscText { x = 0.21; y = 0.64; w = 0.58; h = 0.14; colorBackground[] = ADVSEC_COL_FIELD; };
        class InfoBGBar: ADVSEC_Accent { x = 0.21; y = 0.64; w = 0.004; h = 0.14; };
    };
    class controls {
        class Title: ADVSEC_Header {
            text = "$STR_ADVSEC_wanted_list_military_police";
            x = 0.20; y = 0.12; w = 0.60; h = 0.045;
            
        };
        class List: ADVSEC_List {
            idc = 86901;
            x = 0.21; y = 0.18; w = 0.58; h = 0.45;
            onLBSelChanged = "['select'] call ADVSEC_fnc_wantedAction";
        };
        class Info: ADVSEC_Struct { idc = 86902; x = 0.215; y = 0.645; w = 0.57; h = 0.13; };
        class BtnAdd: ADVSEC_BtnPrimary {
            text = "$STR_ADVSEC_add";
            x = 0.21; y = 0.80; w = 0.13; h = 0.05;
            action = "['add'] call ADVSEC_fnc_wantedAction";
        };
        class BtnDel: ADVSEC_BtnDanger {
            text = "$STR_ADVSEC_withdraw";
            x = 0.35; y = 0.80; w = 0.13; h = 0.05;
            action = "['del'] call ADVSEC_fnc_wantedAction";
        };
        class BtnReport: ADVSEC_Btn {
            text = "$STR_ADVSEC_open_report";
            x = 0.49; y = 0.80; w = 0.15; h = 0.05;
            action = "['report'] call ADVSEC_fnc_wantedAction";
        };
        class BtnClose: ADVSEC_Btn {
            text = "$STR_ADVSEC_close";
            x = 0.66; y = 0.80; w = 0.13; h = 0.05;
            action = "closeDialog 0";
        };
        class CloseX: ADVSEC_BtnX { x = 0.7662; y = 0.12; w = 0.0338; h = 0.045; };
    };
};

// ===== Menú de acciones policiales (sin ACE / módulo Zeus) =====
class ADVSEC_PoliceMenu {
    idd = 87100;
    movingEnable = 0;
    onLoad = "['on'] call ADVSEC_fnc_uiBlur";
    onUnload = "['off'] call ADVSEC_fnc_uiBlur";
    class controlsBackground {
        class BG: ADVSEC_Panel { x = 0.34; y = 0.22; w = 0.32; h = 0.56; };
        class Border: ADVSEC_Border { x = 0.34; y = 0.22; w = 0.32; h = 0.56; };
        class Line: ADVSEC_Line { x = 0.34; y = 0.265; w = 0.32; h = 0.003; };
    };
    class controls {
        class Title: ADVSEC_Header { idc = 87101; x = 0.34; y = 0.22; w = 0.32; h = 0.045; };
        class List: ADVSEC_List {
            idc = 87102;
            x = 0.35; y = 0.28; w = 0.30; h = 0.42;
            rowHeight = 0.045;
            onLBDblClick = "[] call ADVSEC_fnc_policeMenuExec";
        };
        class BtnOk: ADVSEC_BtnOk {
            text = "$STR_ADVSEC_execute";
            x = 0.35; y = 0.715; w = 0.145; h = 0.05;
            action = "[] call ADVSEC_fnc_policeMenuExec";
        };
        class BtnClose: ADVSEC_BtnDanger {
            text = "$STR_ADVSEC_close";
            x = 0.505; y = 0.715; w = 0.145; h = 0.05;
            action = "closeDialog 0";
        };
        class CloseX: ADVSEC_BtnX { x = 0.6262; y = 0.22; w = 0.0338; h = 0.045; };
    };
};

// ===== Panel Zeus =====
#define ZP_BTN(N,T,A,X,Y) class N: ADVSEC_Btn { text = T; x = X; y = Y; w = 0.1; h = 0.04; action = A; };
class ADVSEC_ZeusPanel {
    idd = 87000;
    movingEnable = 0;
    onLoad = "['on'] call ADVSEC_fnc_uiBlur";
    onUnload = "['off'] call ADVSEC_fnc_uiBlur";
    class controlsBackground {
        class BG: ADVSEC_Panel { x = 0.04; y = 0.03; w = 0.92; h = 0.94; };
        class Border: ADVSEC_Border { x = 0.04; y = 0.03; w = 0.92; h = 0.94; };
        class Line: ADVSEC_Line { x = 0.04; y = 0.078; w = 0.92; h = 0.003; };
        class LObj: ADVSEC_Label { text = "$STR_ADVSEC_security_objects"; font = "RobotoCondensedBold"; x = 0.05; y = 0.09; w = 0.25; h = 0.04; };
        class LPl: ADVSEC_Label { text = "$STR_ADVSEC_players_by_distance"; font = "RobotoCondensedBold"; x = 0.51; y = 0.09; w = 0.3; h = 0.04; };
        class InfoObjBG: RscText { x = 0.05; y = 0.64; w = 0.44; h = 0.12; colorBackground[] = ADVSEC_COL_FIELD; };
        class InfoObjBGBar: ADVSEC_Accent { x = 0.05; y = 0.64; w = 0.004; h = 0.12; };
        class InfoPlBG: RscText { x = 0.51; y = 0.64; w = 0.44; h = 0.12; colorBackground[] = ADVSEC_COL_FIELD; };
        class InfoPlBGBar: ADVSEC_Accent { x = 0.51; y = 0.64; w = 0.004; h = 0.12; };
    };
    class controls {
        class Title: ADVSEC_Header { text = "$STR_ADVSEC_security_panel_zeus_2"; x = 0.04; y = 0.03; w = 0.92; h = 0.048; };
        class Filter: ADVSEC_Combo {
            idc = 87014;
            x = 0.33; y = 0.09; w = 0.16; h = 0.04;
            onLBSelChanged = "['refresh'] call ADVSEC_fnc_zeusPanelAction";
        };
        class ObjList: ADVSEC_List {
            idc = 87010;
            x = 0.05; y = 0.135; w = 0.44; h = 0.495;
            onLBSelChanged = "['selObj'] call ADVSEC_fnc_zeusPanelAction";
            onLBDblClick = "['goto'] call ADVSEC_fnc_zeusPanelAction";
        };
        class PlList: ADVSEC_List {
            idc = 87012;
            x = 0.51; y = 0.135; w = 0.44; h = 0.495;
            onLBSelChanged = "['selUnit'] call ADVSEC_fnc_zeusPanelAction";
            onLBDblClick = "['gotoUnit'] call ADVSEC_fnc_zeusPanelAction";
        };
        class InfoObj: ADVSEC_Struct { idc = 87011; x = 0.055; y = 0.645; w = 0.43; h = 0.11; };
        class InfoPl: ADVSEC_Struct { idc = 87013; x = 0.515; y = 0.645; w = 0.43; h = 0.11; };

        ZP_BTN(OGo,"$STR_ADVSEC_go_to","['goto'] call ADVSEC_fnc_zeusPanelAction",0.05,0.775)
        ZP_BTN(ODoors,"$STR_ADVSEC_open_close","['doors'] call ADVSEC_fnc_zeusPanelAction",0.1633,0.775)
        ZP_BTN(OPin,"$STR_ADVSEC_change_pin_2","['pin'] call ADVSEC_fnc_zeusPanelAction",0.2766,0.775)
        ZP_BTN(OCam,"$STR_ADVSEC_view_camera","['camera'] call ADVSEC_fnc_zeusPanelAction",0.39,0.775)
        ZP_BTN(OArm,"$STR_ADVSEC_arm","['arm'] call ADVSEC_fnc_zeusPanelAction",0.05,0.82)
        ZP_BTN(ODisarm,"$STR_ADVSEC_disarm","['disarm'] call ADVSEC_fnc_zeusPanelAction",0.1633,0.82)
        ZP_BTN(OTrig,"$STR_ADVSEC_trigger_alarm","['trigger'] call ADVSEC_fnc_zeusPanelAction",0.2766,0.82)
        ZP_BTN(OSil,"$STR_ADVSEC_silence","['silence'] call ADVSEC_fnc_zeusPanelAction",0.39,0.82)

        ZP_BTN(PGo,"$STR_ADVSEC_go_to","['gotoUnit'] call ADVSEC_fnc_zeusPanelAction",0.51,0.775)
        ZP_BTN(PPolice,"$STR_ADVSEC_mp_actions","['police'] call ADVSEC_fnc_zeusPanelAction",0.6233,0.775)
        ZP_BTN(PJail,"$STR_ADVSEC_jail","['jail'] call ADVSEC_fnc_zeusPanelAction",0.7366,0.775)
        ZP_BTN(PRelease,"$STR_ADVSEC_release","['release'] call ADVSEC_fnc_zeusPanelAction",0.85,0.775)
        ZP_BTN(PMP,"$STR_ADVSEC_mp_badge","['giveMP'] call ADVSEC_fnc_zeusPanelAction",0.51,0.82)
        ZP_BTN(PIA,"$STR_ADVSEC_ia_credentials","['giveIA'] call ADVSEC_fnc_zeusPanelAction",0.6233,0.82)
        ZP_BTN(PMil,"$STR_ADVSEC_military_id_3","['giveMil'] call ADVSEC_fnc_zeusPanelAction",0.7366,0.82)
        ZP_BTN(PDocs,"$STR_ADVSEC_documents","['docs'] call ADVSEC_fnc_zeusPanelAction",0.85,0.82)
        ZP_BTN(PWant,"$STR_ADVSEC_wanted_yes_no","['wanted'] call ADVSEC_fnc_zeusPanelAction",0.51,0.865)
        ZP_BTN(PRep,"$STR_ADVSEC_log_incident","['report'] call ADVSEC_fnc_zeusPanelAction",0.6233,0.865)

        class BReports: ADVSEC_BtnPrimary {
            text = "$STR_ADVSEC_report_archive";
            x = 0.05; y = 0.915; w = 0.15; h = 0.045;
            action = "['BOTH'] call ADVSEC_fnc_repOpen";
        };
        class BWanted: ADVSEC_BtnPrimary {
            text = "$STR_ADVSEC_wanted_list";
            x = 0.21; y = 0.915; w = 0.15; h = 0.045;
            action = "[] call ADVSEC_fnc_wantedOpen";
        };
        class BRefresh: ADVSEC_Btn {
            text = "$STR_ADVSEC_refresh";
            x = 0.37; y = 0.915; w = 0.12; h = 0.045;
            action = "['refresh'] call ADVSEC_fnc_zeusPanelAction";
        };
        class BClose: ADVSEC_BtnDanger {
            text = "$STR_ADVSEC_close";
            x = 0.83; y = 0.915; w = 0.12; h = 0.045;
            action = "closeDialog 0";
        };
        class CloseX: ADVSEC_BtnX { x = 0.924; y = 0.03; w = 0.036; h = 0.048; };
    };
};

// ===== Panel genérico (evidencias, multas, consultas, sospecha, registros) =====
#define PNL_BTN(N,X) class Btn##N: ADVSEC_Btn { idc = 8751##N; x = X; y = 0.855; w = 0.145; h = 0.05; onButtonClick = "['btn', ctrlIDC (_this select 0) - 87510] call ADVSEC_fnc_panelAction"; }
class ADVSEC_PanelDlg {
    idd = 87500;
    movingEnable = 0;
    onLoad = "['on'] call ADVSEC_fnc_uiBlur";
    onUnload = "['off'] call ADVSEC_fnc_uiBlur; ADVSEC_panelKey = ''";
    class controlsBackground {
        class BG: ADVSEC_Panel { x = 0.05; y = 0.08; w = 0.90; h = 0.84; };
        class Border: ADVSEC_Border { x = 0.05; y = 0.08; w = 0.90; h = 0.84; };
        class Line: ADVSEC_Line { x = 0.05; y = 0.125; w = 0.90; h = 0.003; };
        class InfoBG: RscText { x = 0.06; y = 0.14; w = 0.88; h = 0.08; colorBackground[] = ADVSEC_COL_FIELD; };
        class InfoBar: ADVSEC_Accent { x = 0.06; y = 0.14; w = 0.004; h = 0.08; };
        class ViewBG: RscText { x = 0.47; y = 0.235; w = 0.47; h = 0.605; colorBackground[] = ADVSEC_COL_FIELD; };
    };
    class controls {
        class Title: ADVSEC_Header { idc = 87501; x = 0.05; y = 0.08; w = 0.90; h = 0.045; };
        class Info: ADVSEC_Struct { idc = 87502; x = 0.07; y = 0.145; w = 0.86; h = 0.07; };
        class List: ADVSEC_List { idc = 87503; x = 0.06; y = 0.235; w = 0.40; h = 0.605; sizeEx = 0.03; rowHeight = 0.036; onLBSelChanged = "['select'] call ADVSEC_fnc_panelAction"; onLBDblClick = "['btn', 0] call ADVSEC_fnc_panelAction"; };
        class ViewGroup: RscControlsGroup {
            idc = 87504;
            x = 0.47; y = 0.235; w = 0.47; h = 0.605;
            class controls {
                class View: ADVSEC_Struct { idc = 87505; x = 0.01; y = 0.005; w = 0.44; h = 0.59; };
            };
        };
        PNL_BTN(0,0.06);
        PNL_BTN(1,0.208);
        PNL_BTN(2,0.356);
        PNL_BTN(3,0.504);
        PNL_BTN(4,0.652);
        class BtnClose: ADVSEC_Btn { text = "$STR_ADVSEC_close"; x = 0.80; y = 0.855; w = 0.14; h = 0.05; action = "closeDialog 0"; };
        class CloseX: ADVSEC_BtnX { x = 0.9162; y = 0.08; w = 0.0338; h = 0.045; };
    };
};

// ===== Control de carretera: el agente pide la documentación =====
class ADVSEC_CpAsk {
    idd = 87600;
    movingEnable = 0;
    class controlsBackground {
        class BG: ADVSEC_Panel { x = 0.32; y = 0.3; w = 0.36; h = 0.24; };
        class Border: ADVSEC_Border { x = 0.32; y = 0.3; w = 0.36; h = 0.24; };
        class Line: ADVSEC_Line { x = 0.32; y = 0.345; w = 0.36; h = 0.003; };
        class Bar: ADVSEC_Accent { x = 0.32; y = 0.348; w = 0.004; h = 0.192; };
    };
    class controls {
        class Title: ADVSEC_Header { idc = 87601; text = "$STR_ADVSEC_police_checkpoint"; x = 0.32; y = 0.3; w = 0.36; h = 0.045; };
        class Text: ADVSEC_Struct { idc = 87602; x = 0.335; y = 0.36; w = 0.33; h = 0.11; };
        class BtnShow: ADVSEC_BtnPrimary {
            idc = 87603;
            text = "$STR_ADVSEC_show_documents";
            x = 0.335; y = 0.48; w = 0.2; h = 0.045;
            action = "['show'] call ADVSEC_fnc_cpAskAction";
        };
        class BtnRefuse: ADVSEC_BtnDanger {
            idc = 87604;
            text = "$STR_ADVSEC_refuse";
            x = 0.545; y = 0.48; w = 0.12; h = 0.045;
            action = "['refuse'] call ADVSEC_fnc_cpAskAction";
        };
    };
};

// ===== Base de datos de jugadores (Policía Militar) =====
class ADVSEC_PlayerDB {
    idd = 87700;
    movingEnable = 0;
    onLoad = "['on'] call ADVSEC_fnc_uiBlur";
    onUnload = "['off'] call ADVSEC_fnc_uiBlur";
    class controlsBackground {
        class BG: ADVSEC_Panel { x = 0.03; y = 0.04; w = 0.94; h = 0.92; };
        class Border: ADVSEC_Border { x = 0.03; y = 0.04; w = 0.94; h = 0.92; };
        class Line: ADVSEC_Line { x = 0.03; y = 0.085; w = 0.94; h = 0.003; };
        class ViewBG: RscText { x = 0.49; y = 0.10; w = 0.47; h = 0.44; colorBackground[] = ADVSEC_COL_FIELD; };
        class EditBG: RscText { x = 0.49; y = 0.555; w = 0.47; h = 0.315; colorBackground[] = ADVSEC_COL_FIELD; };
        class EditBar: ADVSEC_Accent { x = 0.49; y = 0.555; w = 0.004; h = 0.315; };
        class LSearch: ADVSEC_Label { text = "$STR_ADVSEC_search_5"; x = 0.04; y = 0.10; w = 0.07; h = 0.04; };
        class LPM: ADVSEC_Label { text = "$STR_ADVSEC_military_police_rank"; x = 0.50; y = 0.565; w = 0.16; h = 0.04; };
        class LAI: ADVSEC_Label { text = "$STR_ADVSEC_internal_affairs_rank"; x = 0.50; y = 0.615; w = 0.16; h = 0.04; };
        class LGlob: ADVSEC_Label { text = "$STR_ADVSEC_global_rank"; x = 0.50; y = 0.665; w = 0.16; h = 0.04; };
        class LNotes: ADVSEC_Label { text = "$STR_ADVSEC_notes"; x = 0.50; y = 0.715; w = 0.16; h = 0.04; };
    };
    class controls {
        class Title: ADVSEC_Header { idc = 87701; text = "$STR_ADVSEC_database_military_police"; x = 0.03; y = 0.04; w = 0.94; h = 0.045; };
        class Search: ADVSEC_Edit { idc = 87702; x = 0.10; y = 0.10; w = 0.235; h = 0.04; onKeyUp = "['filter'] call ADVSEC_fnc_pdbAction"; };
        class Filter: ADVSEC_Combo { idc = 87703; x = 0.34; y = 0.10; w = 0.14; h = 0.04; onLBSelChanged = "['filter'] call ADVSEC_fnc_pdbAction"; };
        class List: ADVSEC_List { idc = 87704; x = 0.04; y = 0.15; w = 0.44; h = 0.72; sizeEx = 0.03; rowHeight = 0.036; onLBSelChanged = "['select'] call ADVSEC_fnc_pdbAction"; };
        class ViewGroup: RscControlsGroup {
            idc = 87707;
            x = 0.49; y = 0.10; w = 0.47; h = 0.44;
            class controls {
                class View: ADVSEC_Struct { idc = 87705; x = 0.01; y = 0.005; w = 0.44; h = 0.39; };
            };
        };
        class CPM: ADVSEC_Combo { idc = 87710; x = 0.67; y = 0.565; w = 0.28; h = 0.04; };
        class CAI: ADVSEC_Combo { idc = 87711; x = 0.67; y = 0.615; w = 0.28; h = 0.04; };
        class CGlob: ADVSEC_Combo { idc = 87712; x = 0.67; y = 0.665; w = 0.28; h = 0.04; };
        class Notes: ADVSEC_EditMulti { idc = 87713; x = 0.50; y = 0.755; w = 0.45; h = 0.105; };
        class Info: ADVSEC_Struct { idc = 87706; x = 0.19; y = 0.888; w = 0.29; h = 0.045; };
        class BtnRefresh: ADVSEC_Btn { text = "$STR_ADVSEC_refresh"; x = 0.04; y = 0.885; w = 0.14; h = 0.05; action = "['refresh'] call ADVSEC_fnc_pdbAction"; };
        class BtnSave: ADVSEC_BtnPrimary { idc = 87720; text = "$STR_ADVSEC_save_changes"; x = 0.49; y = 0.885; w = 0.18; h = 0.05; action = "['save'] call ADVSEC_fnc_pdbAction"; };
        class BtnClose: ADVSEC_Btn { text = "$STR_ADVSEC_close"; x = 0.82; y = 0.885; w = 0.14; h = 0.05; action = "closeDialog 0"; };
        class CloseX: ADVSEC_BtnX { x = 0.9362; y = 0.04; w = 0.0338; h = 0.045; };
    };
};

// ===== Terminal de superadministrador =====
#define ADM_BTN(N,X) class Btn##N: ADVSEC_Btn { idc = 8781##N; x = X; y = 0.885; w = 0.15; h = 0.05; action = "['btn', N] call ADVSEC_fnc_adminAction"; };
class ADVSEC_AdminDlg {
    idd = 87800;
    movingEnable = 0;
    onLoad = "['on'] call ADVSEC_fnc_uiBlur";
    onUnload = "['off'] call ADVSEC_fnc_uiBlur";
    class controlsBackground {
        class BG: ADVSEC_Panel { x = 0.02; y = 0.04; w = 0.96; h = 0.92; };
        class Border: ADVSEC_Border { x = 0.02; y = 0.04; w = 0.96; h = 0.92; };
        class Line: ADVSEC_Line { x = 0.02; y = 0.085; w = 0.96; h = 0.003; };
        class Warn: RscText { x = 0.02; y = 0.088; w = 0.96; h = 0.004; colorBackground[] = {0.8, 0.2, 0.2, 1}; };
        class InfoBG: RscText { x = 0.20; y = 0.10; w = 0.77; h = 0.06; colorBackground[] = ADVSEC_COL_FIELD; };
        class ViewBG: RscText { x = 0.59; y = 0.17; w = 0.38; h = 0.70; colorBackground[] = ADVSEC_COL_FIELD; };
        class LCat: ADVSEC_Label { text = "$STR_ADVSEC_categories"; font = "RobotoCondensedBold"; x = 0.03; y = 0.10; w = 0.16; h = 0.04; };
    };
    class controls {
        class Title: ADVSEC_Header { idc = 87801; text = "$STR_ADVSEC_superadmin_5"; x = 0.02; y = 0.04; w = 0.96; h = 0.045; };
        class Cats: ADVSEC_List { idc = 87802; x = 0.03; y = 0.14; w = 0.16; h = 0.675; sizeEx = 0.03; rowHeight = 0.04; onLBSelChanged = "['cat'] call ADVSEC_fnc_adminAction"; };
        class Info: ADVSEC_Struct { idc = 87804; x = 0.205; y = 0.105; w = 0.76; h = 0.05; };
        class List: ADVSEC_List { idc = 87803; x = 0.20; y = 0.17; w = 0.38; h = 0.70; sizeEx = 0.028; rowHeight = 0.034; onLBSelChanged = "['select'] call ADVSEC_fnc_adminAction"; };
        class ViewGroup: RscControlsGroup {
            idc = 87806;
            x = 0.59; y = 0.17; w = 0.38; h = 0.70;
            class controls {
                class View: ADVSEC_Struct { idc = 87805; x = 0.01; y = 0.005; w = 0.35; h = 0.6; };
            };
        };
        class BtnRefresh: ADVSEC_Btn { text = "$STR_ADVSEC_refresh"; x = 0.03; y = 0.885; w = 0.16; h = 0.05; action = "['refresh'] call ADVSEC_fnc_adminAction"; };
        class BtnPlayerDB: ADVSEC_BtnPrimary { idc = 87807; text = "$STR_ADVSEC_player_db"; x = 0.03; y = 0.825; w = 0.16; h = 0.05; tooltip = "$STR_ADVSEC_full_record_of_each_player"; action = "closeDialog 0; [] spawn {sleep 0.1; [] call ADVSEC_fnc_pdbViewOpen}"; };
        ADM_BTN(0,0.20)
        ADM_BTN(1,0.355)
        ADM_BTN(2,0.51)
        ADM_BTN(3,0.665)
        ADM_BTN(4,0.82)
        class CloseX: ADVSEC_BtnX { x = 0.9462; y = 0.04; w = 0.0338; h = 0.045; };
    };
};

// ===== Base de datos de jugadores (superadministrador): ocupa casi toda la pantalla =====
#define PDB_Q(s) #s
#define PX(N) PDB_Q(safezoneX + safezoneW * (N))
#define PY(N) PDB_Q(safezoneY + safezoneH * (N))
#define PW(N) PDB_Q(safezoneW * (N))
#define PH(N) PDB_Q(safezoneH * (N))
#define PDB_TILE(N,X) \
    class TileBG##N: RscText { x = PX(X); y = PY(0.09); w = PW(0.1575); h = PH(0.07); colorBackground[] = ADVSEC_COL_FIELD; };
#define PDB_TILET(N,X) \
    class Tile##N: RscStructuredText { idc = 8786##N; x = PX(X); y = PY(0.093); w = PW(0.1575); h = PH(0.065); colorBackground[] = {0, 0, 0, 0}; };
#define PDB_TAB(N,X) \
    class Tab##N: ADVSEC_Btn { idc = 8787##N; x = PX(X); y = PY(0.235); w = PW(0.0712); h = PH(0.04); sizeEx = 0.026; onButtonClick = "['tab', (ctrlIDC (_this select 0)) - 87870] call ADVSEC_fnc_pdbViewUI"; };
#define PDB_ACT(N,X) \
    class Act##N: ADVSEC_Btn { idc = 8788##N; x = PX(X); y = PY(0.87); w = PW(0.125); h = PH(0.04); sizeEx = 0.027; onButtonClick = "['act', (ctrlIDC (_this select 0)) - 87880] call ADVSEC_fnc_pdbViewUI"; };
class ADVSEC_PlayerDBDlg {
    idd = 87850;
    movingEnable = 0;
    onLoad = "['on'] call ADVSEC_fnc_uiBlur";
    onUnload = "['off'] call ADVSEC_fnc_uiBlur";
    class controlsBackground {
        class BG: ADVSEC_Panel { x = PX(0.03); y = PY(0.03); w = PW(0.94); h = PH(0.94); };
        class Border: ADVSEC_Border { x = PX(0.03); y = PY(0.03); w = PW(0.94); h = PH(0.94); };
        class Line: ADVSEC_Line { x = PX(0.03); y = PY(0.075); w = PW(0.94); h = 0.003; };
        PDB_TILE(0,0.31)
        PDB_TILE(1,0.4775)
        PDB_TILE(2,0.645)
        PDB_TILE(3,0.8125)
        class HeadBG: RscText { x = PX(0.31); y = PY(0.17); w = PW(0.66); h = PH(0.055); colorBackground[] = ADVSEC_COL_FIELD; };
        class DetailBG: RscText { x = PX(0.31); y = PY(0.76); w = PW(0.66); h = PH(0.1); colorBackground[] = ADVSEC_COL_FIELD; };
        class LActs: ADVSEC_Label { text = "ACCIONES"; font = "RobotoCondensedBold"; x = PX(0.04); y = PY(0.87); w = PW(0.26); h = PH(0.04); };
    };
    class controls {
        class Title: ADVSEC_Header { idc = 87851; text = "$STR_ADVSEC_player_database_superadmin"; x = PX(0.03); y = PY(0.03); w = PW(0.90); h = PH(0.045); };
        class CloseX: ADVSEC_BtnX { x = PX(0.94); y = PY(0.03); w = PW(0.03); h = PH(0.045); action = "closeDialog 0"; };
        class Search: ADVSEC_Edit { idc = 87852; x = PX(0.04); y = PY(0.09); w = PW(0.26); h = PH(0.035); tooltip = "$STR_ADVSEC_search_by_name_or_steamid"; onKeyUp = "['filter'] call ADVSEC_fnc_pdbViewUI"; };
        class Mode: ADVSEC_Combo { idc = 87853; x = PX(0.04); y = PY(0.13); w = PW(0.26); h = PH(0.035); onLBSelChanged = "['filter'] call ADVSEC_fnc_pdbViewUI"; };
        class Players: ADVSEC_NBox { idc = 87859; x = PX(0.04); y = PY(0.175); w = PW(0.26); h = PH(0.685); sizeEx = 0.03; rowHeight = 0.04; onLBSelChanged = "['select'] call ADVSEC_fnc_pdbViewUI"; };
        PDB_TILET(0,0.31)
        PDB_TILET(1,0.4775)
        PDB_TILET(2,0.645)
        PDB_TILET(3,0.8125)
        class Head: ADVSEC_Struct { idc = 87864; x = PX(0.315); y = PY(0.173); w = PW(0.65); h = PH(0.05); };
        PDB_TAB(0,0.31)
        PDB_TAB(1,0.3833)
        PDB_TAB(2,0.4566)
        PDB_TAB(3,0.5299)
        PDB_TAB(4,0.6032)
        PDB_TAB(5,0.6765)
        PDB_TAB(6,0.7498)
        PDB_TAB(7,0.8231)
        PDB_TAB(8,0.8964)
        class Table: ADVSEC_NBox { idc = 87890; x = PX(0.31); y = PY(0.28); w = PW(0.66); h = PH(0.47); sizeEx = 0.03; rowHeight = 0.042; onLBSelChanged = "['row'] call ADVSEC_fnc_pdbViewUI"; };
        class DetailGroup: RscControlsGroupNoHScrollbars {
            idc = 87892;
            x = PX(0.31); y = PY(0.76); w = PW(0.66); h = PH(0.1);
            class controls {
                class Detail: ADVSEC_Struct { idc = 87891; x = 0.01; y = 0.005; w = PW(0.64); h = PH(0.09); };
            };
        };
        PDB_ACT(0,0.31)
        PDB_ACT(1,0.4433)
        PDB_ACT(2,0.5766)
        PDB_ACT(3,0.7099)
        PDB_ACT(4,0.8432)
        class BtnRefresh: ADVSEC_Btn { idc = 87897; text = "$STR_ADVSEC_refresh"; x = PX(0.04); y = PY(0.92); w = PW(0.1); h = PH(0.04); action = "['refresh'] call ADVSEC_fnc_pdbViewUI"; };
        class BtnAdmin: ADVSEC_Btn { idc = 87896; text = "$STR_ADVSEC_superadmin_terminal_4"; x = PX(0.145); y = PY(0.92); w = PW(0.155); h = PH(0.04); action = "closeDialog 0; [] spawn {sleep 0.1; [] call ADVSEC_fnc_adminOpen}"; };
        class BtnClose: ADVSEC_Btn { idc = 87898; text = "$STR_ADVSEC_close"; x = PX(0.8432); y = PY(0.92); w = PW(0.125); h = PH(0.04); action = "closeDialog 0"; };
    };
};

// ===== Tienda con selector estilo arsenal =====
#define SHOP_STAT(N,Y,YB) \
    class StatL##N: ADVSEC_Label { idc = 8794##N; x = "safezoneX + safezoneW - 0.42"; y = Y; w = 0.40; h = 0.03; }; \
    class StatB##N: ADVSEC_Bar { idc = 8795##N; x = "safezoneX + safezoneW - 0.42"; y = YB; w = 0.40; h = 0.01; };
class ADVSEC_ShopDlg {
    idd = 87900;
    movingEnable = 0;
    onUnload = "['off'] call ADVSEC_fnc_shopCam; ADVSEC_shopData = nil";
    class controlsBackground {
        class LeftBG: ADVSEC_Panel { x = "safezoneX + 0.01"; y = "safezoneY + 0.01"; w = 0.53; h = "safezoneH - 0.12"; colorBackground[] = {0.110, 0.110, 0.110, 0.92}; };
        class LeftBorder: ADVSEC_Border { x = "safezoneX + 0.01"; y = "safezoneY + 0.01"; w = 0.53; h = "safezoneH - 0.12"; };
        class LeftLine: ADVSEC_Line { x = "safezoneX + 0.01"; y = "safezoneY + 0.055"; w = 0.53; h = 0.003; };
        class RightBG: ADVSEC_Panel { x = "safezoneX + safezoneW - 0.44"; y = "safezoneY + 0.01"; w = 0.43; h = "safezoneH - 0.12"; colorBackground[] = {0.110, 0.110, 0.110, 0.92}; };
        class RightBorder: ADVSEC_Border { x = "safezoneX + safezoneW - 0.44"; y = "safezoneY + 0.01"; w = 0.43; h = "safezoneH - 0.12"; };
        class PicBG: RscText { x = "safezoneX + safezoneW - 0.43"; y = "safezoneY + 0.02"; w = 0.41; h = 0.20; colorBackground[] = ADVSEC_COL_FIELD; };
        class BottomBG: ADVSEC_Panel { x = "safezoneX + 0.01"; y = "safezoneY + safezoneH - 0.10"; w = "safezoneW - 0.02"; h = 0.09; colorBackground[] = {0.110, 0.110, 0.110, 0.92}; };
        class BottomBar: ADVSEC_Accent { x = "safezoneX + 0.01"; y = "safezoneY + safezoneH - 0.10"; w = 0.004; h = 0.09; };
        class LCompat: ADVSEC_Label { idc = 87921; text = "$STR_ADVSEC_compatible_in_this_shop"; font = "RobotoCondensedBold"; x = "safezoneX + safezoneW - 0.43"; y = "safezoneY + 0.575"; w = 0.41; h = 0.03; };
    };
    class controls {
        class Title: ADVSEC_Header { idc = 87901; x = "safezoneX + 0.01"; y = "safezoneY + 0.01"; w = 0.53; h = 0.045; };
        class Tabs: RscControlsGroupNoHScrollbars { idc = 87904; x = "safezoneX + 0.015"; y = "safezoneY + 0.065"; w = 0.065; h = "safezoneH - 0.185"; class controls {}; };
        class Search: ADVSEC_Edit { idc = 87906; x = "safezoneX + 0.085"; y = "safezoneY + 0.065"; w = 0.29; h = 0.04; tooltip = "$STR_ADVSEC_search_by_name_or_class"; onKeyUp = "['list'] call ADVSEC_fnc_shopUI"; };
        class Sort: ADVSEC_Combo { idc = 87905; x = "safezoneX + 0.38"; y = "safezoneY + 0.065"; w = 0.155; h = 0.04; onLBSelChanged = "['list'] call ADVSEC_fnc_shopUI"; };
        class Cat: ADVSEC_Label { idc = 87902; font = "RobotoCondensedBold"; colorText[] = ADVSEC_COL_ACCENT; x = "safezoneX + 0.085"; y = "safezoneY + 0.11"; w = 0.45; h = 0.035; };
        class List: ADVSEC_List { idc = 87903; x = "safezoneX + 0.085"; y = "safezoneY + 0.145"; w = 0.45; h = "safezoneH - 0.265"; sizeEx = 0.03; rowHeight = 0.05; onLBSelChanged = "['select'] call ADVSEC_fnc_shopUI"; onLBDblClick = "['buy', 1] call ADVSEC_fnc_shopUI"; };
        class Pic: RscPictureKeepAspect { idc = 87910; x = "safezoneX + safezoneW - 0.42"; y = "safezoneY + 0.03"; w = 0.39; h = 0.18; };
        class InfoGroup: RscControlsGroupNoHScrollbars {
            idc = 87919;
            x = "safezoneX + safezoneW - 0.43"; y = "safezoneY + 0.23"; w = 0.41; h = 0.19;
            class controls {
                class Info: ADVSEC_Struct { idc = 87911; x = 0; y = 0; w = 0.39; h = 0.6; };
            };
        };
        SHOP_STAT(0,"safezoneY + 0.425","safezoneY + 0.457")
        SHOP_STAT(1,"safezoneY + 0.475","safezoneY + 0.507")
        SHOP_STAT(2,"safezoneY + 0.525","safezoneY + 0.557")
        class Compat: ADVSEC_List { idc = 87920; x = "safezoneX + safezoneW - 0.43"; y = "safezoneY + 0.605"; w = 0.41; h = "safezoneH - 0.725"; sizeEx = 0.028; rowHeight = 0.042; onLBSelChanged = "['compat'] call ADVSEC_fnc_shopUI"; };
        class Money: ADVSEC_Struct { idc = 87930; x = "safezoneX + 0.025"; y = "safezoneY + safezoneH - 0.095"; w = "safezoneW - 0.72"; h = 0.08; };
        class BtnBuy: ADVSEC_BtnPrimary { idc = 87931; text = "$STR_ADVSEC_buy"; x = "safezoneX + safezoneW - 0.685"; y = "safezoneY + safezoneH - 0.08"; w = 0.13; h = 0.05; action = "['buy', 1] call ADVSEC_fnc_shopUI"; };
        class BtnBuy5: ADVSEC_Btn { idc = 87932; text = "$STR_ADVSEC_buy_5"; x = "safezoneX + safezoneW - 0.55"; y = "safezoneY + safezoneH - 0.08"; w = 0.13; h = 0.05; action = "['buy', 5] call ADVSEC_fnc_shopUI"; };
        class BtnSell: ADVSEC_Btn { idc = 87933; text = "$STR_ADVSEC_sell_one"; x = "safezoneX + safezoneW - 0.415"; y = "safezoneY + safezoneH - 0.08"; w = 0.13; h = 0.05; action = "['sell'] call ADVSEC_fnc_shopUI"; };
        class BtnWallet: ADVSEC_Btn { idc = 87934; text = "$STR_ADVSEC_my_wallet"; x = "safezoneX + safezoneW - 0.28"; y = "safezoneY + safezoneH - 0.08"; w = 0.13; h = 0.05; action = "closeDialog 0; [] spawn {sleep 0.1; [] call ADVSEC_fnc_ecoOpen}"; };
        class BtnClose: ADVSEC_Btn { text = "$STR_ADVSEC_close"; x = "safezoneX + safezoneW - 0.145"; y = "safezoneY + safezoneH - 0.08"; w = 0.12; h = 0.05; action = "closeDialog 0"; };
        class CloseX: ADVSEC_BtnX { x = "safezoneX + 0.5062"; y = "safezoneY + 0.01"; w = 0.0338; h = 0.045; };
    };
};

// ===== Cámara corporal en directo (render-to-texture) =====
class ADVSEC_BodyLive {
    idd = 88000;
    movingEnable = 0;
    onUnload = "['off'] call ADVSEC_fnc_bodyLive";
    class controlsBackground {
        class BG: ADVSEC_Panel { x = 0.02; y = 0.04; w = 0.96; h = 0.92; };
        class Border: ADVSEC_Border { x = 0.02; y = 0.04; w = 0.96; h = 0.92; };
        class Line: ADVSEC_Line { x = 0.02; y = 0.085; w = 0.96; h = 0.003; };
        class VideoBG: RscText { x = 0.26; y = 0.10; w = 0.71; h = 0.73; colorBackground[] = {0, 0, 0, 1}; };
        class LAg: ADVSEC_Label { text = "$STR_ADVSEC_officers_recording"; font = "RobotoCondensedBold"; x = 0.03; y = 0.095; w = 0.22; h = 0.035; };
    };
    class controls {
        class Title: ADVSEC_Header { idc = 88001; text = "$STR_ADVSEC_body_cameras_live"; x = 0.02; y = 0.04; w = 0.96; h = 0.045; };
        class List: ADVSEC_List { idc = 88002; x = 0.03; y = 0.13; w = 0.22; h = 0.70; sizeEx = 0.03; rowHeight = 0.04; onLBSelChanged = "['select'] call ADVSEC_fnc_bodyLive"; };
        class Video: RscPicture { idc = 88003; x = 0.26; y = 0.10; w = 0.71; h = 0.73; text = ""; };
        class Osd: ADVSEC_Struct { idc = 88004; x = 0.27; y = 0.105; w = 0.69; h = 0.05; colorBackground[] = {0, 0, 0, 0.35}; };
        class Lost: ADVSEC_Struct { idc = 88005; x = 0.26; y = 0.42; w = 0.71; h = 0.08; };
        class Info: ADVSEC_Struct { idc = 88006; x = 0.03; y = 0.845; w = 0.94; h = 0.045; };
        class BtnPrev: ADVSEC_Btn { text = "$STR_ADVSEC_previous"; x = 0.03; y = 0.895; w = 0.14; h = 0.05; action = "['step', -1] call ADVSEC_fnc_bodyLive"; };
        class BtnNext: ADVSEC_Btn { text = "$STR_ADVSEC_next"; x = 0.18; y = 0.895; w = 0.14; h = 0.05; action = "['step', 1] call ADVSEC_fnc_bodyLive"; };
        class BtnLog: ADVSEC_Btn { text = "$STR_ADVSEC_view_recording"; x = 0.33; y = 0.895; w = 0.16; h = 0.05; action = "closeDialog 0; [] spawn {sleep 0.1; [] call ADVSEC_fnc_bodyOpen}"; };
        class BtnClose: ADVSEC_Btn { text = "$STR_ADVSEC_close"; x = 0.83; y = 0.895; w = 0.14; h = 0.05; action = "closeDialog 0"; };
        class CloseX: ADVSEC_BtnX { x = 0.9462; y = 0.04; w = 0.0338; h = 0.045; };
    };
};

// ===== Selector de catálogo para tiendas y concesionarios (categoría -> objeto) =====
class ADVSEC_CatalogDlg {
    idd = 88100;
    movingEnable = 0;
    class controlsBackground {
        class BG: ADVSEC_Panel { x = 0.10; y = 0.10; w = 0.80; h = 0.80; };
        class Border: ADVSEC_Border { x = 0.10; y = 0.10; w = 0.80; h = 0.80; };
        class Line: ADVSEC_Line { x = 0.10; y = 0.145; w = 0.80; h = 0.003; };
        class LCat: ADVSEC_Label { text = "$STR_ADVSEC_1_category"; x = 0.12; y = 0.16; w = 0.36; h = 0.035; };
        class LItem: ADVSEC_Label { text = "$STR_ADVSEC_2_item_or_vehicle"; x = 0.12; y = 0.255; w = 0.36; h = 0.035; };
        class LPrice: ADVSEC_Label { text = "$STR_ADVSEC_price_2"; x = 0.12; y = 0.35; w = 0.10; h = 0.035; };
        class LList: ADVSEC_Label { text = "$STR_ADVSEC_for_sale_2"; font = "RobotoCondensedBold"; x = 0.50; y = 0.16; w = 0.38; h = 0.035; };
    };
    class controls {
        class Title: ADVSEC_Header { idc = 88101; x = 0.10; y = 0.10; w = 0.80; h = 0.045; };
        class Cat: ADVSEC_Combo { idc = 88102; x = 0.12; y = 0.195; w = 0.36; h = 0.045; onLBSelChanged = "[ctrlParent (_this select 0), 'cat'] call ADVSEC_fnc_catalogUI"; };
        class Search: ADVSEC_Edit { idc = 88106; x = 0.33; y = 0.255; w = 0.15; h = 0.035; tooltip = "$STR_ADVSEC_filter_by_name_or_class"; onKeyUp = "[ctrlParent (_this select 0), 'search'] call ADVSEC_fnc_catalogUI"; };
        class Item: ADVSEC_Combo { idc = 88103; x = 0.12; y = 0.29; w = 0.36; h = 0.045; };
        class Price: ADVSEC_Edit { idc = 88104; x = 0.22; y = 0.35; w = 0.12; h = 0.04; };
        class BtnAdd: ADVSEC_BtnPrimary { text = "$STR_ADVSEC_add_change_price"; x = 0.12; y = 0.41; w = 0.36; h = 0.05; onButtonClick = "[ctrlParent (_this select 0), 'add'] call ADVSEC_fnc_catalogUI"; };
        class Info: ADVSEC_Struct { idc = 88110; x = 0.12; y = 0.48; w = 0.36; h = 0.30; };
        class List: ADVSEC_List { idc = 88105; x = 0.50; y = 0.195; w = 0.38; h = 0.59; sizeEx = 0.03; rowHeight = 0.042; onLBSelChanged = "[ctrlParent (_this select 0), 'pick'] call ADVSEC_fnc_catalogUI"; };
        class BtnDel: ADVSEC_BtnDanger { text = "$STR_ADVSEC_remove_selected"; x = 0.50; y = 0.795; w = 0.38; h = 0.045; onButtonClick = "[ctrlParent (_this select 0), 'remove'] call ADVSEC_fnc_catalogUI"; };
        class BtnOk: ADVSEC_BtnOk { text = "$STR_ADVSEC_accept"; x = 0.58; y = 0.85; w = 0.15; h = 0.04; onButtonClick = "[ctrlParent (_this select 0), 'ok'] call ADVSEC_fnc_catalogUI"; };
        class BtnCancel: ADVSEC_BtnDanger { text = "$STR_ADVSEC_cancel_2"; x = 0.74; y = 0.85; w = 0.14; h = 0.04; onButtonClick = "[ctrlParent (_this select 0), 'cancel'] call ADVSEC_fnc_catalogUI"; };
    };
};

// ===== Radar de tráfico: panel de configuración =====
#define RDR_ROW(N,Y,LBL) class L##N: ADVSEC_Label { text = LBL; x = 0.24; y = Y; w = 0.18; h = 0.045; };
#define RDR_STEP(IDC,Y) \
    class Minus##IDC: ADVSEC_Btn { idc = 1##IDC; text = "−"; x = 0.43; y = Y; w = 0.05; h = 0.045; onButtonClick = "['step', ctrlIDC (_this select 0)] call ADVSEC_fnc_radarDlg"; }; \
    class Plus##IDC: ADVSEC_Btn { idc = 2##IDC; text = "+"; x = 0.71; y = Y; w = 0.05; h = 0.045; onButtonClick = "['step', ctrlIDC (_this select 0)] call ADVSEC_fnc_radarDlg"; }; \
    class E##IDC: ADVSEC_Edit { idc = IDC; x = 0.485; y = Y; w = 0.22; h = 0.045; style = 2; };
class ADVSEC_RadarDlg {
    idd = 88200;
    movingEnable = 0;
    onUnload = "['off'] call ADVSEC_fnc_radarDlg";
    class controlsBackground {
        class BG: ADVSEC_Panel { x = 0.22; y = 0.10; w = 0.56; h = 0.80; };
        class Border: ADVSEC_Border { x = 0.22; y = 0.10; w = 0.56; h = 0.80; };
        class Line: ADVSEC_Line { x = 0.22; y = 0.145; w = 0.56; h = 0.003; };
        class Lcd: RscText { x = 0.24; y = 0.16; w = 0.52; h = 0.15; colorBackground[] = {0.02, 0.05, 0.02, 1}; };
        class LcdBar: ADVSEC_Accent { x = 0.24; y = 0.16; w = 0.004; h = 0.15; };
        RDR_ROW(1,0.325,"$STR_ADVSEC_name")
        RDR_ROW(2,0.38,"$STR_ADVSEC_limit_km_h")
        RDR_ROW(3,0.435,"$STR_ADVSEC_range_m")
        RDR_ROW(4,0.49,"$STR_ADVSEC_base_fine")
        RDR_ROW(5,0.545,"$STR_ADVSEC_fine_per_km_h_over")
        RDR_ROW(6,0.60,"$STR_ADVSEC_direction")
        RDR_ROW(7,0.655,"$STR_ADVSEC_status")
        RDR_ROW(8,0.71,"$STR_ADVSEC_mp_on_duty")
    };
    class controls {
        class Title: ADVSEC_Header { idc = 88201; x = 0.22; y = 0.10; w = 0.56; h = 0.045; };
        class Read: ADVSEC_Struct { idc = 88202; x = 0.25; y = 0.165; w = 0.50; h = 0.14; };
        class Name: ADVSEC_Edit { idc = 88210; x = 0.43; y = 0.325; w = 0.33; h = 0.045; };
        RDR_STEP(88211,0.38)
        RDR_STEP(88212,0.435)
        RDR_STEP(88213,0.49)
        RDR_STEP(88214,0.545)
        class Mode: ADVSEC_Combo { idc = 88215; x = 0.43; y = 0.60; w = 0.33; h = 0.045; };
        class On: ADVSEC_Combo { idc = 88216; x = 0.43; y = 0.655; w = 0.33; h = 0.045; };
        class Exempt: ADVSEC_Combo { idc = 88217; x = 0.43; y = 0.71; w = 0.33; h = 0.045; };
        class Info: ADVSEC_Struct { idc = 88203; x = 0.24; y = 0.77; w = 0.52; h = 0.05; };
        class BtnSave: ADVSEC_BtnPrimary { text = "$STR_ADVSEC_save"; x = 0.24; y = 0.835; w = 0.125; h = 0.045; action = "['save'] call ADVSEC_fnc_radarDlg"; };
        class BtnLog: ADVSEC_Btn { text = "$STR_ADVSEC_captures"; x = 0.372; y = 0.835; w = 0.125; h = 0.045; action = "['log'] call ADVSEC_fnc_radarDlg"; };
        class BtnPick: ADVSEC_Btn { idc = 88221; text = "$STR_ADVSEC_collect"; x = 0.504; y = 0.835; w = 0.125; h = 0.045; action = "['pickup'] call ADVSEC_fnc_radarDlg"; };
        class BtnClose: ADVSEC_Btn { text = "$STR_ADVSEC_close"; x = 0.636; y = 0.835; w = 0.124; h = 0.045; action = "closeDialog 0"; };
        class CloseX: ADVSEC_BtnX { x = 0.7462; y = 0.10; w = 0.0338; h = 0.045; };
    };
};
