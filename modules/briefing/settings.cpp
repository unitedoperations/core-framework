
/*
	Syntax:
		class briefings
		{
			class side
			{
				briefing_file_name = "Briefing Page Title"; // File name without the SQF extension
			};
		};
	Notes:
		1. The 'briefings' class holds classes for each playable side to load briefings in.
		2. In each side class within the 'briefings' class holds a list of all of the pages to load.
		3. The file name (without '.sqf') of each briefing file will be the config name of each page.
		4. The text for each config name is the title of the page, which will be displayed in the diary.
		5. All briefing files must be placed within the 'briefings' folder in the module root.
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
