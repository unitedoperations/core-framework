
/*
	Title: Module List
	Author(s): Everyone
	Description:
		The place where modules are listed, included,
		and loaded into the framework.
	Syntax:
		#include "module_name\config.cpp"
	Notes:
		1. You may comment-out modules to disable them:
			//#include "module_name\config.cpp"
		2. When adding a new module, you must add a new
		include-line here to load it into the framework.
		3. Module configurations can be found within the
		module folder as "settings.cpp".
		4. Unless you're a developer, do not alter the
		"config.cpp" files within the module folders.
*/

#include "ai_performance\config.cpp"
//#include "ai_spawner\config.cpp" // Untested
#include "ao_limit\config.cpp"
#include "setup_timer\config.cpp"
#include "briefing\config.cpp"
//#include "building_menu\config.cpp"
#include "auto_earplugs\config.cpp"
#include "end_screen\config.cpp"
#include "flexi_menu_helper\config.cpp"
#include "game_loop\config.cpp"
#include "gear\config.cpp"
#include "jip_teleport\config.cpp"
#include "marker_control\config.cpp"
#include "mission_settings\config.cpp"
#include "radio_scrambler\config.cpp"
#include "safe_spawn\config.cpp"
#include "spectator\config.cpp"
#include "start_text\config.cpp"
#include "sync_time\config.cpp"
