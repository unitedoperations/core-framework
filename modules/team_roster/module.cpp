
class team_roster
{
	name = "Team Roster Module";
	authors[] = {"Naught"};
	version = 1;
	required_version = 1;
	url = "https://github.com/unitedoperations/Core-framework";
	preinit = "preinit.sqf";
	postinit = "postinit.sqf";
	class settings {
		#include "settings.cpp"
	};
};
