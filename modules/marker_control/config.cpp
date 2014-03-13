
#ifdef MODULES
	#include "module.cpp"
#endif

#ifdef SETTINGS
	#define SYSTEM sideLogic
	#define ADDMARKER(markerType,markerName) \
		class markerName { \
			side = QUOTE(markerType); \
		}
	#include "settings.cpp"
	#undef ADDMARKER
	#undef SYSTEM
#endif