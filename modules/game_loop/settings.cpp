
/* Generic Settings */

gl_loop_delay = 15; // Seconds; How often to run the game loop check.

/* Template Settings */

class templates
{
	class time_limit
	{
		enabled = 1;
		end_screen_message = "";
		time_limit = 300; // Seconds; How much in-game time should elapse before mission end.
	};
	class casualties
	{
		enabled = 1;
		end_screen_message = "";
		/* Note: For below, a percent larger than 100 will mean it will never lose */
		blufor_limit = 80; // Percent; Portion of the initial force to be lost for the mission to end.
		opfor_limit = 80; // Percent; Portion of the initial force to be lost for the mission to end.
		independent_limit = 101; // Percent; Portion of the initial force to be lost for the mission to end.
		civilian_limit = 101; // Percent; Portion of the initial force to be lost for the mission to end.
	};
};
