// Panel con todas las teclas del mod (las actuales, incluidas las cambiadas en CBA)
["keys", "Advanced Security Systems · teclas", [
    ["Cerrar", {closeDialog 0}]
], {
    private _rows = [];
    private _cat = "";
    {
        _x params ["_id", "_name", "_tip", "_c"];
        if (_c != _cat) then {_cat = _c; _rows pushBack [toUpper _c, [], "", [0.816, 0.639, 0.188, 1], ""]};
        private _k = [_id] call ADVSEC_fnc_keyCurrent;
        _rows pushBack [format ["    %1   ·   %2", _k call ADVSEC_fnc_keyName, _name], _id, format ["<t size='1.2' font='RobotoCondensedBold'>%1</t><br/>%2<br/><br/>Tecla: <t color='#D0A330'>%3</t>", _name, _tip, _k call ADVSEC_fnc_keyName], [], ""];
    } forEach ([] call ADVSEC_fnc_keyList);
    ["keys", ["Cambia las teclas en <t color='#D0A330'>Opciones › Controles › Configurar complementos</t>.", "Sin CBA las teclas se cambian en la misión (class ADVSEC_Keys)."] select !(isClass (configFile >> "CfgPatches" >> "cba_keybinding")), _rows] call ADVSEC_fnc_panelSet;
}] call ADVSEC_fnc_panelOpen;
