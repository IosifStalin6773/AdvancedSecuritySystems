// [id del aviso] (servidor, 1.24): hace sonar los teléfonos de comisaría hasta que alguien conteste (máx. 60 s)
params [["_id", ""]];
if (!isServer || {isNil "ADVSEC_phones"}) exitWith {};
ADVSEC_phones = ADVSEC_phones select {!isNull _x};
if (ADVSEC_phones isEqualTo []) exitWith {};
ADVSEC_phoneRing = serverTime;
ADVSEC_phoneRingId = _id;
if (!isNil "ADVSEC_phoneRingH" && {!scriptDone ADVSEC_phoneRingH}) exitWith {};
ADVSEC_phoneRingH = [] spawn {
    private _snd = ["phoneSound", "A3\Sounds_F\sfx\beep_target.wss"] call ADVSEC_fnc_setting;
    while {ADVSEC_phoneRing > 0 && {serverTime - ADVSEC_phoneRing < 60}} do {
        {playSound3D [_snd, _x, false, getPosASL _x, 3, 1, 40]} forEach ADVSEC_phones;
        sleep 0.4;
        {playSound3D [_snd, _x, false, getPosASL _x, 3, 1.2, 40]} forEach ADVSEC_phones;
        sleep 2.6;
    };
    ADVSEC_phoneRing = 0;
};
