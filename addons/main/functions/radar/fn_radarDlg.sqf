/*
    [acción, ...] — panel del radar de tráfico (cliente, permiso radar)
    "open" [radar] · "step" [idc botón] · "inc" [idc, paso] · "save" · "log" · "pickup" · "frame" · "off"
*/
params ["_a", ["_p1", objNull], ["_p2", 0]];
private _d = findDisplay 88200;
private _cam = missionNamespace getVariable ["ADVSEC_radarCam", objNull];
private _lims = createHashMapFromArray [[88211, [10, 300]], [88212, [10, 200]], [88213, [0, 100000]], [88214, [0, 10000]]];
private _cur = ["currency", "€"] call ADVSEC_fnc_setting;
switch (_a) do {
    case "open": {
        if !([player, "radar"] call ADVSEC_fnc_perm) exitWith {hint "Tu rango no permite configurar radares."};
        if (isNull _p1 || {!createDialog "ADVSEC_RadarDlg"}) exitWith {};
        _d = findDisplay 88200;
        ADVSEC_radarCam = _p1;
        (_p1 getVariable ["ADVSEC_speedCam", []]) params [["_name", "Radar"], ["_lim", 90], ["_range", 40], ["_base", 100], ["_per", 5], ["_on", true], ["_mode", 0], ["_exempt", (["speedCamExemptDuty", 1] call ADVSEC_fnc_setting) isEqualTo 1]];
        (_d displayCtrl 88201) ctrlSetText " RADAR DE TRÁFICO";
        (_d displayCtrl 88210) ctrlSetText _name;
        {(_d displayCtrl (_x select 0)) ctrlSetText str (_x select 1)} forEach [[88211, _lim], [88212, _range], [88213, _base], [88214, _per]];
        {
            _x params ["_idc", "_opts", "_sel"];
            private _c = _d displayCtrl _idc;
            {_c lbAdd _x} forEach _opts;
            _c lbSetCurSel _sel;
        } forEach [
            [88215, ["Ambos sentidos", "Solo los que se acercan", "Solo los que se alejan"], _mode],
            [88216, ["Apagado", "Activo"], parseNumber _on],
            [88217, ["Multada como cualquiera", "Exenta"], parseNumber _exempt]
        ];
        (_d displayCtrl 88221) ctrlShow ((_p1 getVariable ["ADVSEC_speedCamPortable", []]) isNotEqualTo []);
        ADVSEC_radarTick = 0;
        if (isNil "ADVSEC_radarEH") then {ADVSEC_radarEH = addMissionEventHandler ["EachFrame", {["frame"] call ADVSEC_fnc_radarDlg}]};
    };
    case "step": {
        // Botones −/+: idc 1xxxxx resta y 2xxxxx suma al campo xxxxx
        private _f = _p1 mod 100000;
        private _step = createHashMapFromArray [[88211, 10], [88212, 10], [88213, 50], [88214, 1]] getOrDefault [_f, 1];
        ["inc", _f, [_step, -_step] select (floor (_p1 / 100000) == 1)] call ADVSEC_fnc_radarDlg;
    };
    case "inc": {
        private _c = _d displayCtrl _p1;
        (_lims getOrDefault [_p1, [0, 1e6]]) params ["_min", "_max"];
        _c ctrlSetText str ((((round parseNumber ctrlText _c) + _p2) max _min) min _max);
    };
    case "save": {
        if (isNull _cam) exitWith {};
        ["set", player, [_cam, [
            ctrlText (_d displayCtrl 88210),
            parseNumber ctrlText (_d displayCtrl 88211),
            parseNumber ctrlText (_d displayCtrl 88212),
            parseNumber ctrlText (_d displayCtrl 88213),
            parseNumber ctrlText (_d displayCtrl 88214),
            lbCurSel (_d displayCtrl 88216) == 1,
            (lbCurSel (_d displayCtrl 88215)) max 0,
            lbCurSel (_d displayCtrl 88217) == 1
        ]]] remoteExecCall ["ADVSEC_fnc_speedCamServer", 2];
        playSound "FD_Finish_F";
    };
    case "log": {
        closeDialog 0;
        ADVSEC_panelSpeedCam = _cam;
        [] spawn {sleep 0.1; ["radarLog", "Radar · capturas", [], {["log", player, [ADVSEC_panelSpeedCam]] remoteExecCall ["ADVSEC_fnc_speedCamServer", 2]}] call ADVSEC_fnc_panelOpen};
    };
    case "pickup": {
        closeDialog 0;
        ["pickup", player, [_cam]] remoteExecCall ["ADVSEC_fnc_speedCamServer", 2];
    };
    case "frame": {
        if (isNull _d || {isNull _cam}) exitWith {["off"] call ADVSEC_fnc_radarDlg; if (!isNull _d) then {closeDialog 0}};
        if (diag_tickTime < ADVSEC_radarTick) exitWith {};
        ADVSEC_radarTick = diag_tickTime + 0.25;
        // Lectura en directo con los valores que hay en pantalla (aunque no estén guardados)
        private _lim = parseNumber ctrlText (_d displayCtrl 88211);
        private _range = (parseNumber ctrlText (_d displayCtrl 88212)) max 10;
        private _vs = _cam nearEntities [["LandVehicle"], _range];
        private _top = 0;
        {_top = _top max round abs speed _x} forEach _vs;
        private _on = lbCurSel (_d displayCtrl 88216) == 1;
        (_d displayCtrl 88202) ctrlSetStructuredText parseText format [
            "<t size='0.9' color='#5CFF5C' font='EtelkaMonospacePro'>%1  ·  ALCANCE %2 m  ·  %3 VEHÍCULO(S)</t><br/><t size='3' align='center' font='EtelkaMonospacePro' color='%4'>%5</t><t size='1.2' color='#5CFF5C'> km/h</t><t size='1' color='#8C8C8C'>   límite %6</t>",
            ["APAGADO", "MIDIENDO"] select _on, _range, count _vs,
            ["#5CFF5C", "#FF4040"] select (_top > _lim), ([str _top, "000"] select (_vs isEqualTo [])) , _lim
        ];
        private _last = (_cam getVariable ["ADVSEC_speedCamLog", []]) param [((count (_cam getVariable ["ADVSEC_speedCamLog", []])) - 1) max 0, []];
        (_d displayCtrl 88203) ctrlSetStructuredText parseText (if (_last isEqualTo []) then {"<t color='#8C8C8C'>Sin capturas todavía.</t>"} else {
            _last params ["_t", "_plate", "_s", "_who", "_amt"];
            format ["<t color='#8C8C8C'>Última captura:</t> %1 · %2 · <t color='#FF6655'>%3 km/h</t> · %4 · %5 %6", _t, _plate, _s, _who call ADVSEC_fnc_repEsc, _amt, _cur]
        });
    };
    case "off": {
        if (!isNil "ADVSEC_radarEH") then {removeMissionEventHandler ["EachFrame", ADVSEC_radarEH]; ADVSEC_radarEH = nil};
    };
};
