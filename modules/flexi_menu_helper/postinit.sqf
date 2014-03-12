
/* Initialize Module */
#define FLEXI_LOAD_FUNC "['fmh_loadFlexiMenu', _this] call CORE_fnc_callFunction;"
["player", [ace_sys_interaction_key_self], -9240, [FLEXI_LOAD_FUNC, "main"]] call CBA_ui_fnc_add;
[["Man"], [ace_sys_interaction_key], 4, [FLEXI_LOAD_FUNC, "main"]] call CBA_ui_fnc_add;
