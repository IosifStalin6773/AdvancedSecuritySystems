// (cliente) Depósito de vehículos: los propios (o todos, con permiso de tráfico), con pago y recuperación
private _b = [
    [("STR_ADVSEC_m_imp_payBtn" call ADVSEC_fnc_L), {
        params ["_plate"];
        if (isNil "_plate") exitWith {};
        ["impoundPay", player, [_plate]] remoteExecCall ["ADVSEC_fnc_trafficServer", 2];
        [] spawn {sleep 0.6; ["refresh"] call ADVSEC_fnc_panelAction};
    }],
    [("STR_ADVSEC_refresh" call ADVSEC_fnc_L), {["refresh"] call ADVSEC_fnc_panelAction}]
];
["impound", ("STR_ADVSEC_m_imp_title" call ADVSEC_fnc_L), _b, {["impound", player] remoteExecCall ["ADVSEC_fnc_trafficServer", 2]}] call ADVSEC_fnc_panelOpen;
