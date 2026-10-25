/*
    (cliente, al aparecer) Pide al servidor el saldo para que el HUD lo muestre.
    Con el HUD THUD cargado y fuera de Antistasi: le da un nombre a la «facción» (PM) y desactiva su espera por Antistasi.
*/
if (!hasInterface || {!([] call ADVSEC_fnc_ecoOn)}) exitWith {};
if (isClass (configFile >> "CfgPatches" >> "THUD_Antistasi") && {!([] call ADVSEC_fnc_ecoA3A)} && {(["thudCompat", 1] call ADVSEC_fnc_setting) isEqualTo 1}) then {
    THUD_waitForAntistasi = false;
    if (isNil "A3A_faction_reb") then {
        A3A_faction_reb = createHashMapFromArray [["name", ["thudTreasuryName", "PM"] call ADVSEC_fnc_setting], ["currencySymbol", ["currency", "€"] call ADVSEC_fnc_setting]];
    };
};
["wallet", player] remoteExecCall ["ADVSEC_fnc_ecoServer", 2];
