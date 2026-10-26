// Atributo de Eden: botón que abre el selector de catálogo (categoría -> objeto) en vez de escribir «clase:precio»
class ctrlButton;
class Cfg3DEN {
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
                    text = "Elegir del catálogo";
                    onButtonClick = "['edit', _this select 0] call ADVSEC_fnc_catalogAttr";
                };
            };
        };
        class ADVSEC_CatalogVehicles: ADVSEC_CatalogItems {
            attributeLoad = "private _b = _this controlsGroupCtrl 100; _b setVariable ['ADVSEC_val', [_value, ''] select !(_value isEqualType '')]; _b setVariable ['ADVSEC_kind', 'vehicles']; ['label', _b] call ADVSEC_fnc_catalogAttr";
        };
    };
};
