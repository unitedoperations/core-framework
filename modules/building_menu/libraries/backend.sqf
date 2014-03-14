
build_fnc_defaultMenuCondition = {
	// Example Visible Condition for structure building menu
	if (isNil "build_timeLimit") then {
		build_timeLimit = ["building_menu", "time_limit"] call core_fnc_getSetting;
	};
	((alive player) && ((vehicle player) == player) && !building_playerBusy && {player getVariable ["building_menu_allow", false]} && {time <= build_timeLimit});
};

build_fnc_buildStruct = {
	#define REMOVE_ACTIONS	{_unit removeAction _x; _actions = _actions - [_x];} forEach _actions
	private ["_unit", "_params", "_name", "_class", "_previewClass", "_timeToDeploy", "_distance", "_flip",
			"_actions", "_pos", "_dir", "_vUp", "_buildObject"];
	_unit			= _this select 0;
	_params			= _this select 1;
	_name			= _params select 0;
	_class			= _params select 1;
	_previewClass	= _params select 2;
	_timeToDeploy	= _params select 3;
	_distance		= _params select 4;
	_flip			= _params select 5;
	_actions		= [];
	_pos			= 0;
	_dir			= 0;
	_vUp			= 0;
	_buildObject	= false;
	if (typeName(_flip) == "BOOL") then {
		if (_flip) then {
			_flip = 180;
		} else {
			_flip = 0;
		};
	};
	build_playerBusy = true;
	build_objectPlaced = nil;
	_actions = _actions + [(_unit addAction ["<t color='#0000ff'>Confirm Deployment</t>", "core\execute.sqf", {build_objectPlaced = true;}, 99999])];
	_actions = _actions + [(_unit addAction ["<t color='#ff0000'>Cancel Deployment</t>", "core\execute.sqf", {build_objectPlaced = false;}, 99998])];
	_previewObject = switch (build_previewMethod) do {
		case 0: {_previewClass createVehicleLocal [0, 0, 0]};
		case 1: {_previewClass createVehicle [0, 0, 0]};
	};
	while {(isNil "build_objectPlaced") && {alive _unit} && {(vehicle _unit) == _unit}} do {
		private ["_ppos", "_highZBound", "_startPos", "_endPos", "_intersects"];
		_pos = _unit modelToWorld [0, _distance, 0];
		_dir = ((((getDir _unit) % 360) + 360 + _flip) % 360);
		_ppos = getPosASL _unit;
		_highZBound = abs(((boundingBox _unit) select 1) select 2);
		_startPos = [(_ppos select 0), (_ppos select 1), ((_ppos select 2) + _highZBound)];
		_endPos = [(_ppos select 0), (_ppos select 1), ((_ppos select 2) - _highZBound)];
		_intersects = lineIntersectsWith [_startPos, _endPos, _unit, objNull, true];
		if ((count _intersects) > 0) then {
			_vUp = vectorUp (_intersects select 0);
		} else {
			_pos set [2, 0];
			_vUp = surfaceNormal _pos;
		};
		_previewObject setDir _dir;
		_previewObject setVectorUp _vUp;
		_previewObject setPosATL _pos;
		if (build_previewUpdateSpeed > 0) then {
			sleep (1 / build_previewUpdateSpeed);
		};
	};
	REMOVE_ACTIONS;
	if (isNil "build_objectPlaced") then {
		build_objectPlaced = false;
	};
	if (build_objectPlaced) then {
		_unit setVariable ["ACE_PB_Result", 0];
		[_timeToDeploy, [(format["Building %1...", _name])], true, true, _unit, true] spawn ace_progressbar;
		waitUntil {(_unit getVariable ["ACE_PB_Result", 0]) != 0};
		if ((_unit getVariable ["ACE_PB_Result", 0]) in [1]) then { // Success
			_buildObject = true;
		};
	};
	deleteVehicle _previewObject;
	if (_buildObject) then {
		private ["_object"];
		_object	= _class createVehicle [0, 0, 0];
		_object setDir _dir;
		_object setVectorUp _vUp;
		_object setPosATL _pos;
	};
	build_objectPlaced = nil;
	build_playerBusy = false;
};
