/*
    [jugador, [clases base]] (servidor) — armas sacadas del Arsenal (ACE o vanilla): se les asigna su nº de serie
    (el mismo que dejan en los casquillos) y quedan registradas a nombre del jugador (arsenalSerial = 0 lo desactiva).
    No toca el material corporativo de la armería PMC (series CORP-).
*/
params ["_p", ["_cls", []]];
if (!isServer || {isNull _p} || {!([_p] call ADVSEC_fnc_srvCaller)}) exitWith {};
private _mode = ["arsenalSerial", 1] call ADVSEC_fnc_setting;
if (_mode isEqualTo 0) exitWith {};
private _db = [] call ADVSEC_fnc_wpnDB;
private _uid = getPlayerUID _p;
private _corp = ((_p getVariable ["ADVSEC_corpArms", []]) apply {_x select 0});
private _new = [];
{
    private _w = _x;
    if (_w isEqualType "" && {isClass (configFile >> "CfgWeapons" >> _w)} && {!(_w in _corp)}) then {
        private _s = [_uid, _w] call ADVSEC_fnc_wpnSerial;
        private _e = _db getOrDefault [_s, []];
        if (_e isEqualTo [] || {(_e select 1) != _uid}) then {
            _db set [_s, [_w, _uid, name _p, call ADVSEC_fnc_now, "ARS"]];
            ["weaponRegister", _p, [_s, _w, "ARS"]] call ADVSEC_fnc_logEvent;
            _new pushBack format ["%1 · %2", getText (configFile >> "CfgWeapons" >> _w >> "displayName"), _s];
        };
    };
} forEach ((_cls select [0, 30]) arrayIntersect (_cls select [0, 30]));
if (_new isEqualTo []) exitWith {};
["weapons"] call ADVSEC_fnc_dbDirty;
(format [("STR_ADVSEC_ars_serial_reg" call ADVSEC_fnc_L), _new joinString "\n"]) remoteExecCall ["hint", _p];
