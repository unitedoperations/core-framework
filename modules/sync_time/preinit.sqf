
/*
	Function: core_fnc_synchronizeTime
	Author(s): Naught
	Description:
		Synchronize the client's time with the server.
	Parameters:
		None.
	Returns:
		Nothing [nil]
*/
core_fnc_synchronizeTime = {
	if (!(isNil "core_clientId") && {core_clientId >= 0}) then {
		syt_requestServerTime = core_clientId;
		publicVariableServer "syt_requestServerTime";
	};
};

/* Set Current Date at Mission Start */
if (isServer || {time == 0}) then {
	[
		param_start_minute,
		param_start_hour,
		param_start_day,
		param_start_month
	] call core_fnc_setDate;
};

/* Load Time Synchronization Functionality */
if (isServer) then {
	"syt_requestServerTime" addPublicVariableEventHandler {
		syt_serverDate = date;
		(_this select 1) publicVariableClient "syt_serverDate";
	};
} else {
	"syt_serverDate" addPublicVariableEventHandler {
		setDate(_this select 1);
	};
};
