
/* Create AI Performance Loop Thread */
0 spawn aip_fnc_aiPerformanceLoop;

/* Load Debugging */
if (hasInterface && {aip_debug_mode_enabled}) then {
	0 spawn aip_fnc_debugMode;
};
