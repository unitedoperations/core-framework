es_fnc_displayEndScreen = {
	private["_scenario", "_timeLimt", "_teams", "_leftText", "_rightText", "_textSide", "_timeLimitText", "_endTitleText"];
	createDialog "DIA_ENDSCREEN";
	#define DIA 300
	#define BG 3000
	#define ENDTITLE 3001
	#define LEFT 3002
	#define RIGHT 3003

	_scenario = _this select 0;
	_timeLimt = _this select 1;
	_teams = _this select 2;

	disableUserInput true;

	{
		_x enableSimulation false;
	} forEach vehicles;

	_leftText = "";
	_rightText = "";
	_textSide = 0;
	{
		_temp = format["%1<br />Casualties: %2 out of %3<br />",(_x select 0), ((_x select 1) - (_x select 2)), (_x select 1)];

		if (count (_x select 3) != 0) then {
			_temp = _temp + "<br />Disabled assets:<br />";
			{
				_temp = _temp + format["%1<br />", _x];
			} forEach (_x select 3);
		};

		if (count (_x select 4) != 0) then {
			_temp = _temp + "<br />Destroyed assets:<br />";
			{
				_temp = _temp + format["%1<br />", _x];
			} forEach (_x select 4);
		};
		
		_temp = _temp + "<br />";
		
		if (_textSide == 0) then {
			_textSide = 1;
			_leftText = _leftText + _temp;
		} else {
			_textSide = 0;
			_rightText = _rightText + _temp;
		};
	} forEach _teams;

	if (_timeLimt > 0) then {
		_timeLimitText = format["Mission duration: %1 out of %2 minutes", (ceil(time / 60)), (_timeLimt / 60)];
	} else {
		_timeLimitText = "";
	};
	
	_endTitleText = format["%1<br />%2", _scenario, _timeLimitText];

	((findDisplay DIA) displayCtrl ENDTITLE) ctrlSetStructuredText parseText _endTitleText;
	((findDisplay DIA) displayCtrl LEFT) ctrlSetStructuredText parseText _leftText;
	((findDisplay DIA) displayCtrl RIGHT) ctrlSetStructuredText parseText _rightText;

	for "x" from 1 to 120 do {
		((findDisplay DIA) displayCtrl BG) ctrlSetBackgroundColor [0, 0, 0, (x * (1 / 120))];
		sleep(0.01);
	};

	sleep (15);
	disableUserInput false;
	endMission "END1";
};

es_fnc_addTeam = {
	private["_side", "_teamName", "_teamType", "_startSize"];
	_side = (_this select 0);
	_teamName = (_this select 1);
	_teamType = (_this select 2);
	
	_startSize = 0;
	if ((_teamType == "player") && {isMultiplayer}) then {
		_startSize = [_side] call es_fnc_countPlayers;
	} else {
		_startSize = [_side] call es_fnc_countAi;
	};
	
	sp_teams set [count sp_teams, [_side, _teamName, _teamType, _startSize]];
};

es_fnc_countPlayers = {
	private["_i"];
	_i = 0;
	{
		if (((side _x) == (_this select 0)) && {!(_x getVariable ["spectating", false]) && {!([_x] call ace_sys_wounds_fnc_isUncon) && {alive _x}}}) then {
			_i = _i + 1;
		};
	} forEach playableUnits;
	
	_i
};

es_fnc_countAi = {
	private["_i"];
	_i = 0;
	{
		if ((side _x) == (_this select 0)) then {
			_i = _i + 1;
		};
	} forEach allUnits;
	
	_i
};

es_fnc_endMission = {
	private["_stats"];
	_stats = [];
	
	{
		_side = (_x select 0);
		_teamName = (_x select 1);
		_teamType = (_x select 2);
		_startSize = (_x select 3);
		_destroyed = [];
		_disabled = [];
		{
			if ((_x getVariable "vehName") != "<null>" && {(_x getVariable "vehTeam") == _teamName}) then {
				if (!(alive _x)) then {
					_destroyed set [count _destroyed, (_x getVariable "vehName")];
				} else {
					if (!(canMove _x) && {!(canFire _x)}) then {
						_disabled set [count _disabled, (_x getVariable "vehName")];
					};
				};
			};
		} forEach vehicles;
		
		_currentSize = 0;
		if ((_teamType == "player") && {isMultiplayer}) then {
			_currentSize = [_side] call es_fnc_countPlayers;
		} else {
			_currentSize = [_side] call es_fnc_countAi;
		};
		
		_stats set [count _stats, [_teamName, _startSize, _currentSize, _disabled, _destroyed]];
	} forEach sp_teams;
	
	["endScreen", [(_this select 0), (_this select 1), _stats]] call CBA_fnc_globalEvent; // The timelimt needs to be implemented from game loop
};