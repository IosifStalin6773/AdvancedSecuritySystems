// (servidor) -> saldo de la tesorería. En Antistasi con a3aTreasury es el dinero de la facción rebelde (resourcesFIA).
if ([] call ADVSEC_fnc_ecoA3A && {(["a3aTreasury", 1] call ADVSEC_fnc_setting) isEqualTo 1} && {!isNil "server"}) then {
    localNamespace setVariable ["ADVSEC_treasury", round (server getVariable ["resourcesFIA", 0])];
} else {[] call ADVSEC_fnc_ecoDB};
localNamespace getVariable ["ADVSEC_treasury", 0]
