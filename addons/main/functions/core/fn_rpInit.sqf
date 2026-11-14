// (servidor) Sistemas de rol: cierre de turno al desconectar y carga de bases de datos
if (!isServer) exitWith {};
{call _x} forEach [ADVSEC_fnc_specDB, ADVSEC_fnc_dutyDB, ADVSEC_fnc_plateDB, ADVSEC_fnc_wpnDB, ADVSEC_fnc_bodyDB, ADVSEC_fnc_patrolDB];
["check"] call ADVSEC_fnc_susServer;
// PMC: armería corporativa, contratos, células, daños colaterales y bucle del servidor
[] call ADVSEC_fnc_armDB;
[] call ADVSEC_fnc_ctrDB;
[] call ADVSEC_fnc_cellDB;
["init"] call ADVSEC_fnc_ctrDamage;
[] call ADVSEC_fnc_pmcLoop;
[] call ADVSEC_fnc_trafficLoop;
[] call ADVSEC_fnc_evDecayLoop;
// Taquillas TS_Lockers colocadas con Zeus: se guardan y se recrean (Antistasi no conserva los objetos de Zeus)
[] call ADVSEC_fnc_lockerPersist;
// Radares: toda cámara cwa_Kamera (speedCamClass) colocada en la misión funciona como radar fijo (speedCamAuto)
if ((["speedCamAuto", 1] call ADVSEC_fnc_setting) isEqualTo 1) then {
    private _c = ["speedCamClass", "cwa_Kamera"] call ADVSEC_fnc_setting;
    if (isClass (configFile >> "CfgVehicles" >> _c)) then {
        {
            if (isNil {_x getVariable "ADVSEC_speedCam"}) then {[_x, "Radar"] remoteExecCall ["ADVSEC_fnc_speedCamInit", 0, format ["ADVSEC_fnc_speedCamInit_%1", netId _x]]};
        } forEach (allMissionObjects _c);
    };
};
addMissionEventHandler ["HandleDisconnect", {
    params ["_u"];
    ["disconnect", _u] call ADVSEC_fnc_armServer;
    if (_u getVariable ["ADVSEC_onDuty", false]) then {[_u, false] call ADVSEC_fnc_dutySet};
    private _dog = _u getVariable ["ADVSEC_k9", objNull];
    if (!isNull _dog) then {deleteVehicle _dog};
    false
}];
