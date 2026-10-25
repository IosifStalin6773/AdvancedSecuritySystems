// (servidor) Sistemas de rol: cierre de turno al desconectar y carga de bases de datos
if (!isServer) exitWith {};
{call _x} forEach [ADVSEC_fnc_specDB, ADVSEC_fnc_dutyDB, ADVSEC_fnc_plateDB, ADVSEC_fnc_wpnDB, ADVSEC_fnc_bodyDB];
["check"] call ADVSEC_fnc_susServer;
addMissionEventHandler ["HandleDisconnect", {
    params ["_u"];
    if (_u getVariable ["ADVSEC_onDuty", false]) then {[_u, false] call ADVSEC_fnc_dutySet};
    private _dog = _u getVariable ["ADVSEC_k9", objNull];
    if (!isNull _dog) then {deleteVehicle _dog};
    false
}];
