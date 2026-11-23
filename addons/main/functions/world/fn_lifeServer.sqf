/*
    [centro, tipo (0 base · 1 pueblo), número, radio] (servidor, spawn, 1.24) — vida ambiental
    Base: personal sentado en sillas y soldados que van de un sitio a otro. Pueblo: civiles paseando y sentados en bancos.
    Solo existe mientras haya un jugador a menos de radio + 800 m.
*/
params ["_c", ["_kind", 0], ["_n", 8], ["_r", 80]];
if (!isServer) exitWith {};
private _classes = [["lifeSoldiers", ["B_Soldier_unarmed_F", "B_officer_F", "B_Soldier_F"]] call ADVSEC_fnc_setting, ["callCivs", ["C_man_1"]] call ADVSEC_fnc_setting] select (_kind == 1);
private _seats = ["Land_CampingChair_V1_F", "Land_CampingChair_V2_F", "Land_OfficeChair_01_F", "Land_ChairWood_F", "Land_ChairPlastic_F", "Land_Bench_F", "Land_Bench_01_F", "Land_Bench_02_F", "Land_RattanChair_01_F"];
private _agents = [];
while {true} do {
    private _near = (allPlayers findIf {_x distance2D _c < _r + 800}) >= 0;
    _agents = _agents select {alive _x};
    if (_near) then {
        if (count _agents < _n) then {
            private _free = (nearestObjects [_c, _seats, _r]) select {isNull (_x getVariable ["ADVSEC_lifeSeat", objNull])};
            private _p = _c getPos [random _r, random 360];
            private _a = createAgent [selectRandom _classes, _p, [], 0, "NONE"];
            _a setVariable ["BIS_fnc_animalBehaviour_disable", true];
            if (_free isNotEqualTo [] && {random 1 < 0.5}) then {
                // Sentado en una silla o banco libre
                private _s = selectRandom _free;
                _s setVariable ["ADVSEC_lifeSeat", _a];
                _a setPosATL (getPosATL _s);
                _a setDir ((getDir _s) + 180);
                [_a, "HubSittingChairA_idle1"] remoteExecCall ["switchMove", 0, _a];
                _a setVariable ["ADVSEC_lifeSit", true];
            } else {
                _a forceWalk true;
            };
            _agents pushBack _a;
        };
        {
            if !(_x getVariable ["ADVSEC_lifeSit", false]) then {
                if (moveToCompleted _x || {random 1 < 0.15}) then {_x moveTo (_c getPos [random _r, random 360])};
            };
        } forEach _agents;
    } else {
        {deleteVehicle _x} forEach _agents;
        _agents = [];
        {_x setVariable ["ADVSEC_lifeSeat", objNull]} forEach (nearestObjects [_c, _seats, _r]);
    };
    sleep 15;
};
