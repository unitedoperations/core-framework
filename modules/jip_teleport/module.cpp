class jip_teleport
{
	name = "JIP Teleport";
	authors[] = {"Olsen"};
	version = 1;
	required_version = 1;
	dependencies[] = {"ace_sys_wounds", "flexi_menu_helper"};
	url = "https://github.com/unitedoperations/Core-framework";
	postinit = "postinit.sqf";
	class settings {
		#include "settings.cpp"
	};
};