/*
    (servidor, spawn, 1.24) vida en la prisión: los presos IA pasean, se sientan o hacen ejercicio dentro del calabozo
    y a veces se pelean (más con tensión social alta). Con jailAmbient > 0 cada calabozo tiene presos IA de ambiente.
*/
if (!isServer) exitWith {};
private _anims = ["AmovPercMstpSnonWnonDnon_exercisePushup", "AmovPercMstpSnonWnonDnon_exercisekneeBendA", "AmovPercMstpSnonWnonDnon_exercisekneeBendB"];
sleep 60;
while {true} do {
    private _jails = (missionNamespace getVariable ["ADVSEC_jails", []]) select {!isNull _x};
    {
        private _j = _x;
        private _r = _j getVariable ["ADVSEC_jailRadius", 6];
        // Presos de ambiente (se reponen si mueren o se los llevan)
        private _amb = (_j getVariable ["ADVSEC_jailAmb", []]) select {alive _x && {_x distance _j < _r + 30}};
        private _want = ["jailAmbient", 0] call ADVSEC_fnc_setting;
        if (count _amb < _want && {(allPlayers findIf {_x distance _j < 1500}) >= 0}) then {
            private _g = createGroup [civilian, true];
            private _u = _g createUnit [selectRandom (["callCivs", ["C_man_1"]] call ADVSEC_fnc_setting), _j getPos [random _r * 0.6, random 360], [], 0, "CAN_COLLIDE"];
            removeAllWeapons _u;
            removeAllItems _u;
            _u setVariable ["ADVSEC_jailUntil", serverTime + 1e7, true];
            _u setVariable ["ADVSEC_jailObj", _j, true];
            _amb pushBack _u;
        };
        _j setVariable ["ADVSEC_jailAmb", _amb];
        private _pris = ((_j nearEntities ["CAManBase", _r + 2]) select {alive _x && {!isPlayer _x} && {(_x getVariable ["ADVSEC_jailUntil", 0]) > serverTime}});
        {
            switch (floor random 4) do {
                case 0: {_x doMove (_j getPos [random (_r * 0.7), random 360])};
                case 1: {_x action ["SitDown", _x]};
                case 2: {[_x, selectRandom _anims] remoteExecCall ["playMoveNow", _x]};
                default {};
            };
        } forEach _pris;
        // Pelea: dos presos se lían a golpes y la PM recibe el aviso
        if (count _pris >= 2 && {random 1 < (0.03 + (missionNamespace getVariable ["ADVSEC_unrest", 0]) / 1000)}) then {
            private _a = selectRandom _pris;
            private _b = selectRandom (_pris - [_a]);
            _a doMove getPosATL _b;
            _b doMove getPosATL _a;
            [_a, _b] spawn {
                params ["_a", "_b"];
                sleep 6;
                {if (alive _x) then {_x setDamage ((damage _x) + 0.15); [_x, "AmovPercMstpSnonWnonDnon_AinvPercMstpSnonWnonDnon_Putdown"] remoteExecCall ["playMoveNow", _x]}} forEach [_a, _b];
            };
            ["tip", objNull, [format [("STR_ADVSEC_jl_fight" call ADVSEC_fnc_L), _j getVariable ["ADVSEC_jailName", ""]], getPosATL _j, "STR_ADVSEC_jl_guard" call ADVSEC_fnc_L]] call ADVSEC_fnc_dspServer;
            [2, "STR_ADVSEC_jl_fight_short" call ADVSEC_fnc_L] call ADVSEC_fnc_callUnrest;
        };
    } forEach _jails;
    sleep 45;
};
