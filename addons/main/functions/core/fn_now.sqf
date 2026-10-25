// -> "AAAA-MM-DD hh:mm UTC" (hora real del sistema)
private _pad = {private _s = str _this; if (count _s < 2) then {"0" + _s} else {_s}};
systemTimeUTC params ["_y", "_mo", "_d", "_h", "_mi"];
format ["%1-%2-%3 %4:%5 UTC", _y, _mo call _pad, _d call _pad, _h call _pad, _mi call _pad]
