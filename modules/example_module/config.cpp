
MODULE(example_module)
	authors[] = {"My Name"}; // Optional
	version = "1.0.0"; // Optional
	url = "http://unitedoperations.net"; // Optional
	class settings {
		#include "settings.cpp"
	};
END_MODULE;

#include "params.cpp"
