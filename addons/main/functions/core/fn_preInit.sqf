ADVSEC_actConds = createHashMap;
ADVSEC_actCounter = 0;
ADVSEC_camRegistry = [];
if (isNil "ADVSEC_alarms") then {ADVSEC_alarms = []};
ADVSEC_alarmSound = "A3\Sounds_F\sfx\alarm_independent.wss";
ADVSEC_profileKey = getMissionConfigValue ["ADVSEC_profileKey", "ADVSEC_docs"];
ADVSEC_persist = (getMissionConfigValue ["ADVSEC_persist", 1]) isEqualTo 1;

ADVSEC_icDoc = "\A3\ui_f\data\igui\cfg\simpleTasks\types\documents_ca.paa";
ADVSEC_icKey = "\A3\ui_f\data\igui\cfg\simpleTasks\types\use_ca.paa";
ADVSEC_icPad = "\A3\ui_f\data\igui\cfg\simpleTasks\types\interact_ca.paa";
ADVSEC_icCam = "\A3\ui_f\data\igui\cfg\simpleTasks\types\scout_ca.paa";
ADVSEC_icAlarm = "\A3\ui_f\data\igui\cfg\simpleTasks\types\danger_ca.paa";
ADVSEC_icPol = "\A3\ui_f\data\igui\cfg\simpleTasks\types\defend_ca.paa";
ADVSEC_icSearch = "\A3\ui_f\data\igui\cfg\simpleTasks\types\search_ca.paa";
ADVSEC_icCar = "\A3\ui_f\data\igui\cfg\simpleTasks\types\car_ca.paa";
ADVSEC_icRun = "\A3\ui_f\data\igui\cfg\simpleTasks\types\run_ca.paa";
ADVSEC_icJail = "\A3\ui_f\data\igui\cfg\simpleTasks\types\wait_ca.paa";

ADVSEC_kindOrder = ["camera", "monitor", "keypad", "door", "alarm", "issuer", "reports", "jail"];
ADVSEC_kindNames = createHashMapFromArray [
    ["camera", "Cámara"], ["monitor", "Monitor"], ["keypad", "Keypad"], ["door", "Cerradura"],
    ["alarm", "Alarma"], ["issuer", "Oficina"], ["reports", "Terminal"], ["jail", "Calabozo"], ["admin", "Terminal superadmin"], ["atm", "Cajero"], ["shop", "Tienda"]
];
ADVSEC_kindIcons = createHashMapFromArray [
    ["camera", ADVSEC_icCam], ["monitor", ADVSEC_icCam], ["keypad", ADVSEC_icPad], ["door", ADVSEC_icKey],
    ["alarm", ADVSEC_icAlarm], ["issuer", ADVSEC_icDoc], ["reports", ADVSEC_icDoc], ["jail", ADVSEC_icJail],
    ["lab", ADVSEC_icSearch], ["checkpoint", ADVSEC_icCar], ["admin", ADVSEC_icPol], ["atm", ADVSEC_icDoc], ["shop", ADVSEC_icSearch]
];
{if (isNil _x) then {missionNamespace setVariable [_x, []]}} forEach ["ADVSEC_secObjects", "ADVSEC_jails", "ADVSEC_wanted", "ADVSEC_wantedUIDs"];

