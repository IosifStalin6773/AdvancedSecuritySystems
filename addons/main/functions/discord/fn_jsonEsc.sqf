// [texto] -> texto escapado para JSON
params ["_s"];
private _out = [];
{
    switch (_x) do {
        case 34: {_out append [92, 34]};
        case 92: {_out append [92, 92]};
        case 10: {_out append [92, 110]};
        case 13: {};
        default {_out pushBack _x};
    };
} forEach toArray _s;
toString _out
