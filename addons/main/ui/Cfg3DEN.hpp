// Barra superior de Eden (1.21.1): menú «ADVSEC» con el gestor de la misión (todo lo que hay; elegir qué editar)
class ctrlMenuStrip;
class display3DEN {
    class Controls {
        class MenuStrip: ctrlMenuStrip {
            class Items {
                items[] += {"ADVSEC_Menu"};
                class ADVSEC_Menu {
                    text = "ADVSEC";
                    items[] = {"ADVSEC_MenuManager", "ADVSEC_MenuDialogSel"};
                };
                class ADVSEC_MenuManager {
                    text = "$STR_ADVSEC_man_menu";
                    picture = "\A3\ui_f\data\igui\cfg\simpleTasks\types\documents_ca.paa";
                    action = "['open'] call ADVSEC_fnc_dlgManager";
                };
                class ADVSEC_MenuDialogSel {
                    text = "$STR_ADVSEC_man_menu_sel";
                    picture = "\A3\ui_f\data\igui\cfg\simpleTasks\types\talk_ca.paa";
                    action = "private _s = (get3DENSelected 'object') param [0, objNull]; if (isNull _s) then {['open'] call ADVSEC_fnc_dlgManager} else {['open', [controlNull, _s, findDisplay 313]] call ADVSEC_fnc_dlgEditor}";
                };
            };
        };
    };
};
// Atributo de Eden: botón que abre el selector de catálogo (categoría -> objeto) en vez de escribir «clase:precio»
class ctrlButton;
class Cfg3DEN {
    // 1.21: sección «Diálogo (ADVSEC)» en los atributos de cualquier objeto o unidad de Eden
    class Object {
        class AttributeCategories {
            class ADVSEC_DialogCat {
                displayName = "$STR_ADVSEC_dlg_cat";
                collapsed = 1;
                class Attributes {
                    class ADVSEC_Dialog {
                        displayName = "$STR_ADVSEC_dlg_attr";
                        tooltip = "$STR_ADVSEC_dlg_attr_tip";
                        property = "ADVSEC_Dialog";
                        control = "ADVSEC_DialogGraph";
                        expression = "if (_value isEqualType '' && {_value != ''}) then {[_this, _value] call ADVSEC_fnc_dlgAttach}";
                        defaultValue = "''";
                        typeName = "STRING";
                        condition = "1";
                    };
                };
            };
        };
    };
    class Attributes {
        class Default;
        class Title: Default {
            class Controls {
                class Title;
            };
        };
        class ADVSEC_CatalogItems: Title {
            attributeLoad = "private _b = _this controlsGroupCtrl 100; _b setVariable ['ADVSEC_val', [_value, ''] select !(_value isEqualType '')]; _b setVariable ['ADVSEC_kind', 'items']; ['label', _b] call ADVSEC_fnc_catalogAttr";
            attributeSave = "(_this controlsGroupCtrl 100) getVariable ['ADVSEC_val', '']";
            h = "5 * (pixelH * pixelGrid * 0.50)";
            class Controls: Controls {
                class Title: Title {};
                class Value: ctrlButton {
                    idc = 100;
                    x = "48 * (pixelW * pixelGrid * 0.50)";
                    w = "82 * (pixelW * pixelGrid * 0.50)";
                    h = "5 * (pixelH * pixelGrid * 0.50)";
                    text = "$STR_ADVSEC_choose_from_catalog_2";
                    onButtonClick = "['edit', _this select 0] call ADVSEC_fnc_catalogAttr";
                };
            };
        };
        // Diálogo por nodos (1.21): botón que abre el editor visual
        class ADVSEC_DialogGraph: ADVSEC_CatalogItems {
            attributeLoad = "private _b = _this controlsGroupCtrl 100; _b setVariable ['ADVSEC_val', [_value, ''] select !(_value isEqualType '')]; ['label', _b] call ADVSEC_fnc_dlgAttr";
            attributeSave = "(_this controlsGroupCtrl 100) getVariable ['ADVSEC_val', '']";
            class Controls: Controls {
                class Title: Title {};
                class Value: Value {
                    text = "$STR_ADVSEC_dlg_attr_none";
                    onButtonClick = "['edit', _this select 0] call ADVSEC_fnc_dlgAttr";
                };
            };
        };
        class ADVSEC_CatalogUnits: ADVSEC_CatalogItems {
            attributeLoad = "private _b = _this controlsGroupCtrl 100; _b setVariable ['ADVSEC_val', [_value, ''] select !(_value isEqualType '')]; _b setVariable ['ADVSEC_kind', 'units']; ['label', _b] call ADVSEC_fnc_catalogAttr";
        };
        class ADVSEC_CatalogVehicles: ADVSEC_CatalogItems {
            attributeLoad = "private _b = _this controlsGroupCtrl 100; _b setVariable ['ADVSEC_val', [_value, ''] select !(_value isEqualType '')]; _b setVariable ['ADVSEC_kind', 'vehicles']; ['label', _b] call ADVSEC_fnc_catalogAttr";
        };
    };
};
