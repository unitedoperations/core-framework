
/* Player Initialization */

if (hasInterface) then {
	player createDiarySubject ["team_roster", "Roster"];
	[] spawn {
		private ["_cfgGroups", "_recordId"];
		_cfgGroups = missionConfigFile >> "Mission" >> "Mission" >> "Groups";
		_recordId = 1;
		while {true} do {
			private ["_side", "_date", "_diaryRecord"];
			_side = playerSide;
			_date = [date, "%2 %3, %1 %4:%5"] call core_fnc_formatDate;
			_diaryRecord = "";
			// Process all groups
			for "_i" from 0 to ((count _cfgGroups) - 1) do {
				private ["_groupCfg"];
				_groupCfg = _cfgGroups select _i;
				if (isClass(_groupCfg) && {toLower(getText(_groupCfg >> "side")) == toLower(str(_side))}) then {
					// Process group
					private ["_vehCfg"];
					_vehCfg = _groupCfg >> "Vehicles";
					for "_j" from 0 to ((count _vehCfg) - 1) do {
						private ["_unitCfg"];
						_unitCfg = _vehCfg select _j;
						if (isClass(_unitCfg)) then {
							// Process unit
							private ["_unit"];
							_unit = missionNamespace getVariable [([_unitCfg >> "text", ""] call core_fnc_getConfigValue), objNull];
							if (!isNil "_unit" && {!isNull _unit} && {alive _unit} && {tro_record_ai || {isPlayer _unit}} && {_unit getVariable ["tro_record", true]}) then {
								// Add unit line to global string
								private ["_ftColor", "_rank"];
								_ftColor = switch (if (tro_fireteam_colors) then {_unit getVariable ["ST_FTHud_assignedTeam", (assignedTeam _unit)]} else {""}) do {
									case "RED": {"#FF0000"};
									case "GREEN": {"#00FF00"};
									case "BLUE": {"#0000FF"};
									case "YELLOW": {"#FFFF00"};
									default {"#FFFFFF"};
								};
								if (isNil "_ftColor") then {_ftColor = "#FFFFFF"}; // Singleplayer other teams?
								_rank = switch (rankId _unit) do {
									case 1: {"Cpl"};
									case 2: {"Sgt"};
									case 3: {"Lt"};
									case 4: {"Cpt"};
									case 5: {"Maj"};
									case 6: {"Col"};
									default {"Pvt"};
								};
								if (_unit == leader(group _unit)) then {_diaryRecord = _diaryRecord + "<br />"};
								_diaryRecord = _diaryRecord + "<br />" + (if (tro_squad_indent && {_unit != leader(group _unit)}) then {"    "} else {""}) + format[tro_player_line_format,
									group(_unit),
									_j,
									name(_unit),
									([_unitCfg >> "description", ""] call core_fnc_getConfigValue),
									_rank,
									_ftColor
								];
							};
						};
					};
				};
			};
			if (_diaryRecord != "") then {
				private ["_sideText"];
				_sideText = [_side] call core_fnc_sideToText;
				player createDiaryRecord ["team_roster", [format[tro_record_title_format, _sideText, _date, _recordId], format[tro_record_header_format, _sideText, _date] + _diaryRecord]];
				_recordId = _recordId + 1;
			};
			uiSleep tro_loop_delay;
		};
	};
};
