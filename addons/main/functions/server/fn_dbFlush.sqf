// (servidor): vuelca a profileNamespace lo marcado como sucio y guarda el perfil una sola vez
if (!isServer) exitWith {};
private _d = localNamespace getVariable ["ADVSEC_dbDirty", []];
if (_d isEqualTo []) exitWith {};
localNamespace setVariable ["ADVSEC_dbDirty", []];
if ("rep" in _d) then {
    profileNamespace setVariable [ADVSEC_repKey, (values ADVSEC_repDB) apply {[_x] call ADVSEC_fnc_docPairs}];
    profileNamespace setVariable [ADVSEC_repKey + "_seq", [ADVSEC_repSeq] call ADVSEC_fnc_docPairs];
};
if ("jail" in _d) then {profileNamespace setVariable [ADVSEC_repKey + "_jail", [ADVSEC_jailDB] call ADVSEC_fnc_docPairs]};
if ("wanted" in _d) then {profileNamespace setVariable [ADVSEC_repKey + "_wanted", [ADVSEC_wantedDB] call ADVSEC_fnc_docPairs]};
if ("docs" in _d && {ADVSEC_persist}) then {
    private _out = [];
    {
        if ((_x select [0, 3]) != "AI:") then {_out pushBack [_x, _y apply {[_x] call ADVSEC_fnc_docPairs}]};
    } forEach ([] call ADVSEC_fnc_docStore);
    profileNamespace setVariable [ADVSEC_repKey + "_docs", _out];
};
if ("log" in _d) then {profileNamespace setVariable [ADVSEC_repKey + "_log", localNamespace getVariable ["ADVSEC_eventLog", []]]};
if ("ev" in _d) then {
    private _out = [];
    {if ((_y get "state") != "field") then {_out pushBack ([_y] call ADVSEC_fnc_docPairs)}} forEach ([] call ADVSEC_fnc_evDB);
    profileNamespace setVariable [ADVSEC_repKey + "_evidence", _out];
    profileNamespace setVariable [ADVSEC_repKey + "_evseq", localNamespace getVariable ["ADVSEC_evSeq", 0]];
};
if ("heat" in _d) then {profileNamespace setVariable [ADVSEC_repKey + "_heat", [[] call ADVSEC_fnc_heatDB] call ADVSEC_fnc_docPairs]};
if ("fines" in _d) then {
    profileNamespace setVariable [ADVSEC_repKey + "_fines", [[] call ADVSEC_fnc_fineDB] call ADVSEC_fnc_docPairs];
    profileNamespace setVariable [ADVSEC_repKey + "_fineseq", localNamespace getVariable ["ADVSEC_fineSeq", 0]];
};
if ("players" in _d) then {profileNamespace setVariable [ADVSEC_repKey + "_players", [[] call ADVSEC_fnc_pdbDB] call ADVSEC_fnc_docPairs]};
if ("eco" in _d) then {
    private _out = [];
    {_out pushBack [_x, _y]} forEach ([] call ADVSEC_fnc_ecoDB);
    profileNamespace setVariable [ADVSEC_repKey + "_eco", _out];
    profileNamespace setVariable [ADVSEC_repKey + "_treasury", localNamespace getVariable ["ADVSEC_treasury", 0]];
    profileNamespace setVariable [ADVSEC_repKey + "_treasuryHist", localNamespace getVariable ["ADVSEC_treasuryHist", []]];
};
saveProfileNamespace;
