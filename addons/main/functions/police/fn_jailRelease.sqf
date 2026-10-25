// [unidad] (servidor)
params ["_unit"];
if (!isServer) exitWith {};
private _uid = getPlayerUID _unit;
ADVSEC_jailDB deleteAt ([_uid, "AI:" + netId _unit] select (_uid isEqualTo ""));
["jail"] call ADVSEC_fnc_policeDBSave;
private _jail = _unit getVariable ["ADVSEC_jailObj", objNull];
_unit setVariable ["ADVSEC_jailUntil", 0, true];
_unit setVariable ["ADVSEC_jailObj", objNull, true];
if (!isNull _jail && {alive _unit}) then {
    private _pos = _jail getPos [(_jail getVariable ["ADVSEC_jailRadius", 6]) + 4, random 360];
    _pos set [2, 0];
    [_unit, "teleport", [_pos]] call ADVSEC_fnc_policeLocal;
};
"Has sido puesto en libertad." remoteExecCall ["hint", _unit];
