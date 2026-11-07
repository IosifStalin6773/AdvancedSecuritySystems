// Cliente detenido: contador en pantalla
if (!hasInterface || {!isNil "ADVSEC_jailHudH"}) exitWith {};
ADVSEC_jailHudH = [] spawn {
    private _t = time + 5;
    waitUntil {sleep 0.2; (player getVariable ["ADVSEC_jailUntil", 0]) > serverTime || {time > _t}};
    ("ADVSEC_JailLayer" call BIS_fnc_rscLayer) cutRsc ["ADVSEC_RscJail", "PLAIN", 0.3];
    while {(player getVariable ["ADVSEC_jailUntil", 0]) > serverTime} do {
        private _left = (player getVariable ["ADVSEC_jailUntil", 0]) - serverTime;
        private _disp = uiNamespace getVariable ["ADVSEC_jailHUD", displayNull];
        if (!isNull _disp) then {
            private _s = floor (_left % 60);
            (_disp displayCtrl 4201) ctrlSetStructuredText parseText format [
                ("STR_ADVSEC_detained_3" call ADVSEC_fnc_L),
                [format [("STR_ADVSEC_left_2" call ADVSEC_fnc_L), floor (_left / 60), ["", "0"] select (_s < 10), _s], ("STR_ADVSEC_at_the_mp_s_disposal" call ADVSEC_fnc_L)] select (_left > 1e6),
                [player getVariable ["ADVSEC_jailReason", ""]] call ADVSEC_fnc_repEsc
            ];
        };
        sleep 1;
    };
    ("ADVSEC_JailLayer" call BIS_fnc_rscLayer) cutText ["", "PLAIN"];
    ADVSEC_jailHudH = nil;
};
