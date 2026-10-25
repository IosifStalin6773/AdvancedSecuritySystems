/*
    (servidor) Variables globales que lee el HUD THUD fuera de Antistasi:
    resourcesFIA = tesorería de la PM · hr = agentes PM conectados · theBoss = agente PM de mayor rango conectado.
    En Antistasi no toca nada (son de Antistasi).
*/
if (!isServer || {[] call ADVSEC_fnc_ecoA3A} || {(["thudCompat", 1] call ADVSEC_fnc_setting) isNotEqualTo 1}) exitWith {};
private _t = localNamespace getVariable ["ADVSEC_treasury", 0];
private _pm = 0;
private _boss = objNull;
private _best = 0;
{
    private _l = [_x, "PM"] call ADVSEC_fnc_rankLevel;
    if (_l > 0) then {
        _pm = _pm + 1;
        if (_l > _best) then {_best = _l; _boss = _x};
    };
} forEach (allPlayers - entities "HeadlessClient_F");
if (missionNamespace getVariable ["resourcesFIA", -1] != _t) then {resourcesFIA = _t; publicVariable "resourcesFIA"};
if (missionNamespace getVariable ["hr", -1] != _pm) then {hr = _pm; publicVariable "hr"};
if !((missionNamespace getVariable ["theBoss", objNull]) isEqualTo _boss) then {theBoss = _boss; publicVariable "theBoss"};
