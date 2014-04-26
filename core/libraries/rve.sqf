
/*
	Title: RVE Function Library
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
		Sorts distances between an array of objects and a thing.
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

/*
	Function: core_fnc_inArea
	Author(s): Olsen
	Description:
		Checks to see if a vehicle is within a marker area.
	Parameters:
		0 - Unit/Vehicle [object]
		1 - Marker [string]
	Returns:
		Object in area [bool]
*/

core_fnc_inArea = {
	private["_object", "_marker", "_pos", "_xSize", "_ySize", "_radius", "_result", "_x", "_y", "_temp"];
	_object = _this select 0;
	_marker = _this select 1;
	
	_pos = markerPos _marker;
	_xSize = (markerSize _marker) select 0;
	_ySize = (markerSize _marker) select 1;
	_radius = _xSize;
	
	if (_ySize > _xSize) then {
		_radius = _ySize;
	};
	
	_result = false;
	
	if ((_object distance _pos) <= (_radius * 1.5)) then {
		_x = (getPosASL _object) select 0;
		_y = (getPosASL _object) select 1;
		_angle = markerDir _marker;
		_x = _x - (_pos select 0);
		_y = _y - (_pos select 1);
		
		if (_angle != 0) then {
			_temp = _x * cos(_angle) - _y * sin(_angle);
			_y = _x * sin(_angle) + _y * cos(_angle);
			_x = _temp;
		};	
		
		if ((markerShape _marker) == "ELLIPSE") then {
			if (_xSize == _ySize) then {
				if ((_object distance _pos) <= _radius) then {
					_result = true;	
				};
			} else {
				if (((_x ^ 2) / (_xSize ^ 2) + (_y ^ 2) / (_ySize ^ 2)) <= 1) then {
					_result = true;
				};
			};
		} else {
			if ((abs _x) <= _xSize && (abs _y) <= _ySize) then {
				_result = true;
			};
		};
	};
	
	_result
};

/*
	Function: core_fnc_addHandleDamageEventHandler
	Author(s): Naught
	Description:
		Adds a generic damage event handler wrapper with support for custom handlers.
		Also factors armor and duplicate hits into processing.
	Parameters:
		0 - Unit/Vehicle [object]
		1 - Custom Handler [code] (optional)
	Returns:
		Event Handle [number]
*/

core_fnc_addHandleDamageEventHandler = {
	private ["_veh", "_vehCfg", "_eh"];
	_veh = _this select 0;
	_vehCfg = configFile >> "CfgVehicles" >> typeOf(_veh);
	
	// Init Static Vehicle Variables
	_veh setVariable ["hd_cfg", _vehCfg];
	_veh setVariable ["hd_cfg_total", _compCfg];
	_veh setVariable ["hd_dam_total", 0, true];
	
	// Init Vehicle Variables
	{ // forEach
		if (isClass _x) then {
			for "_i" from 0 to ((count _x) - 1) do {
				private ["_compCfg", "_name"];
				_compCfg = _x select _i;
				_name = getText(_compCfg >> "name");
				_veh setVariable [("hd_cfg_" + _name), _compCfg];
				_veh setVariable [("hd_dam_" + _name), 0, true];
			};
		};
	} forEach [
		_vehCfg >> "HitPoints", // All vehicles
		_vehCfg >> "Turrets" >> "HitPoints" // Cars, tanks, APCs, helicopters, ships, and planes
	];
	
	// Add Custom Handler
	if ((count _this) > 1) then {
		_veh setVariable ["hd_custom_handler", (_this select 1)];
	};
	
	// Add HD EH
	_eh = _veh addEventHandler ["HandleDamage", {
		private ["_veh", "_sel", "_dam", "_src"];
		_veh = _this select 0;
		_sel = _this select 1;
		_dam = _this select 2;
		_src = _this select 3;
		
		if (_sel == "") then {
			private [_lastHit];
			_lastHit = _veh getVariable ["hd_last_hit", [-1, objNull]];
			
			if (time <= ((_lastHit select 0) + 0.03) && {_src == (_lastHit select 1)}) then {
				_veh setVariable ["hd_ignore_hit", true];
			} else {
				_sel = "total";
				_this set [1, _sel];
				_veh setVariable ["hd_ignore_hit", false];
				_veh setVariable ["hd_last_hit", [time, _src]];
			};
		};
		
		if !(_veh getVariable ["hd_ignore_hit", false]) then {
			private ["_cfg", "_partCfg"];
			_cfg =  _veh getVariable ["hd_cfg", nil];
			_partCfg = _veh getVariable [("hd_cfg_" + _sel), nil];
			
			if (!isNil "_cfg" || {!isNil "_partCfg"}) then { // Process damage internally
				_this set [2, ((_dam - (_veh getVariable [("hd_dam_" + _sel), 0])) * ([_cfg >> "armor", 1] call core_fnc_getConfigValue) * ([_partCfg >> "armor", 1] call core_fnc_getConfigValue))];
				_dam = _this call (_veh getVariable ["hd_custom_handler", {_this select 2}]);
				
				if (isNil "_dam" || {typeName(_dam) != "SCALAR"}) then {_dam = 0};
				
				_veh setVariable [("hd_dam_" + _sel), _dam, true];
			};
			
			_dam
		} else {0};
	}];
	
	// Set EH Variable and Return
	_veh setVariable ["hd_eh_id", _eh];
	_eh
};
