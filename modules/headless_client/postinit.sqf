
/* Initialize Headless Client */

if (!isDedicated && !hasInterface) then { // HC
	hc_headlessClientFlag = player;
	publicVariableServer "hc_headlessClientFlag";
};

/* Initialize Server */

if (isServer) then {
	[] spawn {
		uiSleep 10;
		if (isMultiplayer && {[{!isNull hc_headlessClient}, 20, "Headless Client Module"] call core_fnc_wait}) then {
			hc_processMissionObjects = hc_headlessClient;
			owner(hc_headlessClient) publicVariableClient "hc_processMissionObjects";
		} else { // Fallback to server
			[] call hc_fnc_loadMissionObjects;
		};
	};
};
