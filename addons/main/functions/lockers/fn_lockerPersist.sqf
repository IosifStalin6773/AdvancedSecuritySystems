/*
    (servidor) Guarda las taquillas TS_Lockers colocadas con Zeus y las vuelve a crear al reiniciar.
    Hace falta en Antistasi, cuya partida guardada no conserva los objetos de Zeus.
    lockerPersist: 0 nunca, 1 siempre, 2 solo en Antistasi.
*/
if (!isServer || {!isClass (configFile >> "CfgPatches" >> "TS_Lockers")}) exitWith {};
private _mode = ["lockerPersist", 2] call ADVSEC_fnc_setting;
if (_mode isEqualTo 0 || {_mode isEqualTo 2 && {!([] call ADVSEC_fnc_isA3A)}}) exitWith {};
if (isNil "ADVSEC_repKey") then {[] call ADVSEC_fnc_repLoad};
private _key = format ["%1_lockers_%2", ADVSEC_repKey, toLower worldName];
// Recrea las que falten (una taquilla del mismo tipo a menos de 0,5 m cuenta como existente)
{
    _x params ["_type", "_pos", "_dir", "_up"];
    if (isClass (configFile >> "CfgVehicles" >> _type) && {((allMissionObjects _type) findIf {((getPosWorld _x) distance _pos) < 0.5}) < 0}) then {
        private _l = createVehicle [_type, [0, 0, 0], [], 0, "CAN_COLLIDE"];
        _l setPosWorld _pos;
        _l setVectorDirAndUp [_dir, _up];
    };
} forEach (profileNamespace getVariable [_key, []]);
[_key] spawn {
    params ["_key"];
    private _last = profileNamespace getVariable [_key, []];
    while {true} do {
        sleep 30;
        private _now = (allMissionObjects "Land_TS_Locker_F") apply {[typeOf _x, (getPosWorld _x) apply {round (_x * 100) / 100}, vectorDir _x, vectorUp _x]};
        if (_now isNotEqualTo _last) then {
            _last = _now;
            profileNamespace setVariable [_key, _now];
            ["lockers"] call ADVSEC_fnc_dbDirty;
        };
    };
};
