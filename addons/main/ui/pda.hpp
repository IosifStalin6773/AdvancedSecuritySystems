class RscControlsGroupNoScrollbars;

#define PDA_TILE(N,X,Y) \
    class TileBG##N: RscText { idc = 8726##N; x = UIF(X); y = UIH(Y); w = UIF(0.30); h = UIH(0.17); colorBackground[] = ADVSEC_COL_BTN; }; \
    class TileBar##N: ADVSEC_Accent { x = UIF(X); y = UIH(Y); w = UIF(0.004); h = UIH(0.17); }; \
    class TileIc##N: RscPicture { idc = 8727##N; x = UIF(X + 0.125); y = UIH(Y + 0.025); w = UIF(0.05); h = UIH(0.066); colorText[] = ADVSEC_COL_ACCENT; }; \
    class TileLbl##N: RscText { idc = 8728##N; style = 2; x = UIF(X); y = UIH(Y + 0.105); w = UIF(0.30); h = UIH(0.045); font = "RobotoCondensedBold"; sizeEx = UIT(0.034); colorText[] = ADVSEC_COL_TEXT; shadow = 0; }; \
    class TileBtn##N: ADVSEC_Btn { idc = 8729##N; x = UIF(X); y = UIH(Y); w = UIF(0.30); h = UIH(0.17); colorBackground[] = {0, 0, 0, 0}; colorBackgroundActive[] = {1, 1, 1, 0.07}; colorFocused[] = {0, 0, 0, 0}; onButtonClick = "['tile', ctrlIDC (_this select 0) - 87290] call ADVSEC_fnc_pdaAction"; }

#define PDA_TAB(N,X) \
    class Tab##N: ADVSEC_Btn { idc = 8721##N; x = UIXA(X); y = UIY(0.08); w = UIF(0.14); h = UIH(0.045); colorBackground[] = {0, 0, 0, 0}; onButtonClick = "['tab', ctrlIDC (_this select 0) - 87210] call ADVSEC_fnc_pdaAction"; }

class ADVSEC_PDA {
    idd = 87200;
    movingEnable = 0;
    onLoad = "['on'] call ADVSEC_fnc_uiBlur";
    onUnload = "['off'] call ADVSEC_fnc_uiBlur; ADVSEC_pdaOpen = false";
    onKeyDown = "_this call ADVSEC_fnc_pdaKey";
    class controlsBackground {
        class Screen: RscText { x = UIXA(0.02); y = UIY(0.04); w = UIF(0.96); h = UIH(0.92); colorBackground[] = {0.086, 0.090, 0.086, 1}; };
        class StatusBG: RscText { x = UIXA(0.02); y = UIY(0.04); w = UIF(0.96); h = UIH(0.035); colorBackground[] = ADVSEC_COL_DARK; };
        class TabLine: ADVSEC_Line { x = UIXA(0.02); y = UIY(0.128); w = UIF(0.96); h = UIH(0.002); };
    };
    class controls {
        class Title: ADVSEC_Label { idc = 87201; x = UIXA(0.03); y = UIY(0.04); w = UIF(0.6); h = UIH(0.035); sizeEx = UIT(0.028); colorText[] = ADVSEC_COL_TEXTD; };
        class Clock: ADVSEC_Label { idc = 87202; style = 1; x = UIXA(0.62); y = UIY(0.04); w = UIF(0.35); h = UIH(0.035); sizeEx = UIT(0.028); colorText[] = ADVSEC_COL_TEXTD; };
        PDA_TAB(0,0.03);
        PDA_TAB(1,0.175);
        PDA_TAB(2,0.32);
        PDA_TAB(3,0.465);
        class TabMark: ADVSEC_Accent { idc = 87219; x = UIXA(0.03); y = UIY(0.124); w = UIF(0.14); h = UIH(0.004); };
        class CloseX: ADVSEC_BtnX { x = UIXA(0.935); y = UIY(0.08); w = UIF(0.04); h = UIH(0.045); colorBackground[] = {0, 0, 0, 0}; };

        class Home: RscControlsGroupNoScrollbars {
            idc = 87230;
            x = UIXA(0.02); y = UIY(0.135); w = UIF(0.96); h = UIH(0.82);
            class controls {
                class WelcomeBG: RscText { x = UIF(0.01); y = UIH(0.01); w = UIF(0.94); h = UIH(0.13); colorBackground[] = ADVSEC_COL_FIELD; };
                class WelcomeBar: ADVSEC_Accent { x = UIF(0.01); y = UIH(0.01); w = UIF(0.004); h = UIH(0.13); };
                class Welcome: ADVSEC_Struct { idc = 87231; x = UIF(0.025); y = UIH(0.015); w = UIF(0.92); h = UIH(0.12); };
                PDA_TILE(0,0.01,0.16);
                PDA_TILE(1,0.33,0.16);
                PDA_TILE(2,0.65,0.16);
                PDA_TILE(3,0.01,0.35);
                PDA_TILE(4,0.33,0.35);
                PDA_TILE(5,0.65,0.35);
                class StatsBG: RscText { x = UIF(0.01); y = UIH(0.54); w = UIF(0.94); h = UIH(0.27); colorBackground[] = ADVSEC_COL_FIELD; };
                class Stats: ADVSEC_Struct { idc = 87232; x = UIF(0.025); y = UIH(0.55); w = UIF(0.92); h = UIH(0.25); };
            };
        };

        class ListPage: RscControlsGroupNoScrollbars {
            idc = 87240;
            x = UIXA(0.02); y = UIY(0.135); w = UIF(0.96); h = UIH(0.82);
            class controls {
                class Search: ADVSEC_Edit { idc = 86611; x = UIF(0.01); y = UIH(0.01); w = UIF(0.25); h = UIH(0.04); tooltip = "$STR_ADVSEC_search_by_id_name_steamid"; };
                class BtnSearch: ADVSEC_BtnPrimary { text = "$STR_ADVSEC_search_5"; x = UIF(0.265); y = UIH(0.01); w = UIF(0.085); h = UIH(0.04); action = "['refresh'] call ADVSEC_fnc_repAction"; };
                class Count: ADVSEC_Label { idc = 87241; x = UIF(0.01); y = UIH(0.055); w = UIF(0.34); h = UIH(0.035); sizeEx = UIT(0.027); };
                class List: ADVSEC_List { idc = 86602; x = UIF(0.01); y = UIH(0.09); w = UIF(0.34); h = UIH(0.64); sizeEx = UIT(0.027); rowHeight = UIT(0.034); onLBSelChanged = "['select'] call ADVSEC_fnc_repAction"; };
                class ViewBG: RscText { x = UIF(0.36); y = UIH(0.01); w = UIF(0.59); h = UIH(0.72); colorBackground[] = ADVSEC_COL_FIELD; };
                class ViewBar: ADVSEC_Accent { x = UIF(0.36); y = UIH(0.01); w = UIF(0.004); h = UIH(0.72); };
                class ViewGroup: RscControlsGroup {
                    idc = 86620;
                    x = UIF(0.36); y = UIH(0.01); w = UIF(0.59); h = UIH(0.72);
                    class controls {
                        class View: ADVSEC_Struct { idc = 86603; x = UIF(0.01); y = UIH(0.005); w = UIF(0.56); h = UIH(0.71); };
                    };
                };
                class BtnNew: ADVSEC_BtnPrimary { idc = 87250; text = "$STR_ADVSEC_new"; x = UIF(0.01); y = UIH(0.75); w = UIF(0.14); h = UIH(0.05); action = "['new'] call ADVSEC_fnc_pdaAction"; };
                class BtnNote: ADVSEC_Btn { text = "$STR_ADVSEC_note_3"; x = UIF(0.16); y = UIH(0.75); w = UIF(0.13); h = UIH(0.05); action = "['note'] call ADVSEC_fnc_repAction"; };
                class BtnStatus: ADVSEC_Btn { text = "$STR_ADVSEC_status_sanction_2"; x = UIF(0.30); y = UIH(0.75); w = UIF(0.15); h = UIH(0.05); action = "['status'] call ADVSEC_fnc_repAction"; };
                class BtnCtx: ADVSEC_Btn { idc = 87253; x = UIF(0.46); y = UIH(0.75); w = UIF(0.19); h = UIH(0.05); colorText[] = ADVSEC_COL_ACCENT; action = "['context'] call ADVSEC_fnc_pdaAction"; };
                class BtnRefresh: ADVSEC_Btn { text = "$STR_ADVSEC_refresh"; x = UIF(0.84); y = UIH(0.75); w = UIF(0.11); h = UIH(0.05); action = "['refresh'] call ADVSEC_fnc_repAction"; };
            };
        };

        class Frame: RscPicture { idc = 87299; x = UIXA(-0.06); y = UIY(-0.09); w = UIF(1.12); h = UIH(1.16); text = ""; };
    };
};
