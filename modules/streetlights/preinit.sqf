
#define STOPLIGHT_OFFSET 3 // Meters

/* Load Libraries */
#include "libraries\backend.sqf"

/* Server Initialization */
if (isServer) then {

	// Module init
	private ["_debug"];
	_debug = true;
	
	// Load roads
	private ["_mapInfo", "_roadList"];
	_mapInfo = call core_fnc_getMapInfo;
	_roadList = (_mapInfo select 0) nearRoads (_mapInfo select 2);
	
	// Process roads
	stl_trackedIntersections = [];
	{ // forEach
		private ["_connectedRoads"];
		_connectedRoads = roadsConnectedTo _x;
		
		if ((count _connectedRoads) > 2) then { // Add traffic stops
			private ["_intersection"];
			_intersection = _x;
			
			if (true) then { // Add stoplights
				private ["_stoplights"];
				_stoplights = [];
				
				{ // forEach
					[_stoplights,
						[_intersection, _x, "Land_Stoplight01", STOPLIGHT_OFFSET, 90, true] call stl_fnc_createStreetlight
					] call core_fnc_push;
				} forEach _connectedRoads;
				
				_intersection setVariable ["stl_stoplights", _stoplights, false];
			};
			
			[stl_fnc_intersectionMessageHandler, _intersection, grpNull] call core_fnc_createActor;
			[stl_trackedIntersections, _intersection] call core_fnc_push;
		};
	} forEach _roadList;
	
};
