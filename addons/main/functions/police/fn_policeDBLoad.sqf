// Servidor: carga detenidos y buscados (misma clave de perfil que los informes, persisten entre misiones)
if (!isServer) exitWith {};
if (isNil "ADVSEC_repKey") then {[] call ADVSEC_fnc_repLoad};
ADVSEC_jailDB = createHashMapFromArray (profileNamespace getVariable [ADVSEC_repKey + "_jail", []]);
ADVSEC_wantedDB = createHashMapFromArray (profileNamespace getVariable [ADVSEC_repKey + "_wanted", []]);
["wanted"] call ADVSEC_fnc_policeDBSave;

addMissionEventHandler ["HandleDisconnect", {
    params ["_unit", "", "_uid"];
    private _until = _unit getVariable ["ADVSEC_jailUntil", 0];
    if (_until > 0 && {_uid in ADVSEC_jailDB}) then {
        (ADVSEC_jailDB get _uid) set [0, (_until - serverTime) max 0];
        ["jail"] call ADVSEC_fnc_policeDBSave;
    };
    false
}];
if (isNil "ADVSEC_jailLoopH") then {ADVSEC_jailLoopH = [] spawn ADVSEC_fnc_jailLoop};
diag_log format ["[ADVSEC] Detenidos: %1 · Buscados: %2", count ADVSEC_jailDB, count ADVSEC_wantedDB];
