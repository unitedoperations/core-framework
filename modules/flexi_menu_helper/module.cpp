
class flexi_menu_helper
{
	name = "Flexi Menu Helper";
	authors[] = {"Naught"};
	version = 1;
	required_version = 1;
	dependencies[] = {"cba_ui"};
	url = "https://github.com/unitedoperations/Core-framework";
	preinit = "preinit.sqf";
	postinit = "postinit.sqf";
	class settings {
		#include "settings.cpp"
	};
};
