
/* Setup automatic synchronization */
if (isServer) then {
	if (st_auto_sync_time == 1) then {
		[] spawn {
			while {true} do {
				syt_serverDate = date;
				publicVariable "syt_serverDate";
				uiSleep st_auto_sync_time_delay;
			};
		};
	};
} else {
	if (time > 0) then { // JIP
		[] call core_fnc_synchronizeTime;
	};
};
