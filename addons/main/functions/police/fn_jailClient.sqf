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
                "<t align='center' font='RobotoCondensedBold' color='#D96600'>DETENIDO · %1</t><br/><t align='center' size='0.85' color='#AAAAAA'>%2</t>",
                [format ["%1:%2%3 restantes", floor (_left / 60), ["", "0"] select (_s < 10), _s], "a disposición de la PM"] select (_left > 1e6),
                [player getVariable ["ADVSEC_jailReason", ""]] call ADVSEC_fnc_repEsc
            ];
        };
        sleep 1;
    };
    ("ADVSEC_JailLayer" call BIS_fnc_rscLayer) cutText ["", "PLAIN"];
    ADVSEC_jailHudH = nil;
};
