
aip_fnc_cacheUnitLocal = {
	private ["_unit"];
	_unit = _this select 0;
	_unit setVariable ["aip_cached", true];
	_unit disableAI "TARGET";
	_unit disableAI "AUTOTARGET";
	_unit disableAI "MOVE";
	_unit disableAI "ANIM";
	_unit disableAI "FSM";
	_unit enableSimulation false;
	_unit setVariable ["aip_cacheKilledEH", _unit addEventHandler ["killed", {_this call aip_fnc_uncacheUnit}]];
};

aip_fnc_loadUnitLocal = { // or uncache
	private ["_unit", "_killedEH"];
	_unit = _this select 0;
	_killedEH = _unit getVariable ["aip_cacheKilledEH", nil];
	if (!isNil "_killedEH") then {
		_unit removeEventHandler ["killed", _killedEH];
	};
	_unit enableSimulation true;
	_unit enableAI "TARGET";
	_unit enableAI "AUTOTARGET";
	_unit enableAI "MOVE";
	_unit enableAI "ANIM";
	_unit enableAI "FSM";
	_unit setVariable ["aip_cached", false];
};

aip_fnc_initHC = {
	private ["_unit"];
	_unit = _this select 0;
	hideObject _unit;
	_unit allowDamage false;
	aip_broadcastHC = _unit;
	publicVariableServer "aip_broadcastHC";
};

aip_fnc_distributeUnit = {
	private ["_unit", "_group"];
	_unit = _this select 0;
	_group = group(_unit);
	// TODO: Test this method
	if (_unit setOwner (_this select 1)) then {
		[_unit] join _group;
	};
};

aip_fnc_aiPerformanceLoop = {
	private ["_loopDelay"];
	_loopDelay = ["ai_performance", "cache_distance"] call core_fnc_getSetting;
	while {true} do {
		if (aip_enableCaching) then {
			private ["_maxDis"];
			_maxDis = [aip_cacheDistance] call core_fnc_toNumber;
			{ // forEach
				if (!(isPlayer _x) && {!(local _x)} && {_x getVariable ["aip_caching_allowed", true]}) then { // Cacheable
					if (_x getVariable ["aip_cached", false]) then { // Cached
						if (!isDedicated && {(_x distance player) <= _maxDis}) then { // Load unit
							[_x] call aip_fnc_loadUnitLocal;
						};
					} else { // Loaded (not cached)
						if (isDedicated || {(_x distance player) > _maxDis}) then { // Cache unit
							[_x] call aip_fnc_cacheUnitLocal;
						};
					};
				} else { // Non-cacheable
					if (_x getVariable ["aip_cached", false]) then { // Ensure load unit
						[_x] call aip_fnc_loadUnitLocal;
					};
				};
			};
		};
		if (isServer && {aip_enableDistribution} && {(count aip_headlessClients) > 0} && {local _x} && {_x getVariable ["aip_distribution_allowed", true]} && {!(isPlayer _x)}) then { // Distribute unit
			[_x, (aip_headlessClients select round(random((count aip_headlessClients) - 1)))] call aip_fnc_distributeUnit;
		};
		} forEach allUnits;
		uiSleep _loopDelay;
	};
};
