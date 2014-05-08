
/* Run server game-loop code */
if (isServer) then {
	0 spawn {
		sleep 1; // Wait until mission start
		
		while {true} do {
			#include "libraries\templates.h"
			#include "end_conditions.sqf"
			
			if ((gl_time_limit >= 0) && {time > gl_time_limit}) exitWith {
				END_MISSION("Time Limit Reached");
			};
			
			sleep gl_loop_delay;
		};
	};
};
