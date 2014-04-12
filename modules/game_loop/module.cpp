
class game_loop
{
	name = "Game Loop";
	authors[] = {"Naught"};
	version = 1;
	required_version = 1;
	url = "https://github.com/unitedoperations/Core-framework";
	postinit = "postinit.sqf";
	preinit = "preinit.sqf";
	class settings {
		#include "settings.cpp"
	};
};
