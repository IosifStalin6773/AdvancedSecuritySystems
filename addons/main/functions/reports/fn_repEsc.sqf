// Texto de usuario -> structured text seguro
params [["_text", ""]];
if !(_text isEqualType "") then {_text = str _text};
_text = _text regexReplace ["&", "&amp;"];
_text = _text regexReplace ["<", "&lt;"];
_text = _text regexReplace [">", "&gt;"];
_text regexReplace ["\n", "<br/>"]
