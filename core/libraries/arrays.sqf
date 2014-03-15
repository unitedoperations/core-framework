
/*
	Title: Array Function Library
*/

/*
	Function: core_fnc_push
	Author(s): Naught
	Description:
		Adds a value to the last of an array.
	Parameters:
		0 - Array [array]
		1 - Value to push [any]
	Returns:
		Array copy [array]
	Notes:
		1. This is faster than core_fnc_insert.
*/
core_fnc_push = {
	private ["_arr"];
	_arr = _this select 0;
	_arr set [(count _arr), (_this select 1)];
	_arr
};

/*
	Function: core_fnc_pop
	Author(s): Naught
	Description:
		Removes a value from the last of the array.
	Parameters:
		0 - Array [array]
	Returns:
		Array copy [array]
	Notes:
		1. This is faster than core_fnc_erase.
*/
core_fnc_pop = {
	private ["_arr", "_arrCount"];
	_arr = _this select 0;
	_arrCount = count _arr;
	if (_arrCount > 0) then {
		_arr resize (_arrCount - 1);
	};
	_arr
};

/*
	Function: core_fnc_insert
	Author(s): Naught
	Description:
		Inserts a value into the array at
		a specified index.
	Parameters:
		0 - Array [array]
		1 - Insert index [number]
		2 - Insert value [any]
	Returns:
		Array copy [array]
	Notes:
		1. This is slower than core_fnc_push.
		2. The lower the index, the higher the recursion.
*/
core_fnc_insert = {
	private ["_arr", "_idx", "_arrCount"];
	_arr = _this select 0;
	_idx = _this select 1;
	_arrCount = count _arr;
	for "_i" from 1 to (_arrCount - _idx) do {
		private ["_offset"];
		_offset = _arrCount - _i;
		_arr set [(_offset + 1), _offset];
	};
	_arr set [_idx, (_this select 2)];
	_arr
};

/*
	Function: core_fnc_erase
	Author(s): Naught
	Description:
		Erases a value from an array (preserves order).
	Parameters:
		0 - Array [array]
		1 - Index to erase [number]
	Returns:
		Array copy [array]
	Notes:
		1. This is slower than core_fnc_uErase.
*/
core_fnc_erase = {
	private ["_arr", "_arrCount"];
	_arr = _this select 0;
	_arrCount = count _arr;
	for "_i" from (_this select 1) to (_arrCount - 2) do {
		_arr set [_i, (_arr select (_i + 1))];
	};
	_arr resize [_arrCount - 1];
	_arr
};

/*
	Function: core_fnc_uErase
	Author(s): Naught
	Description:
		Erases a value from an array (unordered).
	Parameters:
		0 - Array [array]
		1 - Index to erase [number]
	Returns:
		Array copy [array]
	Notes:
		1. This is faster than core_fnc_erase.
*/
core_fnc_uErase = {
	private ["_arr", "_last"];
	_arr = _this select 0;
	_last = (count _arr) - 1;
	_arr set [(_this select 1), (_arr select _last)];
	_arr resize _last;
	_arr
};

/*
	Function: core_fnc_heapSort
	Author(s): Naught
	Description:
		Sorts an array using the heap-sort algorithm.
	Parameters:
		0 - Array [array]
		1 - Comparative function [code]
	Returns:
		Sorted array copy [array]
	Notes:
		1. This function is untested.
*/
core_fnc_heapSort = {
	private ["_fnc_swap", "_fnc_siftDown"];
	_fnc_swap = {
		private ["_array", "_pos1", "_pos2", "_temp"];
		_array = _this select 0;
		_pos1 = _this select 1;
		_pos2 = _this select 2;
		_temp = _array select _pos1;
		_array set [_pos1, (_array select _pos2)];
		_array set [_pos2, _temp];
	};
	_fnc_siftDown = {
		private ["_array", "_start", "_end", "_compFunc", "_root"];
		_array = _this select 0;
		_start = _this select 1;
		_end = _this select 2;
		_compFunc = _this select 3;
		_root = _start;
		while {((_root * 2) + 1) <= _end} do {
			private ["_child", "_swap"];
			_child = (_root * 2) + 1;
			_swap = _root;
			if (((_array select _swap) call _compFunc) < ((_array select _child) call _compFunc)) then {
				_swap = _child;
			};
			if (((_child + 1) <= _end) && ((_array select _swap) < (_array select (_child + 1)))) then {
				_swap = _child + 1;
			};
			if (_swap != _root) then {
				[_array, _root, _swap] call _fnc_swap;
				_root = _swap;
			};
		};
	};
	private ["_array", "_compFunc", "_start", "_end"];
	_array = _this select 0;
	_compFunc = [_this, 1, ["CODE"], {_this}] call core_fnc_param;
	_start = ((count _array) - 2) / 2;
	_end = (count _array) - 1;
	if ((count _array) > 1) then {
		while {_start >= 0} do {
			[_array, _start, _end, _compFunc] call _fnc_siftDown;
			_start = _start - 1;
		};
		while {_end > 0} do {
			[_array, _end, 0] call _fnc_swap;
			_end = _end - 1;
			[_array, 0, _end, _compFunc] call _fnc_siftDown;
		};
	};
	_array
};

/*
	Function: core_fnc_shellSort
	Author(s): rübe
	Description:
		A generic shell sort implementation.
		The original list does NOT get altered.
	Parameters:
		0 - Array [array]
		1 - Comparative function [string:code]
	Returns:
		Sorted array copy [array]
	Notes:
		1. Shellsort is not sensitive to the initial ordering of the
		given list. Hard to compare to other sorting methods but
		shellsort is often the method of choice for many sorting
		applications:
			- Acceptable runtime even for moderately large lists,
			(Sedgewick says up to "five thousand elements")
			- Yet very easy algorithm.
		2. To simply invert the sort order, pass {_this * -1} as
		second parameter (for numbers).
		3. Default sorting order is ASCENDING.
*/
core_fnc_shellSort = {
	private ["_list", "_selectSortValue", "_n", "_cols", "_j", "_k", "_h", "_t", "_i"];
	_list = +(_this select 0);
	_selectSortValue = { _this };
	if ((count _this) > 1) then
	{
	   if ((typeName (_this select 1)) == "CODE") then
	   {
		  _selectSortValue = _this select 1;
	   } else {
		  _selectSortValue = compile (_this select 1);
	   };
	};
	// shell sort
	_n = count _list;
	// we take the increment sequence (3 * h + 1), which has been shown
	// empirically to do well... 
	_cols = [3501671, 1355339, 543749, 213331, 84801, 27901, 11969, 4711, 1968, 815, 271, 111, 41, 13, 4, 1];
	for "_k" from 0 to ((count _cols) - 1) do
	{
	   _h = _cols select _k;
	   for [{_i = _h}, {_i < _n}, {_i = _i + 1}] do
	   {
		  _t = _list select _i;
		  _j = _i;
		  while {(_j >= _h)} do
		  {
			 if (!(((_list select (_j - _h)) call _selectSortValue) > 
				   (_t call _selectSortValue))) exitWith {};
			 _list set [_j, (_list select (_j - _h))];
			 _j = _j - _h;
		  };
		  _list set [_j, _t];
	   };
	};
	_list
};

/*
	Function: core_fnc_insertSort
	Author(s): rübe
	Description:
		A generic implementation of the insertion sorting algorithm (that's one 
		of the simplest there is). The original list does NOT get altered.
	Parameters:
		0 - Array [array]
		1 - Comparative function [string:code]
	Returns:
		Sorted array copy [array]
	Notes:
		1. This sorting algorithm is very sensitive to the initial ordering of 
		the given list and thus only efficient for small/mostly-sorted 
		lists (we swap only adjacent elements!). Use another one for 
		large/totally unsorted lists (e.g. core_fnc_shellSort).
		2. Sedgewick says: "In short, insertion sort is the method of choice
		for `almost sorted` files with few inversions: for such files, it
		will outperform even the sophisticated methods [...]"   
		3. Scenarios:
			- Best case: O(n)
			- Worst case: O(n^2)
		4. To simply invert the sort order, pass {_this * -1} as
		second parameter (for numbers).
		5. Default sorting order is ASCENDING
*/
core_fnc_insertSort = {
	private ["_list", "_selectSortValue", "_item", "_i", "_j"];
	_list = +(_this select 0);
	_selectSortValue = { _this };
	if ((count _this) > 1) then
	{
	   if ((typeName (_this select 1)) == "CODE") then
	   {
		  _selectSortValue = _this select 1;
	   } else {
		  _selectSortValue = compile (_this select 1);
	   };
	};
	// insert sort
	for "_i" from 1 to ((count _list) - 1) do
	{
	   _item = +(_list select _i);
	   _j = 0;
	   for [{_j = _i}, {_j > 0}, {_j = _j - 1}] do
	   {
		  if (((_list select (_j - 1)) call _selectSortValue) < (_item call _selectSortValue)) exitWith {};
		  _list set [_j, (_list select (_j - 1))];
	   };
	   _list set [_j, _item];
	};
	_list
};
