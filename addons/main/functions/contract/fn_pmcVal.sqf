// [config, campo, porDefecto] -> número, texto o array del campo (textos $STR resueltos)
params ["_c", "_f", "_def"];
private _e = _c >> _f;
switch (true) do {
    case (isNumber _e): {getNumber _e};
    case (isText _e): {(getTextRaw _e) call ADVSEC_fnc_Lc};
    case (isArray _e): {(getArray _e) call ADVSEC_fnc_Lc};
    default {_def};
}
