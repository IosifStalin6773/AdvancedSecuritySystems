// [clave (SteamID / "AI:"netId), nombre] — historial de multas de una persona (propias si se omite)
params [["_key", ""], ["_name", ""]];
if (_key isEqualTo "") then {_key = [player] call ADVSEC_fnc_docKey; _name = name player};
private _own = _key isEqualTo ([player] call ADVSEC_fnc_docKey);
private _btns = [];
if (_own) then {
    _btns pushBack ["Pagar", {params ["_d"]; if (!isNil "_d") then {["pay", player, [_d select 1]] remoteExecCall ["ADVSEC_fnc_fineServer", 2]}}];
} else {
    _btns pushBack ["Marcar pagada", {params ["_d"]; if (!isNil "_d") then {["markPaid", player, _d] remoteExecCall ["ADVSEC_fnc_fineServer", 2]}}];
    _btns pushBack ["Anular", {
        params ["_d"];
        if (isNil "_d") exitWith {};
        ["ANULAR MULTA", [["Motivo de la anulación", ""]], {
            params ["_v", "_d"];
            ["cancel", player, _d + [_v select 0]] remoteExecCall ["ADVSEC_fnc_fineServer", 2];
        }, _d] call ADVSEC_fnc_zeusPrompt;
    }];
};
_btns pushBack ["Actualizar", {["refresh"] call ADVSEC_fnc_panelAction}];
ADVSEC_fineKey = _key;
["fines", format ["Multas · %1", _name], _btns, {["list", player, [ADVSEC_fineKey]] remoteExecCall ["ADVSEC_fnc_fineServer", 2]}] call ADVSEC_fnc_panelOpen;
