// [prueba] -> texto estructurado con ficha y cadena de custodia (las manipulaciones no se muestran)
params ["_e"];
private _esc = {[_this] call ADVSEC_fnc_repEsc};
private _st = createHashMapFromArray [["field", ("STR_ADVSEC_at_the_scene" call ADVSEC_fnc_L)], ["bagged", ("STR_ADVSEC_bagged" call ADVSEC_fnc_L)], ["analyzing", ("STR_ADVSEC_being_analysed" call ADVSEC_fnc_L)], ["analyzed", ("STR_ADVSEC_analysed" call ADVSEC_fnc_L)]];
private _lines = [
    format ["<t size='1.2' font='RobotoCondensedBold'>%1</t>", ([_e] call ADVSEC_fnc_evSummary) call _esc],
    format [("STR_ADVSEC_found_grid" call ADVSEC_fnc_L), _e get "time", _e get "grid"],
    format [("STR_ADVSEC_status_3" call ADVSEC_fnc_L), _st getOrDefault [_e get "state", "?"], ["", format [("STR_ADVSEC_custody_2" call ADVSEC_fnc_L), (_e get "holderName") call _esc]] select ((_e get "holderName") isNotEqualTo "")]
];
if ((_e get "type") == "casing") then {_lines pushBack format [("STR_ADVSEC_weapon_serial_no" call ADVSEC_fnc_L), (_e getOrDefault ["weaponName", ""]) call _esc, _e getOrDefault ["serial", ""]]};
_lines pushBack format [("STR_ADVSEC_lab_result" call ADVSEC_fnc_L), [("STR_ADVSEC_pending_analysis" call ADVSEC_fnc_L), (_e get "result") call _esc] select ((_e get "result") isNotEqualTo "")];
_lines pushBack ("STR_ADVSEC_chain_of_custody" call ADVSEC_fnc_L);
{_x params ["_ts", "_name", "_uid", "_what"]; _lines pushBack format ["<t color='#8C8C8C' size='0.9'>%1</t> · %2 · %3", _ts, _name call _esc, _what call _esc]} forEach (_e get "chain");
_lines joinString "<br/>"
