class spectator
{
	name = "Spectator";
	authors[] = {"Olsen"};
	version = 1;
	required_version = 1;
	dependencies[] = {"acre_api"};
	url = "https://github.com/unitedoperations/Core-framework";
	postinit = "postinit.sqf";
	class settings {
		#include "settings.cpp"
	};
};