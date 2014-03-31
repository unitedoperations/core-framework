
/* Generic Settings */

gl_loop_delay = 15; // Seconds; How often to run the game loop check.

/*
	Section: Template Settings
	Notes:
		1. Sides are written here as strings such as "WEST", "EAST", "GUER", and "CIV".
*/

class templates
{
	class area_cleared
	{
		enabled = 0;
		clear_area = "marker_name"; // Must be rectangle or elipse.
		clear_sides[] = {"EAST"}; // Sides to be cleared out of the objective.
		clear_maximum = 0; // Maximum number of enemies to deem an area as clear
	};
	class area_occupied
	{
		enabled = 0;
		occupy_area = "marker_name"; // Must be rectangle or elipse.
		occupy_sides[] = {"WEST"}; // Sides to occupy the objective.
		occupy_force_percentage = 50; // Minimum [alive] percent of each side to occupy the objective.
	};
	class casualties
	{
		enabled = 1;
		/* Note: A percent of 0 will never cause a loss. Side percent casualties is found by (1 - limit). */
		blufor_limit = 20; // Percent; Minimum amount of the initial force left before mission will end.
		opfor_limit = 20; // Percent; Minimum amount of the initial force left before mission will end.
		independent_limit = 0; // Percent; Minimum amount of the initial left force before mission will end.
		civilian_limit = 0; // Percent; Minimum amount of the initial left force before mission will end.
	};
	class objects_destroyed
	{
		enabled = 0;
		objects_destroyed[] = {"opforCo", "opforCommandVeh"}; // May be units, vehicles, structures, etc.
	};
	class objects_in_area
	{
		enabled = 0;
		active_area = "markerName"; // Must be rectangle or elipse.
		objects_in_area[] = {"opforCo", "opforCommandVeh"}; // May be units, vehicles, structures, etc.
	};
	class time_limit
	{
		enabled = 1;
		time_limit = 300; // Seconds; How much in-game time should elapse before mission end.
	};
	class trigger_statuses
	{
		enabled = 0;
		/* Note: Only one trigger needs to be activated for mission to end. */
		active_triggers[] = {"bluforDetectedTrig1"};
	};
	class variable_conditions
	{
		enabled = 0;
		/*
			Notes:
				1. Only one condition needs to be activated for mission to end.
				2. Condition must return either nil for not activated or a string for the
				   end-mission description.
				3. Conditions must be string values, but will be run as code at run-time.
		*/
		variable_conditions[] = {"condVar1", "[] call my_fnc_checkCond"};
	};
};
