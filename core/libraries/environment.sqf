
/*
	Title: Environment Function Library
*/

/*
	Function: core_fnc_processTerrain
	Author(s): Naught
	Description:
		Generates a height map based on a rectangular section of terrain.
	Parameters:
		0 - Bounding box [array] (optional)
		1 - Meter precision [number] (optional)
		2 - Output decimal places [number] (optional)
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
*/
core_fnc_processTerrain = {
	// Initialize benchmark code
	#ifdef BENCHMARK
		private ["_startTime", "_startText"];
		_startTime = diag_tickTime;
		_startText = format["Starting Benchmark: core_fnc_processTerrain [Time: %1]", _startTime];
		player globalChat _startText;
		diag_log text _startText;
	#endif
	
	// Process passed parameters
	private ["_boundingBox", "_precision", "_decPrecision"];
	_boundingBox = [_this, 0, ["ARRAY"], []] call core_fnc_param;
	_precision = [_this, 1, ["SCALAR"], 30] call core_fnc_param;
	_decPrecision = 10^([_this, 2, ["SCALAR"], 1] call core_fnc_param);
	
	// Retrieve map information
	private ["_mapCenter", "_mapEdge"];
	_mapCenter = getArray(configFile >> "CfgWorlds" >> worldName >> "centerPosition");
	_mapCenter set [2,0]; // 2d position
	_mapEdge = [(_mapCenter select 0) * 2, (_mapCenter select 1) * 2, 0];
	
	// Formulate bounding area
	private ["_bbX1", "_bbY1", "_bbX2", "_bbY2"];
	_bbX1 = [_boundingBox, 0, ["SCALAR"], 0] call core_fnc_param;
	_bbY1 = [_boundingBox, 1, ["SCALAR"], 0] call core_fnc_param;
	_bbX2 = [_boundingBox, 2, ["SCALAR"], (_mapEdge select 0)] call core_fnc_param;
	_bbY2 = [_boundingBox, 3, ["SCALAR"], (_mapEdge select 1)] call core_fnc_param;
	
	// Initialize process
	private ["_heightMap"];
	_heightMap = [];
	
	// Process terrain in bounds (x)
	for "_x" from _bbX1 to _bbX2 step _precision do {
		private ["_column"];
		_column = [];
		
		// Process terrain in bounds (y)
		for "_y" from _bbY1 to _bbY2 step _precision do {
			_column set [(count _column), [getTerrainHeightASL[_x,_y], _decPrecision] call core_fnc_roundDecimal];
		};
		
		// Add column data to height map
		_heightMap set [(count _heightMap), _column];
	};
	
	// Run benchmark code
	#ifdef BENCHMARK
		private ["_text"];
		_text = format["Finished Benchmark: core_fnc_processTerrain [Time: %1 sec | Size: %2 MB]", (diag_tickTime - _startTime), [([_heightMap] call core_fnc_estimateMemoryUsage) / 1048576, 3] call core_fnc_roundDecimal];
		player globalChat _text;
		diag_log text _text;
	#endif
	
	// Return resulting array
	[[_bbX1, _bbY1, _bbX2, _bbY2], _precision, _heightMap]
};
