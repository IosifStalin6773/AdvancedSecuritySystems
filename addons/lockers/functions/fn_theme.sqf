disableSerialization;params [['_d',displayNull]];if (isNull _d) exitWith {};
private _default=[[.025,.028,.03,1],[.12,.13,.14,1],[.76,.80,.82,1],[.97,.97,.97,1]];
if ((profileNamespace getVariable ['TSL_menuTheme',[]]) isEqualTo [[.025,.028,.03,.88],[.12,.13,.14,0],[.76,.80,.82,1],[.91,.92,.93,1]]) then {profileNamespace setVariable ['TSL_menuTheme',_default];saveProfileNamespace;};
private _colors=uiNamespace getVariable ['TSL_themeDraft',profileNamespace getVariable ['TSL_menuTheme',_default]];
if !(_colors isEqualType [] && {count _colors==4} && {(_colors findIf {!(_x isEqualType [] && {count _x==4} && {(_x findIf {!(_x isEqualType 0) || {!finite _x} || {_x<0} || {_x>1}})<0})})<0}) then {_colors=_default;};
if (_colors isEqualTo [[.035,.045,.04,.96],[.20,.23,.18,1],[.85,.78,.52,1],[.96,.96,.94,1]]) then {_colors=_default;};
if (_colors isEqualTo [[.025,.028,.03,.88],[.12,.13,.14,0],[.76,.80,.82,1],[.91,.92,.93,1]]) then {_colors=_default;};
private _controls=allControls _d;private _key=str [_colors,_controls apply {[ctrlIDC _x,if (ctrlType _x in [4,5]) then {lbSize _x} else {0}]}];if (_key==(_d getVariable ['TSL_themeKey',''])) exitWith {};
_colors params ['_background','_button','_accent','_text'];
{
 private _id=ctrlIDC _x;private _type=ctrlType _x;
 if !(_id in [78800,78600,78601] || {(_x getVariable ['TSL_editorOverlay',false])}) then {
  if (_type in [0,1,2,4,5]) then {_x ctrlSetTextColor (if (_id in [78407,78501,78711]) then {_accent} else {_text});};
  if (_type==1) then {_x ctrlSetBackgroundColor _button;};
  if (_type in [4,5]) then {private _list=_x;for '_i' from 0 to (lbSize _list-1) do {_list lbSetColor [_i,_text];_list lbSetSelectColor [_i,_accent];};};
  if (_type in [2,4,5]) then {private _fill=+_background;_x ctrlSetBackgroundColor _fill;};
  if (_type==0 && {(ctrlClassName _x) in ['TSL_Text','TSL_Wrapped','Backdrop']} && {ctrlText _x!='' || {((ctrlPosition _x) select 3)>safeZoneH*.15}}) then {_x ctrlSetBackgroundColor _background;};
 };
} forEach _controls;
_d setVariable ['TSL_themeKey',_key];
