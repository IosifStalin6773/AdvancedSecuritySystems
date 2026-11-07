// valor guardado (estado, gravedad, sanción, peligrosidad...) -> texto para mostrar. Los datos se guardan siempre en español.
if !(_this isEqualType "") exitWith {_this};
if (isNil "ADVSEC_LvMap") then {
    ADVSEC_LvMap = createHashMap;
    {ADVSEC_LvMap set [_x select 0, _x select 1]} forEach getArray (configFile >> "ADVSEC_LangValues" >> "values");
};
private _k = ADVSEC_LvMap getOrDefault [_this, ""];
if (_k isEqualTo "") then {_this} else {_k call ADVSEC_fnc_L}
