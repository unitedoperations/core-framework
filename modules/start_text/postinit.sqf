//The output for example: 17:23 on the 22/02 is:
//1723H, 22nd February
//_area
//_island

st_fnc_displayText = {
	private["_month", "_hour", "_min", "_area", "_island"];

	_area = _this select 0;	
	_island = _this select 1;
	
	_month = switch (date select 1) do {
		case 1: {"January"};
		case 2: {"February"};
		case 3: {"March"};
		case 4: {"April"};
		case 5: {"May"};
		case 6: {"June"};
		case 7: {"July"};
		case 8: {"August"};
		case 9: {"September"};
		case 10: {"October"};
		case 11: {"November"};
		case 12: {"December"};
	};

	_day = format["%1th", date select 2];
	if (date select 2 < 4 || date select 2 > 20) then {
		_day = switch ((date select 2) mod 10) do {
			case 1: {format["%1st", date select 2]};
			case 2: {format["%1nd", date select 2]};
			case 3: {format["%1rd", date select 2]};
		};
	};

	if (date select 3 < 10) then {
		_hour = "0" + format["%1", date select 3];
	}
	else {
		_hour = format["%1", date select 3];
	};

	if (date select 4 < 10) then {
		_min = "0" + format["%1H", date select 4];
	}
	else {
		_min = format["%1H", date select 4];
	};

	[format["%1, %2 %3", (_hour + _min), _day, _month], _area, _island] spawn BIS_fnc_infoText;
};

#include "settings.sqf"