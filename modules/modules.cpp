
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

#include "example_module\config.cpp"
#include "marker_control\config.cpp"
