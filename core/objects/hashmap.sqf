
/*
	Object: core_obj_hashMap
	Author(s): Naught
	Description:
		Constructs a hashmap-type object for
		SQF-based interaction.
	Syntax:
		_hashmap = ["new"] call core_obj_hashMap;
		["function"(, params)] call _hashmap;
		["delete", _hashmap] call core_obj_hashMap;
*/

CLASS("core_obj_hashMap") // Unique unordered map
	PRIVATE VARIABLE("array", "map");
	PUBLIC FUNCTION("","constructor") {
		#define DFT_MAP [[],[]]
		MEMBER("map",DFT_MAP);
	};
	PUBLIC FUNCTION("","deconstructor") {
		DELETE_VARIABLE("map");
	};
	PUBLIC FUNCTION("array","get") { // ["key", default], returns value (any)
		private ["_map", "_index"];
		_map = MEMBER("map",nil);
		_index = (_map select 0) find (_this select 0);
		if (_index >= 0) then {
			(_map select 1) select _index;
		} else {_this select 1};
	};
	PUBLIC FUNCTION("string","get") { // "key", returns value (any)
		private ["_args"];
		_args = [_this, nil];
		MEMBER("get",_args);
	};
	PUBLIC FUNCTION("array","insert") { // ["key", value], returns overwritten (bool)
		private ["_map", "_index"];
		_map = MEMBER("map",nil);
		_index = (_map select 0) find (_this select 0);
		if (_index >= 0) then {
			(_map select 1) set [_index, (_this select 1)];
			true;
		} else {
			_index = count (_map select 0);
			(_map select 0) set [_index, (_this select 0)];
			(_map select 1) set [_index, (_this select 1)];
			false;
		};
	};
	PUBLIC FUNCTION("string","erase") { // "key", returns success (bool)
		private ["_map", "_index"];
		_map = MEMBER("map",nil);
		_index = (_map select 0) find (_this select 0);
		if (_index >= 0) then {
			private ["_last"];
			_last = (count (_map select 0)) - 1;
			(_map select 0) set [_index, ((_map select 0) select _last)];
			(_map select 1) set [_index, ((_map select 1) select _last)];
			(_map select 0) resize _last;
			(_map select 1) resize _last;
			true;
		} else {
			false;
		};
	};
	PUBLIC FUNCTION("","copy") { // nil, returns hashmap (array)
		MEMBER("map",nil);
	};
	PUBLIC FUNCTION("array","copy") { // [hashMap], returns nothing (nil)
		MEMBER("map",_this);
	};
ENDCLASS;
