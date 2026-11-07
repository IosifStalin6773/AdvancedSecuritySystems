params ['_text'];if !(_text isEqualType '') exitWith {_text};
private _language=profileNamespace getVariable ['TSL_uiLanguage','en'];
if (isNil 'TSL_labelCache') then {TSL_labelCache=createHashMap;};
private _key=_language+'|'+_text;private _cached=TSL_labelCache getOrDefault [_key,[]];
if (_cached isEqualType '') exitWith {_cached};
if (isNil 'TSL_labelExact') then {TSL_labelExact=createHashMap;{TSL_labelExact set ['ru|'+(_x select 0),_x select 1];TSL_labelExact set ['en|'+(_x select 1),_x select 0];} forEach TSL_translations;};
private _exact=TSL_labelExact getOrDefault [_key,[]];if (_exact isEqualType '') exitWith {TSL_labelCache set [_key,_exact];TSL_labelCache set [_language+'|'+_exact,_exact];_exact};
// Menu definitions are authored in English; only known translated labels need reversal.
if (_language=='en') exitWith {TSL_labelCache set [_key,_text];_text};
private _ru=_language=='ru';
{private _from=_x select (if (_ru) then {0} else {1});private _to=_x select (if (_ru) then {1} else {0});_text=[_text,_from,_to] call CBA_fnc_replace;} forEach TSL_translations;
TSL_labelCache set [_key,_text];TSL_labelCache set [_language+'|'+_text,_text];_text
