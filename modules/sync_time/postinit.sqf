
/* Setup automatic synchronization */
if (isServer) then {
	if (syt_auto_sync_time == 1) then {
		[] spawn {
			while {true} do {
				syt_serverDate = date;
				publicVariable "syt_serverDate";
				uiSleep syt_auto_sync_time_delay;
			};
		};
	};
} else {
	if (time > 0) then { // JIP
		[] call syt_fnc_synchronizeTime;
	};
};
