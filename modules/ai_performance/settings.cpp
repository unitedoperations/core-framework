
/*
	Notes:
		1. You may set this variable on a unit to disable global caching of it:
			this setVariable ["aip_caching_allowed", false, true];
		2. You may set this variable on a unit to disable distribution of it:
			this setVariable ["aip_distribution_allowed", false, true];
*/

/* Generic Settings */

aip_enable_caching = 1; // Binary; Whether to save performance by disabling unneeded units.
aip_cache_distance = "viewDistance"; // Meters; Either a code string or number.

aip_enable_distribution = 1; // Binary; Whether to automatically send units to available headless clients.

aip_loop_delay = 5; // Seconds; Time to sleep between AI cache/distribution checking.

/* Advanced Settings */

aip_debug_mode_enabled = 0; // Binary; Whether to display AI debugging information.
