
/* Run server game-loop code */
if (isServer) then {
	[] spawn {
		sleep 1; // Wait until mission start
		while {true} do {
			#include "libraries\templates.h"
			#include "end_conditions.sqf"
			if ((gl_time_limit >= 0) && {time > gl_time_limit}) then {
				END_MISSION("Time Limit Reached");
			};
			sleep gl_loop_delay;
		};
	};
};
