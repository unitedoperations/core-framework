
if (isNil "COUNTER") then {COUNTER = 0};
COUNTER = COUNTER + 1;

/* Specific Definitions */
#define LOAD_SETTING(key) (call compile format["%1", (["flexi_menu_helper", key] call core_fnc_getSetting)])
#define FLEXI_LOAD_FUNC "_this call fmh_fnc_loadFlexiMenu;"

/* Initialize Module */
[["Man"], [LOAD_SETTING("fmh_interact_key")], LOAD_SETTING("fmh_interact_priority"), [FLEXI_LOAD_FUNC, "main"]] call CBA_ui_fnc_add;
["player", [LOAD_SETTING("fmh_self_interact_key")], LOAD_SETTING("fmh_self_interact_priority"), [FLEXI_LOAD_FUNC, "main"]] call CBA_ui_fnc_add;
