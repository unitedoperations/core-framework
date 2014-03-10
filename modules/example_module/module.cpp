
class example_module
{
	name = "Example Module";
	authors[] = {"My Name"}; // Optional
	version = "1.0.0"; // Optional
	url = "http://unitedoperations.net"; // Optional
	preinit = "_this call my_fnc_name"; // Optional
	postinit = "_this call my_fnc_name"; // Optional
	class settings {
		#include "settings.cpp"
	};
};
