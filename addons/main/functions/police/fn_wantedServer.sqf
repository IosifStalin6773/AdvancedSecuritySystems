// ["add"|"del", llamador, args] (servidor)
params ["_action", "_caller", ["_args", []]];
if (!isServer || {isNull _caller}) exitWith {};
if (isMultiplayer && {remoteExecutedOwner != 0} && {remoteExecutedOwner != owner _caller}) exitWith {};
if (isNil "ADVSEC_wantedDB") then {[] call ADVSEC_fnc_policeDBLoad};
if !([_caller, "wanted"] call ADVSEC_fnc_perm) exitWith {
    ("STR_ADVSEC_your_rank_does_not_allow_5" call ADVSEC_fnc_L) remoteExecCall ["hint", _caller];
};

switch (_action) do {
    case "add": {
        _args params ["_uid", "_name", ["_reason", ""], ["_level", "Media"]];
        if (_uid isEqualTo "") exitWith {};
        ADVSEC_wantedDB set [_uid, [_name, _reason, _level, name _caller, call ADVSEC_fnc_now, getPlayerUID _caller]];
        ["wanted"] call ADVSEC_fnc_policeDBSave;
        ["wantedAdd", _caller, [_name, _uid, _level, _reason]] call ADVSEC_fnc_logEvent;
        (format [("STR_ADVSEC_mp_declared_wanted_danger_level" call ADVSEC_fnc_L), _name, toLower _level]) remoteExecCall ["systemChat", 0];
    };
    case "del": {
        _args params ["_uid"];
        private _e = ADVSEC_wantedDB deleteAt _uid;
        if (!isNil "_e" && {(_e param [5, ""]) isNotEqualTo getPlayerUID _caller} && {!([_caller] call ADVSEC_fnc_isZeus)}) then {
            [_caller, "wantedRemovedByOther", _e select 0] call ADVSEC_fnc_heatAdd;
        };
        ["wantedDel", _caller, [_uid]] call ADVSEC_fnc_logEvent;
        ["wanted"] call ADVSEC_fnc_policeDBSave;
        if (!isNil "_e") then {(format [("STR_ADVSEC_mp_removed_from_the_wanted" call ADVSEC_fnc_L), _e select 0]) remoteExecCall ["systemChat", 0]};
    };
};
