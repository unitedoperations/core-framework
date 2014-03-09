
/*
	Title: RVE Function Library
	Notes:
		1. When updating the library, increment the
		below library register version number by one.
*/

/*
	Function: core_fnc_getPos
	Author(s): Naught
	Description:
		Gets the position of a thing.
	Parameters:
		0 - Thing [object:marker:array]
	Returns:
		Position [array]
*/
core_fnc_getPos = {
	private ["_thing"];
	_thing = _this select 0;
	switch (typeName _thing) do {
		case "OBJECT": {getPos _thing};
		case "STRING": {getMarkerPos _thing};
		case "ARRAY": {getWPPos _thing};
		default {[0,0,0]};
	};
};

/*
	Function: core_fnc_closestPlayerDis
	Author(s): Naught
	Description:
		Retrieves closest player distance.
	Parameters:
		0 - Reference thing [object:marker:array]
	Returns:
		Minimum distance [number]
*/
core_fnc_closestPlayerDis = {
	private ["_ref", "_minDis"];
	_ref = [_this select 0] call core_fnc_getPos;
	_minDis = -1;
	{ // forEach
		private ["_dis"];
		_dis = _x distance _ref;
		if ((_dis < _minDis) || {_minDis < 0}) then {
			_minDis = _dis;
		};
	} forEach (call CBA_fnc_players);
	_minDis
};

/*
	Function: core_fnc_sortObjectDistance
	Author(s): Naught
	Description:
		Sorts distances between an array of objects
		and a thing.
	Parameters:
		0 - Object array [object]
		1 - Reference thing [object:marker:array]
	Returns:
		Sorted array [array]
*/
core_fnc_sortObjectDistance = {
	private ["_refPos"];
	_refPos = [_this select 1] call core_fnc_getPos; // Can use in compFunc b/c of SQF scoping
	[(_this select 0), {_this distance _refPos}] call core_fnc_heapSort;
};

/*
	Function: core_fnc_unitVehPos
	Author(s): q1184/Rocko, Naught
	Description:
		States the current vehiclular
		position of a unit.
	Parameters:
		0 - Unit [object]
	Returns:
		Position type [array]
	Notes:
	1. Returns one of the following:
		["None"] - on foot
		["Commander"] - commander 
		["Gunner"] - gunner 
		["Driver"] - driver 
		["Cargo"] - cargo 
		["Turret", [turret path]] - turret
*/
core_fnc_unitVehPos = {
	#define __cfg (configFile >> "CfgVehicles" >> (typeof _v) >> "turrets")
	private ["_u","_v","_tc","_tp","_st","_stc","_ptp","_res","_fn"];
	_fn = {
		private ["_c","_tc","_ar","_fn","_ind","_cnt","_cur"];
		_c = _this select 0;
		_ar = _this select 1;
		_fn = _this select 2;
		_ind = _this select 3;
		_tc  = count _c;
		_cnt = -1;
		if (_tc > 0) then {
			for "_i" from 0 to (_tc-1) do {
				if (isclass (_c select _i)) then {
					_cnt = _cnt+1;
					_cur = +_ind;
					_cur set [count _cur,_cnt];
					_ar set [count _ar,_cur];
					if (isclass ((_c select _i)>>"turrets")) then {[(_c select _i)>>"turrets",_ar,_fn,_cur] call _fn};
				};
			};
		};
		_ar	
	};
	_u = _this;
	_v = vehicle _u;
	if (_u == _v) exitwith {["None"]};
	_tp = [__cfg,[],_fn,[]] call _fn;
	//diag_log _tp;
	_ptp = [];
	{if (_u == _v turretUnit _x) exitwith {_ptp = _x}} foreach _tp;
	if (count _ptp > 0) then {
		_res = ["Turret",_ptp];
	} else {
		_res = switch (true) do { // redundant for safety
			case (_u == commander _v): {["Commander"]};
			case (_u == gunner _v): {["Gunner"]};
			case (_u == driver _v): {["Driver"]};
			default {["Cargo"]};
		};
	};
	_res
};
