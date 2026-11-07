// [clave (SteamID / "AI:"netId), nombre] — historial de multas de una persona (propias si se omite)
params [["_key", ""], ["_name", ""]];
if (_key isEqualTo "") then {_key = [player] call ADVSEC_fnc_docKey; _name = name player};
private _own = _key isEqualTo ([player] call ADVSEC_fnc_docKey);
private _btns = [];
if (_own) then {
    _btns pushBack [("STR_ADVSEC_pay" call ADVSEC_fnc_L), {params ["_d"]; if (!isNil "_d") then {["pay", player, [_d select 1]] remoteExecCall ["ADVSEC_fnc_fineServer", 2]}}];
} else {
    _btns pushBack [("STR_ADVSEC_mark_as_paid" call ADVSEC_fnc_L), {params ["_d"]; if (!isNil "_d") then {["markPaid", player, _d] remoteExecCall ["ADVSEC_fnc_fineServer", 2]}}];
    _btns pushBack [("STR_ADVSEC_cancel" call ADVSEC_fnc_L), {
        params ["_d"];
        if (isNil "_d") exitWith {};
        [("STR_ADVSEC_cancel_fine" call ADVSEC_fnc_L), [[("STR_ADVSEC_reason_for_cancelling" call ADVSEC_fnc_L), ""]], {
            params ["_v", "_d"];
            ["cancel", player, _d + [_v select 0]] remoteExecCall ["ADVSEC_fnc_fineServer", 2];
        }, _d] call ADVSEC_fnc_zeusPrompt;
    }];
};
_btns pushBack [("STR_ADVSEC_refresh" call ADVSEC_fnc_L), {["refresh"] call ADVSEC_fnc_panelAction}];
ADVSEC_fineKey = _key;
["fines", format [("STR_ADVSEC_fines_2" call ADVSEC_fnc_L), _name], _btns, {["list", player, [ADVSEC_fineKey]] remoteExecCall ["ADVSEC_fnc_fineServer", 2]}] call ADVSEC_fnc_panelOpen;
