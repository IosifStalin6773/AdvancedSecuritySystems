/*
    "STR_ADVSEC_x" -> texto en el idioma de ADVSEC (clase ADVSEC_Lang, generada desde stringtable.xml)
    Ajuste language: 0 = automático (idioma del juego; en servidor dedicado, inglés), 1 = English, 2 = Español.
    El servidor usa su ajuste para los mensajes que genera; los clientes, el suyo.
*/
if (isNil "ADVSEC_Lmap") then {
    private _es = switch (["language", 0] call ADVSEC_fnc_setting) do {
        case 1: {false};
        case 2: {true};
        default {hasInterface && {language == "Spanish"}};
    };
    private _f = ["en", "es"] select _es;
    private _nl = toString [10];
    ADVSEC_Lmap = createHashMap;
    {
        private _t = getText (_x >> _f);
        if ("\n" in _t) then {_t = _t regexReplace ["\\n", _nl]};
        ADVSEC_Lmap set [configName _x, _t];
    } forEach ("true" configClasses (configFile >> "ADVSEC_Lang"));
    ADVSEC_Les = _es;
};
ADVSEC_Lmap getOrDefault [_this, _this]
