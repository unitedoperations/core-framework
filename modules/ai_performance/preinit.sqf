
/* Load Libraries */
#include "libraries\backend.sqf"

/* Set Variables */
aip_debug_mode_enabled = [aip_debug_mode_enabled] call core_fnc_toBool;

/* Initialize Server */
if (isServer) then {
	aip_headlessClients = [];
	"aip_broadcastHC" addPublicVariableEventHandler {
		private ["_unit"];
		_unit = _this select 1;
		[aip_headlessClients, owner(_unit)] call core_fnc_push;
		_unit setVariable ["aip_ownerID", owner(_unit), true];
		_unit setVariable ["aip_hcKilledEH", _unit addEventHandler ["killed", {
			private ["_unit", "_clientID", "_killedEH"];
			_unit = _this select 0;
			_clientID = _unit getVariable ["aip_ownerID", nil];
			_killedEH = _unit getVariable ["aip_hcKilledEH", nil];
			if (!isNil "_clientID") then {
				aip_headlessClients = aip_headlessClients - [_clientID];
			};
			if (!isNil "_killedEH") then {
				_unit removeEventHandler ["killed", _killedEH];
			};
		}]];
	};
};
