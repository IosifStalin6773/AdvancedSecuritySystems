// [tienda] — abre la tienda con el selector estilo arsenal
params ["_shop"];
if !([] call ADVSEC_fnc_ecoOn) exitWith {hint "La economía de ADVSEC está desactivada en esta misión."};
if (!createDialog "ADVSEC_ShopDlg") exitWith {};
ADVSEC_ecoShop = _shop;
ADVSEC_shopData = nil;
ADVSEC_shopTab = 0;
ADVSEC_shopSel = "";
private _d = findDisplay 87900;
(_d displayCtrl 87901) ctrlSetText (" " + toUpper ((_shop getVariable ["ADVSEC_shop", ["Tienda"]]) select 0));
(_d displayCtrl 87930) ctrlSetStructuredText parseText "<t color='#8C8C8C'>Cargando catálogo...</t>";
private _sort = _d displayCtrl 87905;
{_sort lbAdd _x} forEach ["Ordenar: nombre", "Precio: menor primero", "Precio: mayor primero"];
_sort lbSetCurSel 0;
// Cámara orbital: arrastrar con el botón izquierdo en el centro y rueda para acercar
_d displayAddEventHandler ["MouseButtonDown", {params ["", "_b"]; if (_b == 0) then {["down"] call ADVSEC_fnc_shopCam}}];
_d displayAddEventHandler ["MouseButtonUp", {["up"] call ADVSEC_fnc_shopCam}];
_d displayAddEventHandler ["MouseZChanged", {params ["", "_z"]; ["wheel", _z] call ADVSEC_fnc_shopCam}];
["on"] call ADVSEC_fnc_shopCam;
["shopData", player, [_shop]] remoteExecCall ["ADVSEC_fnc_ecoServer", 2];
