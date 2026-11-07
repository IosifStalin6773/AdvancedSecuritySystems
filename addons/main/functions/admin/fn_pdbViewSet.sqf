// [tipo, datos] (cliente) — respuesta del servidor a la base de datos de jugadores
params ["_kind", "_data"];
if (isNull findDisplay 87850) exitWith {};
switch (_kind) do {
    case "list": {
        ADVSEC_pdbList = _data;
        ["filter"] call ADVSEC_fnc_pdbViewUI;
    };
    case "player": {
        if (_data isEqualTo []) exitWith {
            (findDisplay 87850 displayCtrl 87864) ctrlSetStructuredText parseText ("STR_ADVSEC_this_player_no_longer_has" call ADVSEC_fnc_L);
        };
        _data params ["_uid", "_name", "_on", "_adm", "_stats", "_secs", ["_cur", []]];
        // Ignora la respuesta si mientras tanto se eligió a otro jugador
        if (_uid isNotEqualTo ADVSEC_pdbSel) exitWith {};
        ADVSEC_pdbSections = _secs;
        ADVSEC_pdbCur = [_name, _on, _adm, _cur];
        ["header", [_name, _uid, _on, _adm, _stats]] call ADVSEC_fnc_pdbViewUI;
        ["render"] call ADVSEC_fnc_pdbViewUI;
    };
};
