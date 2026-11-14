// [texto, cifrado] (cliente): mensaje del canal. Si está cifrado y no hay clave local (ADVSEC_pdaKey), se muestra ilegible.
params ["_body", "_enc"];
private _key = ["pdaCipherKey", ""] call ADVSEC_fnc_setting;
private _shown = _body;
if (_enc) then {
    if (_key isEqualTo "") then {_shown = "▮▮▮▮▮▮▮▮"} else {
        private _k = toArray _key;
        private _codes = toArray _body;
        for "_i" from 0 to (count _codes - 1) do {
            _codes set [_i, (_codes select _i) - ((_k select (_i mod count _k)) % 26)];
        };
        _shown = toString _codes;
    };
};
systemChat format ["[PDA] %1", _shown];
