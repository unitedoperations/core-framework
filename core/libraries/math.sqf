
/*
	Title: Math Function Library
*/

/*
	Function: core_fnc_modDegrees
	Author(s): Naught
	Description:
		Rounds a degree value to 0 <= X <= 360.
	Parameters:
		0 - Degree number [number]
	Returns:
		Modulated degree [number]
*/

core_fnc_modDegrees = {
	(((_this select 0) % 360) + 360) % 360
};

/*
	Function: core_fnc_dirTo
	Author(s): Naught
	Description:
		Calculates the direction to a position from a position.
	Parameters:
		0 - From object or position [any]
		1 - To object or position [any]
	Returns:
		Direction in degrees [number]
*/

core_fnc_dirTo = {
	private ["_from", "_to"];
	_from = [_this select 0] call core_fnc_getPos;
	_to = [_this select 1] call core_fnc_getPos;
	[((_to select 0) - (_from select 0)) atan2 ((_to select 1) - (_from select 1))] call core_fnc_modDegrees
};

/*
	Function: core_fnc_roundDecimal
	Author(s): Naught
	Description:
		Rounds a numerical value to a certain number of decimal places.
	Parameters:
		0 - Decimal number [number]
		1 - Decimal places [number]
	Returns:
		Rounded decimal [number]
*/

core_fnc_roundDecimal = {
	private ["_prec"];
	_prec = 10^(_this select 1);
	round((_this select 0) * _prec) / _prec
};

/*
	Function: core_fnc_decHasBin
	Author(s): Naught
	Description:
		Returns whether a decimal number contains a specific
		binary number (power of 2).
	Parameters:
		0 - Decimal number [number]
	Returns:
		Decimal has binary number [bool]
*/

core_fnc_decHasBin = {
	private ["_decimal", "_binary", "_return"];
	_decimal	= _this select 0;
	_binary		= _this select 1;
	_return		= false;
	
	if (_binary != 0) then {
		if (_decimal == _binary) then {_return = true};
		
		if (_decimal > _binary) then {
			if (((log(_binary) / log(2)) % 1) == 0) then {
				if (floor((_decimal / _binary) % 2) == 1) then {
					_return = true;
				};
			} else {
				if (((_binary % 1) == 0) && ((_decimal % 1) == 0)) then {
					private ["_i"];
					_i = 0;
					_return = true;
					
					while {_binary > 0} do {
						if (((_binary mod 2) == 1) && ((_decimal mod 2) != 1)) exitWith {_return = false};
						_binary = floor(_binary / 2);
						_decimal = floor(_decimal / 2);
						_i = _i + 1;
					};
				};
			};
		};
	};
	_return
};

/*
	Function: core_fnc_decToBinArr
	Author(s): Naught
	Description:
		Converts a decimal number to a binary array.
	Parameters:
		0 - Decimal number [number]
	Returns:
		Binary array [array]
*/

core_fnc_decToBinArr = {
	private ["_decimal", "_return"];
	_decimal	= _this select 0;
	_return		= [];
	
	if ((_decimal % 1) == 0) then { // Needs to be a whole number 
		private ["_i"];
		_i = 0;
		
		while {_decimal > 0} do {
			_return set [_i, (_decimal mod 2)];
			_decimal = floor(_decimal / 2);		// (_decimal - _rem) / 2
			_i = _i + 1;
		};
	};
	_return
};

/*
	Function: core_fnc_random
	Author(s): Naught
	Description:
		Generates a pseudo-random number.
	Parameters:
		0 - Seed [number] (optional)
	Returns:
		Random number [number]
*/

core_fnc_random = {
	(((2^8) + 1) * (if ((count _this) > 0) then {_this select 0} else {random(2^16)}) + ((2^11) + 1)) mod (2^16);
};

/*
	Section: Deprecated Functions
*/

DEPRECATE(core_fnc_rand,core_fnc_random);
