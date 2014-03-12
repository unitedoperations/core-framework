
class example_module
{
	name = "Example Module";
	authors[] = {"My Name"}; // Optional
	version = 1; // Optional
	required_version = 1;// Optional
	dependencies[] = {"flexi_menu_helper", "A3_UI_F"}; // Optional, may be module class names or CfgPatches class names
	url = "http://unitedoperations.net"; // Optional
	preinit = "preinit.sqf"; // Optional
	postinit = "postinit.sqf"; // Optional
	class settings { // Optional
		#include "settings.cpp"
	};
};
