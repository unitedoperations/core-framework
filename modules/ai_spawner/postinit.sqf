
if (isServer) then {
	[] spawn {
		private ["_groups", "_conditions"];
		_groups = ["ai_spawner", "ais_groups"] call core_fnc_getSetting;
		_conditions = [];
		for "_i" from 0 to ((count _groups) - 1) do {
			private ["_grpCfg"];
			_grpCfg = _groups select _i;
			[_conditions, [_grpCfg, compile([(_grpCfg >> "condition"), "true"] call core_fnc_getConfigValue)]] call core_fnc_push;
		};
		while {(count _conditions) > 0} do {
			{ // forEach
				private ["_grpCfg"];
				_grpCfg = _x select 0;
				if (_grpCfg call (_x select 1)) then {
					private ["_units"];
					_units = [(_grpCfg >> "units"), []] call core_fnc_getConfigValue;
					if ((count _units) > 0) then {
						private ["_markers", "_markerCount", "_pos", "_group"];
						_markers = [(_grpCfg >> "markers"), []] call core_fnc_getConfigValue;
						_markerCount = count _markers;
						_pos = if (_markerCount > 0) then {
							getMarkerPos(_markers select round(random(_markerCount - 1)));
						} else {
							call compile([(_grpCfg >> "position"), "[0,0,0]"] call core_fnc_getConfigValue);
						};
						_group = createGroup(call compile([(_grpCfg >> "side"), "civilian"] call core_fnc_getConfigValue));
						{ // forEach
							_group createUnit [_x, _pos, [], 25, "NONE"];
						} forEach _units;
						_group call compile([(_grpCfg >> "init"), ""] call core_fnc_getConfigValue);
					};
					_conditions set [_forEachIndex, objNull];
				};
			} forEach _conditions;
			_conditions = _conditions - [objNull];
			uiSleep ais_condition_check_delay;
		};
	};
};
