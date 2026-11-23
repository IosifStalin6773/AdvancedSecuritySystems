/*
    [] (servidor) — bucle de tráfico (cada 5 s). Arranca una sola vez, desde rpInit.
    Desvíos, cierres de carril, convoyes escoltados y aviso de zonas sin patrulla.
*/
if (!isServer || {!isNil "ADVSEC_trafficLoopOn"}) exitWith {};
ADVSEC_trafficLoopOn = true;
[] spawn {
    private _limited = createHashMap;   // netId -> vehículo con limitSpeed aplicado por un cierre de carril
    private _zoneLast = createHashMap;  // marcador de zona -> último serverTime con patrulla dentro
    private _zoneWarn = createHashMap;
    while {true} do {
        sleep 5;
        private _now = serverTime;
        // Desvíos: la IA civil que entra en el radio recibe una orden de alejarse
        {
            _y params ["_pos", "_rad"];
            {
                private _d = driver _x;
                if (!isNull _d && {!isPlayer _d} && {side group _d == civilian} && {speed _x > 5}) then {
                    private _away = _pos getDir _x;
                    [_d, _pos getPos [400, _away]] remoteExecCall ["doMove", _d];
                };
            } forEach ((_pos nearEntities [["Car", "Motorcycle", "Truck"], _rad]) select {alive _x});
        } forEach (missionNamespace getVariable ["ADVSEC_diverts", createHashMap]);
        // Cierres de carril: limitar la velocidad al pasar
        private _lanes = missionNamespace getVariable ["ADVSEC_lanes", createHashMap];
        private _nearLane = [];
        {
            _y params ["_pos"];
            {
                _nearLane pushBackUnique netId _x;
                if !(netId _x in _limited) then {
                    _limited set [netId _x, _x];
                    [_x, 25] remoteExecCall ["limitSpeed", _x];
                };
            } forEach ((_pos nearEntities [["Car", "Motorcycle", "Truck"], 45]) select {alive _x && {!isNull driver _x}});
        } forEach _lanes;
        {
            if !(_x in _nearLane) then {
                private _v = _limited get _x;
                if (!isNull _v) then {[_v, -1] remoteExecCall ["limitSpeed", _v]};
                _limited deleteAt _x;
            };
        } forEach (keys _limited);
        // Convoyes: llegada y bajas
        {
            private _id = _x;
            private _cv0 = missionNamespace getVariable ["ADVSEC_convoys", createHashMap];
            (_cv0 get _id) params ["_name", "_nets", "_dest", "_state", "_t0", "_cUid"];
            if (_state != "active") then {continue};
            private _vehs = _nets apply {objectFromNetId _x};
            private _alive = _vehs select {!isNull _x && {alive _x}};
            private _radius = ["convoyRadius", 80] call ADVSEC_fnc_setting;
            private _cv = missionNamespace getVariable ["ADVSEC_convoys", createHashMap];
            if (count _alive < count _nets) then {
                (_cv get _id) set [3, "failed"];
                [format [("STR_ADVSEC_m_convoy_lost" call ADVSEC_fnc_L), _name]] remoteExecCall ["hint", 0];
                ["convoy", objNull, [_id, _name, "failed"]] call ADVSEC_fnc_logEvent;
                deleteMarker ("advsec_conv_" + _id);
            } else {
                if ((_alive findIf {(_x distance2D _dest) > _radius}) < 0) then {
                    (_cv get _id) set [3, "done"];
                    [format [("STR_ADVSEC_m_convoy_done" call ADVSEC_fnc_L), _name]] remoteExecCall ["hint", 0];
                    ["convoy", objNull, [_id, _name, "done", round ((_now - _t0) / 60)]] call ADVSEC_fnc_logEvent;
                    deleteMarker ("advsec_conv_" + _id);
                    private _bonus = round (["convoyBonus", 0] call ADVSEC_fnc_setting);
                    private _u = [_cUid] call ADVSEC_fnc_uidUnit;
                    if (_bonus > 0 && {[] call ADVSEC_fnc_ecoOn} && {_cUid isNotEqualTo ""}) then {
                        private _a = [_cUid, ["", name _u] select !isNull _u] call ADVSEC_fnc_ecoAcc;
                        _a set [1, (_a select 1) + _bonus];
                        [_a, format [("STR_ADVSEC_m_convoy_bonus" call ADVSEC_fnc_L), _id], _bonus] call ADVSEC_fnc_ecoHist;
                        ["eco"] call ADVSEC_fnc_dbDirty;
                    };
                };
            };
        } forEach (keys (missionNamespace getVariable ["ADVSEC_convoys", createHashMap]));
        // Zonas sin patrulla: marcadores "advsec_zone_*"
        private _unwatched = ["patrolUnwatchedMin", 0] call ADVSEC_fnc_setting;
        if (_unwatched > 0) then {
            private _pm = (allPlayers - entities "HeadlessClient_F") select {alive _x && {_x getVariable ["ADVSEC_onDuty", false]}};
            {
                private _m = _x;
                if ((_m select [0, 12]) == "advsec_zone_") then {
                    if ((_pm findIf {_x inArea _m}) >= 0) then {_zoneLast set [_m, _now]} else {
                        private _last = _zoneLast getOrDefault [_m, _now];
                        if (_now - _last > _unwatched * 60 && {_now - (_zoneWarn getOrDefault [_m, -1e7]) > _unwatched * 60}) then {
                            _zoneWarn set [_m, _now];
                            private _txt = format [("STR_ADVSEC_m_zone_unwatched" call ADVSEC_fnc_L), _m select [12], _unwatched];
                            {_txt remoteExecCall ["hint", _x]} forEach _pm;
                            ["zoneUnwatched", objNull, [_m select [12], _unwatched]] call ADVSEC_fnc_logEvent;
                        };
                        if !(_m in _zoneLast) then {_zoneLast set [_m, _now]};
                    };
                };
            } forEach allMapMarkers;
        };
    };
};
