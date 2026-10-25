params ["_action", ["_key", ""]];
private _disp = findDisplay 86100;
if (isNull _disp) exitWith {};

switch (_action) do {
    case "press": {
        switch (_key) do {
            case "C": {ADVSEC_kpInput = ""};
            case "OK": {
                ["pin", ADVSEC_kpObj, player, ADVSEC_kpInput] remoteExecCall ["ADVSEC_fnc_keypadServer", 2];
                ADVSEC_kpInput = "";
                (_disp displayCtrl 1001) ctrlSetText "VERIFICANDO...";
            };
            default {if (count ADVSEC_kpInput < 8) then {ADVSEC_kpInput = ADVSEC_kpInput + _key}};
        };
    };
    case "result": {(_disp displayCtrl 1001) ctrlSetText _key};
};

private _mask = "";
for "_i" from 1 to count ADVSEC_kpInput do {_mask = _mask + "*"};
(_disp displayCtrl 1000) ctrlSetText _mask;
