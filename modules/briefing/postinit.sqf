
/* Load Briefing(s) */
if (hasInterface) then {
	private ["_briefingCfg", "_briefingCount"];
	_briefingCfg = ["briefing", "briefings"] call core_fnc_getSetting;
	_briefingCount = count _briefingCfg;
	for "_i" from 1 to _briefingCount do {
		#define CFG_NAME_MATCHES [toLower(str(side player)), toLower(str(player))]
		private ["_briefing", "_cfgName"];
		_briefing = _briefingCfg select (_briefingCount - _i);
		_cfgName = toLower(configName(_briefing));
		if (_cfgName in CFG_NAME_MATCHES) then {
			private ["_pageCount"];
			_pageCount = count _briefing;
			for "_j" from 1 to _pageCount do {
				private ["_page"];
				_page = _briefing select (_pageCount - _j);
				player createDiaryRecord ["Diary", [
					getText(_page),
					call compile str(preprocessFile("modules\briefing\briefings\" + configName(_page) + ".sqf"))
				]];
			};
		};
	};
};
