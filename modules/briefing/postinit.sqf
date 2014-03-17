
/* Load Briefing(s) */
if (hasInterface) then {
	private ["_briefingCfg"];
	_briefingCfg = ["briefing", "briefings"] call core_fnc_getSetting;
	for "_i" from 0 to ((count _briefingCfg) - 1) do {
		private ["_briefing"];
		_briefing = _briefingCfg select _i;
		if (toLower(str(side player)) == toLower(configName(_briefing))) exitWith {
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
