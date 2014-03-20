
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
		2 - Hint display duration seconds [number] (optional)
		3 - Hint silent [bool] (optional)
	Returns:
		Nothing [nil]
*/
core_fnc_hint = {
	if (hasInterface) then { // Don't do anything on non-GUI machines
		if (isNil "core_hintQueue") then {core_hintQueue = []};
		[core_hintQueue, _this] call core_fnc_push;
		if ((count core_hintQueue) == 1) then { // Run queue
			[] spawn {
				while {true} do {
					private ["_curHint", "_text"];
					_curHint = core_hintQueue select 0;
					[core_hintQueue, 0] call core_fnc_erase;
					_text = parseText(format([_curHint select 0] + ([_curHint, 1, ["ARRAY"], []] call core_fnc_param)));
					if ([_curHint, 3, ["BOOL"], false] call core_fnc_param) then { // Silent
						hintSilent _text;
					} else { // Normal
						hint _text;
					};
					if ((count core_hintQueue) == 0) exitWith {};
					uiSleep([_curHint, 2, ["SCALAR"], 5] call core_fnc_param);
				};
			};
		};
	};
};
