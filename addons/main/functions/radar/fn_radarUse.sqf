// Radar de velocidad (PM): mide el vehículo apuntado y ofrece multa directa si supera el límite
private _v = cursorObject;
if (isNull _v || {!(_v isKindOf "LandVehicle")} || {(player distance _v) > 300}) exitWith {hint ("STR_ADVSEC_aim_at_a_land_vehicle" call ADVSEC_fnc_L)};
private _s = round abs speed _v;
private _lim = ["speedLimit", 90] call ADVSEC_fnc_setting;
if (_s <= _lim) exitWith {hint parseText format [("STR_ADVSEC_km_hlimit_km_h_ok" call ADVSEC_fnc_L), _s, _lim]};
hint parseText format [("STR_ADVSEC_km_hlimit_km_h_plate" call ADVSEC_fnc_L), _s, _lim, getPlateNumber _v];
[("STR_ADVSEC_speeding_2" call ADVSEC_fnc_L) + str _s + " km/h", [[("STR_ADVSEC_fine_the_driver" call ADVSEC_fnc_L), true, "bool"]], {
    params ["_r", "_v"];
    if (_r select 0) then {["radar", player, [_v]] remoteExecCall ["ADVSEC_fnc_fineServer", 2]};
}, _v] call ADVSEC_fnc_zeusPrompt;
