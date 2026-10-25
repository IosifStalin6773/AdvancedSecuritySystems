// [[[rasgo, bool], ...]] (donde la unidad es local): rasgos de la especialidad
params ["_traits"];
{player setUnitTrait [_x select 0, _x select 1]} forEach _traits;
