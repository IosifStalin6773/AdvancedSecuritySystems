// [tienda] — abre la tienda con el selector estilo arsenal
params ["_shop"];
if !([] call ADVSEC_fnc_ecoOn) exitWith {hint ("STR_ADVSEC_the_advsec_economy_is_disabled" call ADVSEC_fnc_L)};
if (!createDialog "ADVSEC_ShopDlg") exitWith {};
ADVSEC_ecoShop = _shop;
ADVSEC_shopData = nil;
ADVSEC_shopTab = 0;
ADVSEC_shopSel = "";
private _d = findDisplay 87900;
(_d displayCtrl 87901) ctrlSetText (" " + toUpper ((_shop getVariable ["ADVSEC_shop", [("STR_ADVSEC_shop" call ADVSEC_fnc_L)]]) select 0));
(_d displayCtrl 87930) ctrlSetStructuredText parseText ("STR_ADVSEC_loading_catalog" call ADVSEC_fnc_L);
private _sort = _d displayCtrl 87905;
{_sort lbAdd _x} forEach [("STR_ADVSEC_sort_name" call ADVSEC_fnc_L), ("STR_ADVSEC_price_lowest_first" call ADVSEC_fnc_L), ("STR_ADVSEC_price_highest_first" call ADVSEC_fnc_L)];
_sort lbSetCurSel 0;
// Cámara orbital: arrastrar con el botón izquierdo en el centro y rueda para acercar
_d displayAddEventHandler ["MouseButtonDown", {params ["", "_b"]; if (_b == 0) then {["down"] call ADVSEC_fnc_shopCam}}];
_d displayAddEventHandler ["MouseButtonUp", {["up"] call ADVSEC_fnc_shopCam}];
_d displayAddEventHandler ["MouseZChanged", {params ["", "_z"]; ["wheel", _z] call ADVSEC_fnc_shopCam}];
["on"] call ADVSEC_fnc_shopCam;
["shopData", player, [_shop]] remoteExecCall ["ADVSEC_fnc_ecoServer", 2];
