
class building_menu
{
	name = "Building Menu";
	authors[] = {"Naught"};
	version = 1;
	dependencies[] = {"flexi_menu_helper", "cba_common"};
	url = "https://github.com/unitedoperations/Core-framework";
	preinit = "preinit.sqf";
	postinit = "postinit.sqf";
	class settings {
		#include "settings.cpp"
	};
};
