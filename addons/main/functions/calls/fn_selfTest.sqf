/*
    (servidor, 1.24) autotest: comprueba la instalación, las clases que usan los ajustes y los avisos IA.
    Resultado público en ADVSEC_selfTest = [fecha, [[ok, texto], ...]]; los Zeus reciben un resumen.
*/
if (!isServer) exitWith {};
private _r = [];
private _add = {params ["_ok", "_k", ["_a", ""]]; _r pushBack [_ok, format [_k call ADVSEC_fnc_L, _a]]};
// Dependencias
[isClass (configFile >> "CfgPatches" >> "cba_main"), "STR_ADVSEC_st_cba"] call _add;
[true, ["STR_ADVSEC_st_noace", "STR_ADVSEC_st_ace"] select isClass (configFile >> "CfgPatches" >> "ace_interact_menu")] call _add;
// Funciones compiladas
private _miss = [];
{
    {
        private _f = format ["ADVSEC_fnc_%1", configName _x];
        if (isNil _f) then {_miss pushBack configName _x};
    } forEach ("true" configClasses _x);
} forEach ("true" configClasses (configFile >> "CfgFunctions" >> "ADVSEC"));
[_miss isEqualTo [], "STR_ADVSEC_st_fns", (_miss select [0, 8]) joinString ", "] call _add;
// Clases de los ajustes
private _bad = [];
private _cls = {params ["_c"]; isClass (configFile >> "CfgWeapons" >> _c) || {isClass (configFile >> "CfgMagazines" >> _c)} || {isClass (configFile >> "CfgVehicles" >> _c)} || {isClass (configFile >> "CfgGlasses" >> _c)}};
{
    private _k = _x;
    {
        private _c = if (_x isEqualType []) then {_x param [0, ""]} else {_x};
        if (_c isEqualType "" && {_c isNotEqualTo ""} && {!([_c] call _cls)}) then {_bad pushBackUnique format ["%1 (%2)", _c, _k]};
    } forEach ([_k, []] call ADVSEC_fnc_setting);
} forEach ["shopItems", "blackMarketItems", "blackMarketStolen", "mpCrateItems", "callCivs", "callHostiles", "callCars", "callConvoy"];
{if !([[_x, ""] call ADVSEC_fnc_setting] call _cls) then {_bad pushBackUnique _x}} forEach ["callSoldier", "trialJudgeClass", "trialCounselClass"];
{if !([_x] call _cls) then {_bad pushBackUnique _x}} forEach ["Land_MarketShelter_F", "Box_Syndicate_Ammo_F", "Box_Syndicate_Wps_F", "C_journalist_F", "Sh_82mm_AMOS", "Land_PaperBox_01_small_closed_brown_F", "Land_Medevac_house_V1_F", "Land_DataTerminal_01_F", "Land_Atm_01_F", "Land_MobilePhone_old_F", "Land_Loudspeakers_F", "Land_Cargo_HQ_V1_F", "Land_Razorwire_F", "Land_HelipadSquare_F", "CamoNet_BLUFOR_big_F", "Land_Laptop_unfolded_F", "Land_TableDesk_F", "Box_NATO_Equip_F", "B_Heli_Transport_01_F"];
[_bad isEqualTo [], "STR_ADVSEC_st_classes", (_bad select [0, 8]) joinString ", "] call _add;
// Mapa y misión
private _base = call ADVSEC_fnc_callBase;
private _towns = count nearestLocations [_base, ["NameVillage", "NameCity", "NameCityCapital"], ["callRadius", 3000] call ADVSEC_fnc_setting];
[_towns > 0, "STR_ADVSEC_st_towns", _towns] call _add;
[markerType "advsec_base" != "" || {(missionNamespace getVariable ["ADVSEC_sirens", []]) isNotEqualTo []}, "STR_ADVSEC_st_base", mapGridPosition _base] call _add;
[(missionNamespace getVariable ["ADVSEC_jails", []]) isNotEqualTo [], "STR_ADVSEC_st_jails", count (missionNamespace getVariable ["ADVSEC_jails", []])] call _add;
[!isNil "ADVSEC_phones", "STR_ADVSEC_st_phone"] call _add;
// Prueba de avisos: monta y desmonta uno de cada tipo sencillo lejos de los jugadores
if ((["selfTestCalls", 0] call ADVSEC_fnc_setting) isEqualTo 1) then {
    private _fail = [];
    {
        private _e = [_x, [0, 0, 0]] call ADVSEC_fnc_callSpawn;
        if (isNil "_e") then {_fail pushBack _x} else {{deleteVehicle _x} forEach ((_e get "units") + (_e get "objs"))};
    } forEach ["awol", "blackmarket", "apo", "accident", "amnesty", "trophy"];
    [_fail isEqualTo [], "STR_ADVSEC_st_calls", _fail joinString ", "] call _add;
};
missionNamespace setVariable ["ADVSEC_selfTest", [call ADVSEC_fnc_now, _r], true];
private _nBad = {!(_x select 0)} count _r;
{diag_log format ["[ADVSEC] autotest %1 %2", ["FALLO", "OK"] select (_x select 0), _x select 1]} forEach _r;
private _z = (allPlayers - entities "HeadlessClient_F") select {[_x] call ADVSEC_fnc_isZeus};
if (_z isNotEqualTo []) then {(format [("STR_ADVSEC_st_summary" call ADVSEC_fnc_L), count _r - _nBad, count _r]) remoteExecCall ["systemChat", _z]};
_r
