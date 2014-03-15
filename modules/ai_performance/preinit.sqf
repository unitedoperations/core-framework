
/* Load Settings */
aip_enableCaching = ["ai_performance", "enable_caching", true] call core_fnc_getSetting;
aip_enableDistribution = ["ai_performance", "enable_distribution", true] call core_fnc_getSetting;
aip_cacheDistance = ["ai_performance", "cache_distance"] call core_fnc_getSetting;

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
