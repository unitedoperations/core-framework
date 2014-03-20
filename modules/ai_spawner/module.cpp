
class ai_spawner
{
	name = "AI Spawner Module";
	authors[] = {"Naught"};
	version = 1;
	required_version = 1;
	url = "https://github.com/unitedoperations/Core-framework";
	postinit = "postinit.sqf";
	class settings {
		#include "settings.cpp"
	};
};
