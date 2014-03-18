
/* Load backend functions */
gl_fnc_getTemplateSetting = {
	[
		((["game_loop", "templates"] call core_fnc_getSetting) >> (_this select 0) >> (_this select 1))
	] call core_fnc_getConfigValue;
};

/* Run server game-loop code */
if (isServer) then {
	[] spawn {
		private ["_loopDelay", "_templateCfg", "_templates"];
		_loopDelay = ["game_loop", "game_loop_delay"] call core_fnc_getSetting;
		_templateCfg = ["game_loop", "templates"] call core_fnc_getSetting;
		_templates = [];
		for "_i" from 0 to ((count _templateCfg) - 1) do {
			private ["_temp"];
			_temp = _templateCfg select _i;
			[_templates, [_temp, (compile preprocessFileLineNumbers ("modules\game_loop\templates\" + configName(_temp) + ".sqf"))]] call core_fnc_push;
		};
		sleep 0.01; // Wait until mission start
		while {true} do {
			{ // forEach
				if (call (_x select 1)) then {
					private ["_temp"];
					_temp = _x select 1;
					[
						([(_temp >> "end_screen_message"), configName(_temp)] call core_fnc_getConfigValue)
					] // TODO
				};
			} forEach _templates;
			uiSleep _loopDelay
		};
	};
};
