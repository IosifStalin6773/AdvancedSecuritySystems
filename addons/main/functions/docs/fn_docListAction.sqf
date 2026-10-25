params ["_mode"];
private _i = lbCurSel 3001;
if (_i < 0) exitWith {};
private _pairs = [ADVSEC_listDocs select _i] call ADVSEC_fnc_docPairs;

switch (_mode) do {
    case "preview": {
        ((findDisplay 86300) displayCtrl 3002) ctrlSetStructuredText parseText ([_pairs] call ADVSEC_fnc_docFormat);
    };
    case "view": {
        closeDialog 0;
        [_pairs, ["", name ADVSEC_listOwner] select (ADVSEC_listOwner isNotEqualTo player), ADVSEC_listOwner] call ADVSEC_fnc_docView;
    };
    case "show": {
        private _t = missionNamespace getVariable ["ADVSEC_showTarget", objNull];
        if !(!isNull _t && {alive _t} && {_t distance player < 5}) then {_t = cursorObject};
        if !(_t isKindOf "CAManBase" && {alive _t} && {_t != player} && {_t distance player < 5}) then {
            _t = ((player nearEntities ["CAManBase", 4]) select {_x != player && {isPlayer _x}}) param [0, objNull];
        };
        ADVSEC_showTarget = objNull;
        if (isNull _t) exitWith {hint "No hay nadie cerca a quien mostrar el documento."};
        closeDialog 0;
        [_pairs, name player, player] remoteExecCall ["ADVSEC_fnc_docView", _t];
        hint format ["Has mostrado tu documento a %1.", name _t];
    };
};
