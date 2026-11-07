// [idContrato, posición, nombreVIP] (cliente CP/QRF) Marca local con la posición en vivo del VIP; posición [] la borra
params ["_id", "_pos", ["_name", "VIP"]];
private _m = "ADVSEC_vip_" + _id;
if (_pos isEqualTo []) exitWith {deleteMarkerLocal _m};
if (markerType _m isEqualTo "") then {
    createMarkerLocal [_m, _pos];
    _m setMarkerTypeLocal "mil_objective";
    _m setMarkerColorLocal "ColorOrange";
};
_m setMarkerPosLocal _pos;
_m setMarkerTextLocal format ["VIP %1 · %2", _id, _name];
