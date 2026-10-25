params ["_obj"];
!isNull _obj && {
    getNumber (configOf _obj >> "numberOfDoors") > 0
    || {isClass (configOf _obj >> "AnimationSources" >> "Door_1_source")}
}
