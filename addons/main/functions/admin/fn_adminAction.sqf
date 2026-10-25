// ["cat"|"select"|"refresh"|"btn", índice] — terminal de superadministrador (cliente)
params ["_action", ["_arg", 0]];
private _disp = findDisplay 87800;
if (isNull _disp) exitWith {};
private _cat = ADVSEC_admCats param [lbCurSel (_disp displayCtrl 87802), []];
if (_cat isEqualTo []) exitWith {};
_cat params ["_key", "_label", "_buttons"];
private _row = ADVSEC_admRows param [lbCurSel (_disp displayCtrl 87803), []];
private _view = _disp displayCtrl 87805;
switch (_action) do {
    case "cat": {
        ADVSEC_admConfirm = [-1, 0];
        (_disp displayCtrl 87801) ctrlSetText format [" SUPERADMINISTRADOR · %1", toUpper _label];
        for "_i" from 0 to 4 do {
            private _b = _disp displayCtrl (87810 + _i);
            private _def = _buttons param [_i, []];
            _b ctrlShow (_def isNotEqualTo []);
            if (_def isNotEqualTo []) then {_b ctrlSetText (_def select 0)};
        };
        lbClear (_disp displayCtrl 87803);
        _view ctrlSetStructuredText parseText "";
        (_disp displayCtrl 87804) ctrlSetStructuredText parseText "<t color='#8C8C8C'>Consultando...</t>";
        ["list", player, [_key]] remoteExecCall ["ADVSEC_fnc_adminServer", 2];
    };
    case "refresh": {["list", player, [_key]] remoteExecCall ["ADVSEC_fnc_adminServer", 2]};
    case "select": {
        _view ctrlSetStructuredText parseText (_row param [2, "<t color='#8C8C8C'>Sin selección.</t>"]);
        _view ctrlSetPositionH ((ctrlTextHeight _view) max 0.6);
        _view ctrlCommit 0;
    };
    case "btn": {
        private _def = _buttons param [_arg, []];
        if (_def isEqualTo []) exitWith {};
        _def params ["_text", "_act", "_needSel", "_confirm", ["_form", []]];
        if (_needSel && {_row isEqualTo []}) exitWith {hint "Selecciona un elemento de la lista."};
        // Doble pulsación en 4 s para lo destructivo
        if (_confirm && {(ADVSEC_admConfirm select 0) != _arg || {time - (ADVSEC_admConfirm select 1) > 4}}) exitWith {
            ADVSEC_admConfirm = [_arg, time];
            (_disp displayCtrl (87810 + _arg)) ctrlSetText "¿Seguro? Pulsa otra vez";
            [_disp, _arg, _text] spawn {
                params ["_disp", "_i", "_text"];
                sleep 4;
                if (!isNull _disp && {(ADVSEC_admConfirm select 0) == _i}) then {(_disp displayCtrl (87810 + _i)) ctrlSetText _text; ADVSEC_admConfirm = [-1, 0]};
            };
        };
        ADVSEC_admConfirm = [-1, 0];
        (_disp displayCtrl (87810 + _arg)) ctrlSetText _text;
        if (_form isNotEqualTo []) exitWith {
            _form params ["_title", "_fields"];
            [_title, _fields, {
                params ["_v", "_ctx"];
                _ctx params ["_act", "_key", "_data"];
                [_act, player, [_key, [_data, _v]]] remoteExecCall ["ADVSEC_fnc_adminServer", 2];
            }, [_act, _key, _row param [1, ""]]] call ADVSEC_fnc_zeusPrompt;
        };
        [_act, player, [_key, _row param [1, ""]]] remoteExecCall ["ADVSEC_fnc_adminServer", 2];
    };
};
