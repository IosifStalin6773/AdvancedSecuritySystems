// [vehículo, nombreAgente, nombreControl] — cliente: el agente llega a la ventanilla y pide la documentación
params ["_veh", "_officer", "_cp"];
if (!hasInterface || {vehicle player != _veh}) exitWith {};
closeDialog 0;
ADVSEC_cpAskVeh = _veh;
if (!createDialog "ADVSEC_CpAsk") exitWith {};
((findDisplay 87600) displayCtrl 87602) ctrlSetStructuredText parseText format [
    "<t font='RobotoCondensedBold'>%1</t> · %2<br/><br/>«Buenos días, control policial. Documentación, por favor.»",
    [_officer] call ADVSEC_fnc_repEsc, [_cp] call ADVSEC_fnc_repEsc
];
playSound "FD_CP_Not_Clear_F";
