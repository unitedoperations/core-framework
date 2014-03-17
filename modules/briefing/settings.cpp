
/*
	Syntax:
		class briefings
		{
			class type
			{
				briefing_file_name = "Briefing Page Title"; // File name without the SQF extension
			};
		};
	Notes:
		1. Sorry for so many notes! But it's a necessary evil :)
		2. The 'briefings' class holds classes for each playable side to load briefings in.
		3. A 'type' class is either the side or editor name of a unit for which to load the briefing for.
		   Some examples may be 'east', 'west', 'hvt_1', or 'player1'.
		4. A player may load more than one 'type' class, by which they will load pages from each class in a top-down order.
		   An example would be a player loading both the 'civilian' and 'hvt_1' classes.
		5. In each 'type' class within the 'briefings' class holds a list of all of the pages to load.
		6. The file name (without '.sqf') of each briefing file will be the config name of each page.
		7. The text for each config name is the title of the page, which will be displayed in the diary.
		8. All briefing files must be placed within the 'briefings' folder in the module root.
		9. Briefing pages will be loaded in reverse-order so pages show up in the diary in the same
		   order as listed within the class (pseudo-patch of Arma 'bug').
*/

/* Generic Settings */

class briefings
{
	class west
	{
		west_situation = "I. Situation";
		west_mission = "II. Mission";
		west_execution = "III. Execution";
		west_service_support = "IV. Service & Support";
		west_command_signal = "V. Command & Signal";
		mission_notes = "VI. Mission Notes";
	};
	class east
	{
		
	};
	class resistance
	{
		
	};
	class civilian
	{
		
	};
};
