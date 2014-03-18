class jip_teleport
{
	name = "JIP Teleport";
	authors[] = {"Olsen", "Naught"};
	version = 2;
	required_version = 1;
	dependencies[] = {"flexi_menu_helper"};
	url = "https://github.com/unitedoperations/Core-framework";
	preinit = "preinit.sqf";
	postinit = "postinit.sqf";
	class settings {
		#include "settings.cpp"
	};
};