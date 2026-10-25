// Abre la terminal de superadministrador
if !([player] call ADVSEC_fnc_adminIs) exitWith {hint "Solo superadministradores (Zeus, administradores o la lista de superadministradores)."};
if (isNull findDisplay 87800 && {!createDialog "ADVSEC_AdminDlg"}) exitWith {};
private _disp = findDisplay 87800;
// [clave, nombre, botones [[texto, acción, necesitaSelección, pideConfirmación, (opcional) [título, campos] de un formulario], ...]]
ADVSEC_admCats = [
    ["reports", "Informes y expedientes", [["Borrar informe", "repDel", true, true], ["Borrar TODOS", "repWipe", false, true]]],
    ["players", "Jugadores y rangos", [["Quitar sus rangos", "pdbStrip", true, false], ["Rangos según misión", "pdbReset", true, false], ["Dar / quitar superadmin", "adminToggle", true, true], ["Borrar ficha", "pdbDel", true, true], ["Quitar rangos a TODOS", "pdbStripAll", false, true]]],
    ["admins", "Superadministradores", [["Quitar superadmin", "adminDel", true, true]]],
    ["wanted", "Buscados", [["Retirar requisitoria", "wantedDel", true, false], ["Vaciar lista", "wantedWipe", false, true]]],
    ["jail", "Detenidos", [["Liberar", "jailDel", true, false], ["Liberar a TODOS", "jailWipe", false, true]]],
    ["fines", "Multas", [["Borrar multa", "fineDel", true, true], ["Borrar TODAS", "fineWipe", false, true]]],
    ["evidence", "Pruebas", [["Borrar prueba", "evDel", true, true], ["Borrar TODAS", "evWipe", false, true]]],
    ["heat", "Sospecha (AA.II.)", [["Archivar índice", "heatDel", true, false], ["Archivar TODOS", "heatWipe", false, true]]],
    ["docs", "Documentos", [["Retirar sus documentos", "docDel", true, true], ["Retirar TODOS", "docWipe", false, true]]],
    ["economy", "Economía", [
        ["Sumar / restar dinero", "ecoAdd", true, false, ["SUMAR O RESTAR DINERO", [["Dónde", "bank", [["Banco", "bank"], ["Efectivo", "cash"]]], ["Importe (negativo para restar)", "1000"]]]],
        ["Poner a cero", "ecoZero", true, true],
        ["Borrar cuenta", "ecoDel", true, true],
        ["Fijar tesorería", "treasurySet", false, false, ["TESORERÍA DE LA PM", [["Nuevo saldo", "10000"]]]],
        ["Poner a cero TODAS", "ecoWipe", false, true]
    ]],
    ["log", "Registro de eventos", [["Vaciar registro", "logWipe", false, true]]]
];
ADVSEC_admRows = [];
ADVSEC_admConfirm = [-1, 0];
private _c = _disp displayCtrl 87802;
lbClear _c;
{_c lbAdd (_x select 1)} forEach ADVSEC_admCats;
_c lbSetCurSel 0;
