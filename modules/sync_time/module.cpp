
class sync_time
{
	name = "Time Synchronization Module";
	authors[] = {"Naught"};
	version = 2;
	required_version = 1;
	url = "https://github.com/unitedoperations/Core-framework";
	preinit = "preinit.sqf";
	postinit = "postinit.sqf";
	class settings {
		#include "settings.cpp"
	};
};
