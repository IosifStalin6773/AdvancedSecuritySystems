if !(([player, "PM"] call ADVSEC_fnc_repAccess) || {[player] call ADVSEC_fnc_isZeus}) exitWith {hint "Necesitas placa de Policía Militar."};
if (isNull findDisplay 86900 && {!createDialog "ADVSEC_Wanted"}) exitWith {};
["fill"] call ADVSEC_fnc_wantedAction;
[] spawn {
    private _last = ADVSEC_wanted;
    while {!isNull findDisplay 86900} do {
        if (ADVSEC_wanted isNotEqualTo _last) then {_last = ADVSEC_wanted; ["fill"] call ADVSEC_fnc_wantedAction};
        sleep 0.5;
    };
};
