
/* Setup automatic synchronization */
if (isServer) then {
	if (["sync_time", "auto_sync_time", true] call core_fnc_getSetting) then {
		[] spawn {
			private ["_delay"];
			_delay = ["sync_time", "auto_sync_time_delay"] call core_fnc_getSetting;
			while {true} do {
				syt_serverDate = date;
				publicVariable "syt_serverDate";
				uiSleep _delay;
			};
		};
	};
} else {
	if (time > 0) then { // JIP
		[] call core_fnc_synchronizeTime;
	};
};
