
/*
	Notes:
		1. When using the default 'menu_visible_condition', all units which should be able to use the building menu
		   need to have this code run in their init field:
			this setVariable ["building_menu_allow", true];
*/

/* Generic Settings */

build_preview_update_speed = 30; // Hertz; Update speed of preview structure position. Affects performance. Set to 0 for constant updating.

build_preview_method = 0; // 0 = local, 1 = global; Global previews can use a lot of bandwidth if 'preview_update_speed' is set too high.

build_time_limit = 600; // Seconds; Amount of time in which players may use the build menu.

/* Advanced Settings */

build_menu_visible_condition = "_this call build_fnc_defaultMenuCondition"; // Allows for fine-tuning of the menu visible condition. Reference the backend library for the default function.

/* Building Settings */

class building_structures
{
	class Fort_RazorWire
	{
		name = "Barbed Wire";
		deploy_delay = 1; // Second(s)
		deploy_distance = 4; // Meter(s)
		deploy_attitude = 0; // Degree(s)
		preview = "Fort_RazorWirePreview";
	};
	class Land_fort_bagfence_long
	{
		name = "Sandbags (Straight)";
		deploy_delay = 1; // Second(s)
		deploy_distance = 3; // Meter(s)
		deploy_attitude = 0; // Degree(s)
		preview = "Land_fort_bagfence_longPreview";
	};
	class Land_fort_bagfence_round
	{
		name = "Sandbags (Round)";
		deploy_delay = 3; // Second(s)
		deploy_distance = 5; // Meter(s)
		deploy_attitude = 0; // Degree(s)
		preview = "Land_fort_bagfence_roundPreview";
	};
	class Land_fort_bagfence_corner
	{
		name = "Sandbags (Corner)";
		deploy_delay = 3; // Second(s)
		deploy_distance = 4; // Meter(s)
		deploy_attitude = 180; // Degree(s)
		preview = "Land_fort_bagfence_cornerPreview";
	};
	class Land_HBarrier3
	{
		name = "Hesco Barrier";
		deploy_delay = 2; // Second(s)
		deploy_distance = 4; // Meter(s)
		deploy_attitude = 0; // Degree(s)
		preview = "Land_HBarrier3ePreview";
	};
	class Land_HBarrier1
	{
		name = "Hesco Barrier (Short)";
		deploy_delay = 1; // Second(s)
		deploy_distance = 4; // Meter(s)
		deploy_attitude = 0; // Degree(s)
		preview = "Land_HBarrier1Preview";
	};
	class Land_HBarrier5
	{
		name = "Hesco Barrier (Long)";
		deploy_delay = 3; // Second(s)
		deploy_distance = 4; // Meter(s)
		deploy_attitude = 0; // Degree(s)
		preview = "Land_HBarrier5Preview";
	};
	class Land_HBarrier_large
	{
		name = "Hesco Barrier (Large)";
		deploy_delay = 5; // Second(s)
		deploy_distance = 6; // Meter(s)
		deploy_attitude = 0; // Degree(s)
		preview = "Land_HBarrier_largePreview";
	};
	class Land_WoodenRamp
	{
		name = "Wooden Ramp";
		deploy_delay = 2; // Second(s)
		deploy_distance = 0.5; // Meter(s)
		deploy_attitude = 180; // Degree(s)
		preview = "Land_WoodenRamp";
	};
	class Land_fort_rampart_EP1
	{
		name = "Rampart (Straight)";
		deploy_delay = 4; // Second(s)
		deploy_distance = 5; // Meter(s)
		deploy_attitude = 0; // Degree(s)
		preview = "Land_fort_rampartPreview";
	};
	class Land_fort_artillery_nest_EP1
	{
		name = "Rampart (Round)";
		deploy_delay = 5; // Second(s)
		deploy_distance = 8; // Meter(s)
		deploy_attitude = 0; // Degree(s)
		preview = "Land_fort_artillery_nestPreview";
	};
	class Land_fortified_nest_small_EP1
	{
		name = "Bunker (Small)";
		deploy_delay = 7; // Second(s)
		deploy_distance = 5; // Meter(s)
		deploy_attitude = 180; // Degree(s)
		preview = "Land_fortified_nest_smallPreview";
	};
	class Land_Fort_Watchtower_EP1
	{
		name = "Bunker (Tower)";
		deploy_delay = 15; // Second(s)
		deploy_distance = 8; // Meter(s)
		deploy_attitude = 180; // Degree(s)
		preview = "Land_Fort_Watchtower_EP1";
	};
	class Land_fortified_nest_big_EP1
	{
		name = "Bunker (Large)";
		deploy_delay = 20; // Second(s)
		deploy_distance = 8; // Meter(s)
		deploy_attitude = 180; // Degree(s)
		preview = "Land_fortified_nest_big_EP1";
	};
};
