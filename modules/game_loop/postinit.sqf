
/* Load backend functions */
gl_fnc_getTemplateSetting = {
	[
		((["game_loop", "templates"] call core_fnc_getSetting) >> (_this select 0) >> (_this select 1))
	] call core_fnc_getConfigValue;
};

/* Run server game-loop code */
if (isServer) then {
	[] spawn {
		private ["_templateCfg", "_templates"];
		_templateCfg = ["game_loop", "templates"] call core_fnc_getSetting;
		_templates = [];
		for "_i" from 0 to ((count _templateCfg) - 1) do {
			private ["_temp"];
			_temp = _templateCfg select _i;
			for "_j" from 0 to ((count _temp) - 1) do { // Load settings
				private ["_setting"];
				_setting = _temp select _j;
				if (!(configName(_setting) in ["enabled"]) && {!isClass(_setting)}) then {
					missionNamespace setVariable [
						format["gl_%1", configName(_setting)], 
						[_setting] call core_fnc_getConfigValue;
					];
				};
			};
			[_templates, [_temp, (compile preprocessFileLineNumbers ("modules\game_loop\templates\" + configName(_temp) + ".sqf"))]] call core_fnc_push;
		};
		sleep 1; // Wait until mission start
		while {true} do {
			{ // forEach
				private ["_res"];
				_res = call(_x select 1);
				if (!(isNil "_res")) then {
					#define TIME_LIMIT_TEMPLATE_CFG (missionConfigFile/"modules"/"game_loop"/"settings"/"templates"/"time_limit")
					[_res,
						(if (([TIME_LIMIT_TEMPLATE_CFG >> "enabled", 0] call core_fnc_getConfigValue) == 1) then {
							[TIME_LIMIT_TEMPLATE_CFG >> "time_limit", -1] call core_fnc_getConfigValue;
						} else {-1})
					] call es_fnc_endMission;
				};
			} forEach _templates;
			uiSleep gl_loop_delay;
		};
	};
};
