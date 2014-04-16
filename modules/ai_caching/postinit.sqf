
/* Create AI Performance Loop Thread */
[] spawn aip_fnc_aiPerformanceLoop;

/* Load Debugging */
if (hasInterface && {aip_debug_mode_enabled}) then {
	[] spawn aip_fnc_debugMode;
};
