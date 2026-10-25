// Radar de velocidad (PM): mide el vehículo apuntado y ofrece multa directa si supera el límite
private _v = cursorObject;
if (isNull _v || {!(_v isKindOf "LandVehicle")} || {(player distance _v) > 300}) exitWith {hint "Apunta a un vehículo terrestre (hasta 300 m)."};
private _s = round abs speed _v;
private _lim = ["speedLimit", 90] call ADVSEC_fnc_setting;
if (_s <= _lim) exitWith {hint parseText format ["<t size='1.6' font='RobotoCondensedBold'>%1 km/h</t><br/>Límite %2 km/h · <t color='#66FF66'>correcto</t>", _s, _lim]};
hint parseText format ["<t size='1.6' font='RobotoCondensedBold' color='#FF4D4D'>%1 km/h</t><br/>Límite %2 km/h · matrícula %3", _s, _lim, getPlateNumber _v];
["EXCESO DE VELOCIDAD: " + str _s + " km/h", [["Multar al conductor", true, "bool"]], {
    params ["_r", "_v"];
    if (_r select 0) then {["radar", player, [_v]] remoteExecCall ["ADVSEC_fnc_fineServer", 2]};
}, _v] call ADVSEC_fnc_zeusPrompt;
