// [objeto o posición, radio] -> edificio con puertas más cercano
params ["_ref", ["_radius", 50]];
(nearestObjects [_ref, ["House", "Building"], _radius] select {[_x] call ADVSEC_fnc_hasDoors}) param [0, objNull]
