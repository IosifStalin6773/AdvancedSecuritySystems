/*
    [título, texto, color] (servidor) — aviso a Discord por webhook.
    SUPOSICIÓN: Arma no hace HTTP; se usa la extensión de servidor discordExtension con callExtension [url, json] (p. ej. un build de DiscordEmbedBuilder / webhook genérico). Sin extensión no hace nada.
*/
params ["_title", "_text", ["_color", 13672496]];
if (!isServer) exitWith {};
private _url = ["discordWebhook", ""] call ADVSEC_fnc_setting;
if (_url isEqualTo "") exitWith {};
private _json = format ['{"username":"ADVSEC","embeds":[{"title":"%1","description":"%2","color":%3,"footer":{"text":"%4 · %5"}}]}',
    [_title] call ADVSEC_fnc_jsonEsc, [_text] call ADVSEC_fnc_jsonEsc, _color, [missionName] call ADVSEC_fnc_jsonEsc, call ADVSEC_fnc_now];
private _r = (["discordExtension", "DiscordEmbedBuilder"] call ADVSEC_fnc_setting) callExtension [_url, [_json]];
if ((_r select 1) != 0 || {(_r select 2) != 0}) then {diag_log format ["[ADVSEC] Discord: la extensión devolvió %1", _r]};
