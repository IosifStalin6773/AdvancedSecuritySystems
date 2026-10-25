// ["PM"|"AI"|"BOTH"]
params [["_dept", "PM"]];
private _canPM = [player, "PM"] call ADVSEC_fnc_repAccess;
private _canAI = [player, "AI"] call ADVSEC_fnc_repAccess;
if (!_canPM && {!_canAI}) exitWith {hint "Necesitas placa de Policía Militar o credencial de Asuntos Internos."};
if (!createDialog "ADVSEC_Reports") exitWith {};
private _disp = findDisplay 86600;
(_disp displayCtrl 86601) ctrlSetText "  REGISTRO DE INFORMES — POLICÍA MILITAR Y ASUNTOS INTERNOS";
ADVSEC_repCurrent = createHashMap;
ADVSEC_repSelect = "";

private _cb = _disp displayCtrl 86610;
private _opts = [];
if (_canPM && {_dept != "AI"}) then {_opts pushBack ["Policía Militar", "PM"]};
if (_canAI && {_dept != "PM" || {!_canPM}}) then {_opts pushBack ["Asuntos Internos", "AI"]};
if (count _opts > 1) then {_opts pushBack ["Todos", "ALL"]};
if (_opts isEqualTo []) then {_opts = [["Asuntos Internos", "AI"]]};
{
    private _i = _cb lbAdd (_x select 0);
    _cb lbSetData [_i, _x select 1];
} forEach _opts;
_cb lbSetCurSel 0;
["refresh"] call ADVSEC_fnc_repAction;
