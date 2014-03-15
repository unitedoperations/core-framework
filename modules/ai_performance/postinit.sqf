
/* Initialize Headless Client */
if (!isDedicated && !hasInterface) then { // HC
	[player] call aip_fnc_initHC;
	player addEventHandler ["killed", {
		[] spawn {
			waitUntil {!(isNull player) && {alive player}};
			[player] call aip_fnc_initHC;
		};
	};
};

/* Create AI Performance Loop Thread */
[] spawn aip_fnc_aiPerformanceLoop;
