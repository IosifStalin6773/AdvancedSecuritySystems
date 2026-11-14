// (cliente, PM) Escolta de convoy: elegir vehículos cercanos y marcar el destino en el mapa
if !([player, "patrolPlan"] call ADVSEC_fnc_perm) exitWith {hint ("STR_ADVSEC_you_are_not_allowed_to" call ADVSEC_fnc_L)};
private _near = (nearestObjects [player, ["Car", "Truck", "Tank", "Motorcycle"], 60]) select {alive _x};
if (_near isEqualTo []) exitWith {hint ("STR_ADVSEC_m_convoy_novehs" call ADVSEC_fnc_L)};
private _opts = _near apply {[format ["%1 · %2 m", getText (configOf _x >> "displayName"), round (player distance _x)], netId _x]};
[("STR_ADVSEC_m_convoy_new" call ADVSEC_fnc_L), [
    [("STR_ADVSEC_name" call ADVSEC_fnc_L), ""],
    [("STR_ADVSEC_m_convoy_vehs" call ADVSEC_fnc_L), [], ["multi", _opts]]
], {
    params ["_v"];
    _v params ["_name", "_nets"];
    if (_nets isEqualTo []) exitWith {hint ("STR_ADVSEC_m_convoy_novehs" call ADVSEC_fnc_L)};
    [_name, _nets] spawn {
        params ["_name", "_nets"];
        hint ("STR_ADVSEC_m_convoy_click" call ADVSEC_fnc_L);
        openMap true;
        ADVSEC_convoyDest = nil;
        private _eh = addMissionEventHandler ["MapSingleClick", {
            params ["", "_pos"];
            ADVSEC_convoyDest = _pos;
        }];
        waitUntil {sleep 0.2; !isNil "ADVSEC_convoyDest" || {!visibleMap}};
        removeMissionEventHandler ["MapSingleClick", _eh];
        openMap false;
        if (isNil "ADVSEC_convoyDest") exitWith {};
        ["convoy", player, [_nets, ADVSEC_convoyDest, _name]] remoteExecCall ["ADVSEC_fnc_trafficServer", 2];
    };
}] call ADVSEC_fnc_zeusPrompt;
