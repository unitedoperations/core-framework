
stl_fnc_intersectionMessageHandler = {
	private ["_actor", "_message"];
	_actor = _this select 0;
	_message = _this select 1;
	
};

stl_fnc_createStreetlight = {
	private ["_center", "_road", "_lightClass", "_offset", "_dirOffset"];
	_center = _this select 0;
	_road = _this select 1;
	_lightClass = [_this, 2, ["STRING"], "Land_Stoplight01"] call core_fnc_param;
	_offset = [_this, 3, ["SCALAR"], 0] call core_fnc_param;
	_dirOffset = [_this, 4, ["SCALAR"], 0] call core_fnc_param;
	
	private ["_pos", "_dir", "_size"];
	_pos = getPosASL _road;
	_dir = [_road, _center] call core_fnc_dirTo;
	_size = sizeOf(typeOf _road) + _offset;
	
	if ([_this, 5, ["BOOL"], false] call core_fnc_param) then {
		private ["_border"];
		_border = createVehicle ["Sr_border", _pos, [], 0, "NONE"];
		_border setDir _dir;
		_border setPosASL _pos;
		_border setVectorUp (surfaceNormal _pos);
	};
	
	_pos set [0, (_pos select 0) + (cos(_dir) * _size)];
	_pos set [1, (_pos select 1) - (sin(_dir) * _size)];
	_pos set [2, getTerrainHeightASL(_pos)];
	
	private ["_light"];
	_light = createVehicle [_lightClass, _pos, [], 0, "NONE"];
	_light setPosASL _pos;
	_light setDir (_dir + _dirOffset);
	_light
};
