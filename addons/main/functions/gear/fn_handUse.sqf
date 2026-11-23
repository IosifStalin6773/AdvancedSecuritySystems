// (cliente, 1.24) usa lo que llevas en la mano: foto, megáfono (120 m), parte en la carpeta o golpe de porra
switch (player getVariable ["ADVSEC_hand", ""]) do {
    case "camera": {
        playSound "FD_Timer_F";
        ["photo", player, [cursorObject, screenToWorld [0.5, 0.5]]] remoteExecCall ["ADVSEC_fnc_handServer", 2];
    };
    case "megaphone": {["megaphone"] call ADVSEC_fnc_hotkey};
    case "clipboard": {["PM"] call ADVSEC_fnc_repEditorOpen};
    case "baton": {
        private _t = cursorObject;
        if (isNull _t || {!(_t isKindOf "CAManBase")} || {player distance _t > 2.5}) exitWith {hint ("STR_ADVSEC_hand_baton_far" call ADVSEC_fnc_L)};
        player playActionNow "GestureSwing";
        ["baton", player, [_t]] remoteExecCall ["ADVSEC_fnc_handServer", 2];
    };
    default {hint ("STR_ADVSEC_hand_none" call ADVSEC_fnc_L)};
};
