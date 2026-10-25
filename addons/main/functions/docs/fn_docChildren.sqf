/*
    Hijos ACE, uno por documento válido de _owner.
    [portador, modo] modo: "review" (verlo uno mismo) | "show" (mostrarlo a _target) | "inspect" (ver los de _target)
*/
params ["_owner", "_mode"];
([_owner] call ADVSEC_fnc_docGetAll) apply {
    private _cfg = [_x get "type"] call ADVSEC_fnc_docTypeCfg;
    [
        format ["advsec_doc_%1_%2", _mode, _x get "id"],
        format ["%1 - %2", getText (_cfg >> "displayName"), _x getOrDefault ["name", _x get "number"]],
        getText (_cfg >> "icon"),
        {
            _args params ["_mode", "_pairs", "_owner"];
            switch (_mode) do {
                case "review": {[_pairs, "", _owner] call ADVSEC_fnc_docView};
                case "inspect": {[_pairs, name _owner, _owner] call ADVSEC_fnc_docView};
                case "show": {
                    [_pairs, name _player, _player] remoteExecCall ["ADVSEC_fnc_docView", _target];
                    hint format ["Has mostrado tu documento a %1.", name _target];
                };
            };
        },
        [_mode, [_x] call ADVSEC_fnc_docPairs, _owner]
    ]
}
