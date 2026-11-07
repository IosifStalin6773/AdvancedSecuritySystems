/*
    [] (servidor) — bucle único de la PMC (cada 3 s). Arranca una sola vez.
    Contratos en curso, escaneo de civiles, generación automática de ofertas, disponibilidad y llegada de la QRF,
    capturas CCTV para la reconstrucción y auditoría automática de la armería.
*/
if (!isServer || {!isNil "ADVSEC_pmcLoopOn"}) exitWith {};
ADVSEC_pmcLoopOn = true;
[] spawn {
    private _tScan = 0; private _tGen = serverTime; private _tCell = 0; private _tSnap = 0; private _tAudit = serverTime;
    while {true} do {
        sleep 3;
        private _now = serverTime;
        private _db = [] call ADVSEC_fnc_ctrDB;
        private _active = (keys _db) select {((_db get _x) get "state") == "En curso"};
        if (_active isNotEqualTo []) then {
            ["tick"] call ADVSEC_fnc_ctrServer;
            if (_now - _tScan > 10) then {_tScan = _now; ["scan"] call ADVSEC_fnc_ctrDamage};
        };
        if ((["contractAuto", 1] call ADVSEC_fnc_setting) isEqualTo 1 && {_now - _tGen > 60 * (["contractEvery", 20] call ADVSEC_fnc_setting)}) then {
            _tGen = _now;
            ["gen"] call ADVSEC_fnc_ctrServer;
        };
        if (_now - _tCell > 30) then {_tCell = _now; ["tick"] call ADVSEC_fnc_cellServer};
        ["qrfTick"] call ADVSEC_fnc_cellServer;
        private _snap = ["cctvSnapEvery", 20] call ADVSEC_fnc_setting;
        if (_snap > 0 && {_now - _tSnap > _snap}) then {_tSnap = _now; ["snap"] call ADVSEC_fnc_cyServer};
        private _aud = ["armoryAuditEvery", 0] call ADVSEC_fnc_setting;
        if (_aud > 0 && {_now - _tAudit > 60 * _aud}) then {_tAudit = _now; [objNull] call ADVSEC_fnc_armAudit};
    };
};
