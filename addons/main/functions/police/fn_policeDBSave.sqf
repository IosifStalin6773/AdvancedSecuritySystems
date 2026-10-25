// ["jail"|"wanted"|"all"] (servidor): publica la lista de buscados y marca las BD para el próximo guardado
params [["_which", "all"]];
if (!isServer) exitWith {};
if (_which in ["all", "jail"]) then {["jail"] call ADVSEC_fnc_dbDirty};
if (_which in ["all", "wanted"]) then {
    ["wanted"] call ADVSEC_fnc_dbDirty;
    ADVSEC_wanted = [];
    {ADVSEC_wanted pushBack ([_x] + _y)} forEach ADVSEC_wantedDB;
    ADVSEC_wantedUIDs = keys ADVSEC_wantedDB;
    publicVariable "ADVSEC_wanted";
    publicVariable "ADVSEC_wantedUIDs";
};
