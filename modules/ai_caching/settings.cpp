
/*
	Notes:
		1. You may set this variable on a unit to disable global caching of it:
			this setVariable ["aip_caching_allowed", false, true];
*/

/* Generic Settings */

aip_cache_distance = "viewDistance + 150"; // Meters; Either a code string or number.

aip_loop_delay = 5; // Seconds; Time to sleep between AI caching checking. Lower values dramatically affect performance and bandwidth adversely.

/* Advanced Settings */

aip_debug_mode_enabled = 0; // Binary; Whether to display AI debugging information.
