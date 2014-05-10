
/*
	Title: Environment Function Library
*/

/*
	Function: core_fnc_getMapInfo
	Author(s): Naught
	Description:
		Gets general information about the current map.
	Parameters:
		None.
	Returns:
		Map Information [array]
			0 - Map Center [array]
			1 - Map Edge (top-right point) [array]
			2 - Maximum radius from center [number]
			3 - Minimum radius from center [number]
*/

core_fnc_getMapInfo = {
	private ["_mapCenter"];
	_mapCenter = getArray(configFile >> "CfgWorlds" >> worldName >> "centerPosition");
	_mapCenter set [2,0]; // 2d position
	[
		_mapCenter, // Center
		[(_mapCenter select 0) * 2, (_mapCenter select 1) * 2, 0], // Top-right point
		(((_mapCenter select 0) max (_mapCenter select 1)) * sqrt(2)), // Max radius
		(((_mapCenter select 0) min (_mapCenter select 1)) * sqrt(2)) // Min radius
	]
};

/*
	Function: core_fnc_processTerrain
	Author(s): Naught
	Description:
		Generates a height map based on a rectangular section of terrain.
	Parameters:
		0 - Bounding box [array] (optional)
		1 - Meter precision [number] (optional)
		2 - Enable multi-processing [bool] (optional)
		3 - Output decimal places [number] (optional)
	Returns:
		Terrain Map [array]
			0 - Bounding box [array]
			1 - Meter precision [number]
			2 - Height map [array]
	Notes:
		1. Bounding box is in rectangular format [X1, Y1, X2, Y2], as shown below.
					+---------------+ (X2, Y2)
					|				|
					|				|
					|				|
		   (X1, Y1)	+---------------+
		2. Function is O(n^2), so spawn it if you need to.
		3. Multiprocessing utilizes a more efficient method for processing large data sets in a round-robin scheduled environment.
		   This will increase performance when processing terrain data in very small precisions or very large areas.
*/

core_fnc_processTerrain = {
	
	// Initialize benchmark code
	#ifdef BENCHMARK
		private ["_startTime", "_startText"];
		_startTime = diag_tickTime;
		_startText = format["[core_fnc_processTerrain] Starting Benchmark [TickTime: %1 sec]", _startTime];
		player globalChat _startText;
		diag_log text _startText;
	#endif
	
	// Process passed parameters
	private ["_boundingBox", "_precision", "_decPrecision"];
	_boundingBox = [_this, 0, ["ARRAY"], []] call core_fnc_param;
	_precision = [_this, 1, ["SCALAR"], 30] call core_fnc_param;
	_multiProcess = [_this, 2, ["BOOL"], true] call core_fnc_param;
	_decPrecision = [_this, 3, ["SCALAR"], 1] call core_fnc_param;
	
	// Retrieve map information
	private ["_mapEdge"];
	_mapEdge = (call core_fnc_getMapInfo) select 1;
	
	// Formulate bounding area
	private ["_bbX1", "_bbY1", "_bbX2", "_bbY2"];
	_bbX1 = [_boundingBox, 0, ["SCALAR"], 0] call core_fnc_param;
	_bbY1 = [_boundingBox, 1, ["SCALAR"], 0] call core_fnc_param;
	_bbX2 = [_boundingBox, 2, ["SCALAR"], (_mapEdge select 0)] call core_fnc_param;
	_bbY2 = [_boundingBox, 3, ["SCALAR"], (_mapEdge select 1)] call core_fnc_param;
	
	// Initialize process
	private ["_scripts", "_heightMap", "_fnc_processColumn"];
	_scripts = [];
	_heightMap = [];
	_fnc_processColumn = {
		
		// Record thread statistics
		#ifdef BENCHMARK
			private ["_startTime"];
			_startTime = diag_tickTime;
		#endif
		
		// Load local (passed) variables
		private ["_column", "_x", "_bbY"];
		_column = (_this select 0) select (_this select 1);
		_x = _this select 2;
		_bbY = _this select 3;
		
		// Process terrain in bounds (y)
		for "_y" from (_bbY select 0) to (_bbY select 1) step (_this select 4) do {
			_column set [(count _column), [getTerrainHeightASL[_x,_y], _decPrecision] call core_fnc_roundDecimal];
		};
		
		// Report thread statistics
		#ifdef BENCHMARK
			diag_log text format["[core_fnc_processTerrain] Thread execution finished. [BenchTime: %1 ms]", ((diag_tickTime - _startTime) * 1000)];
		#endif
	};
	
	// Process terrain in bounds (x)
	for "_x" from _bbX1 to _bbX2 step _precision do {
		private ["_index", "_args"];
		_index = count _heightMap;
		_args = [_heightMap, _index, _x, [_bbY1, _bbY2], _precision];
		_heightMap set [_index, []];
		
		// Load multi-process mechanism
		if (_multiProcess) then {
			[_scripts, (_args spawn _fnc_processColumn)] call core_fnc_push;
		} else {
			_args call _fnc_processColumn;
		};
	};
	
	// Wait until all columns have finished processing
	waitUntil {
		private ["_count"];
		_count = {!(scriptDone _x)} count _scripts;
		
		#ifdef BENCHMARK
			hintSilent format["[core_fnc_processTerrain]\nMP Threads Processing:\n%1 / %2", _count, (count _scripts)];
		#endif
		
		_count <= 0; // Return wait condition
	};
	
	// Run benchmark code
	#ifdef BENCHMARK
		private ["_text"];
		_text = format["[core_fnc_processTerrain] Finished Benchmark. [TickTime: %1 s | BenchTime: %2 sec | Size: %3 MB]",
			diag_tickTime,
			(diag_tickTime - _startTime),
			[([_heightMap] call core_fnc_estimateMemoryUsage) / 1048576, 3] call core_fnc_roundDecimal
		];
		player globalChat _text;
		diag_log text _text;
	#endif
	
	// Return resulting array
	[[_bbX1, _bbY1, _bbX2, _bbY2], _precision, _heightMap]
};
