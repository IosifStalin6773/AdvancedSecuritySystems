// -> minutos aproximados desde una época fija según la hora real (persiste entre reinicios)
systemTimeUTC params ["_y", "_mo", "_d", "_h", "_mi"];
((_y - 2000) * 372 + _mo * 31 + _d) * 1440 + _h * 60 + _mi
