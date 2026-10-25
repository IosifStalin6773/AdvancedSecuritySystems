// [nombre, artículos, factorVenta, efectivo, banco, moneda, ilegal] — catálogo enviado por el servidor
params ["_name", "_items", "_sellF", "_cash", "_bank", "_cur", "_ill"];
if (isNull findDisplay 87900) exitWith {};
private _first = isNil "ADVSEC_shopData";
ADVSEC_shopData = _this;
[["refresh", "init"] select _first] call ADVSEC_fnc_shopUI;
