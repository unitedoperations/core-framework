
/*
	Title: UI Function Library
*/

/*
	Function: core_fnc_hint
	Author(s): Naught
	Description:
		Hints a message to the player without overwriting other hints.
	Parameters:
		0 - Hint text [string]
		1 - Text format parameters [array] (optional)
		2 - Hint silent [bool] (optional)
		3 - Hint display duration seconds [number] (optional)
	Returns:
		Nothing [nil]
*/

core_fnc_hint = {
	if (hasInterface) then { // Don't do anything on non-GUI machines
		if (isNil "core_hintQueue") then {core_hintQueue = []};
		
		[core_hintQueue, _this] call core_fnc_push;
		
		if ((count core_hintQueue) == 1) then { // Run queue
			0 spawn {
				while {(count core_hintQueue) > 0} do {
					private ["_curHint", "_text"];
					_curHint = core_hintQueue select 0;
					_text = format([_curHint select 0] + ([_curHint, 1, ["ARRAY"], []] call core_fnc_param));
					
					if ([_curHint, 2, ["BOOL"], false] call core_fnc_param) then { // Silent
						hintSilent parseText(_text);
					} else { // Normal
						hint parseText(_text);
					};
					
					uiSleep([_curHint, 3, ["SCALAR"], (1.5 + ([_text] call core_fnc_timeToRead))] call core_fnc_param);
					[core_hintQueue, 0] call core_fnc_erase;
				};
			};
		};
	};
};
