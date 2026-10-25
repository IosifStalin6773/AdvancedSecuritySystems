// Pantalla activa del registro de informes: PDA (87200) o terminal (86600)
private _d = findDisplay 87200;
[_d, findDisplay 86600] select (isNull _d)
