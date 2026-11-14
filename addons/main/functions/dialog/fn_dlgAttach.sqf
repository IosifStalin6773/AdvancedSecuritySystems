/*
    [objeto, texto del diálogo] — expresión del atributo de Eden «Diálogo (ADVSEC)» (se ejecuta en todas las máquinas).
    Guarda el árbol en el objeto y le añade la acción «Hablar» (ACE o rueda). También vale desde un init o un script:
        [this, "[""n1"",[[""n1"",""npc"","""",""Hola"",0.1,0.1,[]]]]"] call ADVSEC_fnc_dlgAttach;
*/
params ["_obj", ["_txt", ""]];
if (isNull _obj || {!(_txt isEqualType "")} || {_txt isEqualTo ""}) exitWith {};
private _d = ["parse", _txt] call ADVSEC_fnc_dlgData;
if ((_d param [1, []]) isEqualTo []) exitWith {};
_obj setVariable ["ADVSEC_dlg", _d];
if (!hasInterface) exitWith {};
[_obj, "advsec_talk", ("STR_ADVSEC_dlg_talk" call ADVSEC_fnc_L), ADVSEC_icDoc,
    {[_target, ""] call ADVSEC_fnc_dlgTalk},
    {alive _target && {!((_target getVariable ["ADVSEC_dlg", []]) isEqualTo [])} && {isNull findDisplay 88300}},
    "main", [], 3
] call ADVSEC_fnc_addInteraction;
