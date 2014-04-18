
/* Generic Settings */

tro_loop_delay = 60; // Seconds; The delay between creating new rosters.

tro_record_ai = 0; // Binary; Whether to also record AI in the rosters.

tro_squad_indent = 0; // Binary; Whether to indent the records of all non-leader units.

tro_fireteam_colors = 1; // Binary; Whether to process fireteam colors for all units.

/* Advanced Settings */

/*
	Setting: tro_record_title_format
	Parameters:
		%1 = Side Name
		%2 = Extended Date
		%3 = Record ID
*/

tro_record_title_format = "%1 - %2 (%3)";

/*
	Setting: tro_record_header_format
	Parameters:
		%1 = Side Name
		%2 = Extended Date
*/

tro_record_header_format = "<br />%1 Roster<br /><br />--------------------------------------------------";

/*
	Setting: tro_player_line_format
	Parameters:
		%1 = Group Name
		%2 = Group Position
		%3 = Player Name
		%4 = Player Description
		%5 = Player Abbreviated Rank
		%6 = Fire Team Color
*/

tro_player_line_format = "<font color='%6'>- </font>%4 - %5. %3";
