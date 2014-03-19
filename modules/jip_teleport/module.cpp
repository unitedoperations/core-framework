class jip_teleport
{
	name = "JIP Teleport";
	authors[] = {"Olsen", "Naught"};
	version = 1;
	required_version = 1;
	dependencies[] = {"flexi_menu_helper"};
	url = "https://github.com/unitedoperations/Core-framework";
	postinit = "postinit.sqf";
	class settings {
		#include "settings.cpp"
	};
};