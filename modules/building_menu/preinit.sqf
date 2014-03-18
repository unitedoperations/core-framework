
/* Load Libraries */
#include "libraries\backend.sqf"

/* Load Variables */
building_playerBusy = false;
build_fnc_menuCondition = compile(["building_menu", "menu_visible_condition"] call core_fnc_getSetting);
build_previewUpdateSpeed = ["building_menu", "preview_update_speed"] call core_fnc_getSetting;
build_previewMethod = ["building_menu", "preview_method"] call core_fnc_getSetting;
