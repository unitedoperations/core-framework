
/* Client Terrain */
_clientVD							= 3600;			// Client view distance
_clientTG							= 25;			// Client terrain grid (grass)

/* Server Terrain */
_serverVD							= 1200;			// Server view distance, affects AI and performance
_serverTG							= _clientTG;	// Server terrain grid (grass)

/* ACE Settings */
ace_settings_enable_vd_change		= true;			// Allow view distance change in ACE settings
ace_settings_enable_tg_change		= false;		// Allow terrain grid (grass) change in ACE settings
ace_viewdistance_limit				= _clientVD;	// Max view distance in ACE settings menu

/* ACE Wounds */
ace_sys_wounds_noai					= true; 		// Disable wounds for AI for performance
ace_wounds_prevtime					= (5 * 60); 	// ACE Wounds Unconscious Countdown Timer
ace_sys_wounds_withSpect			= nil;			// If player is unconscious, spectator script initializes
ace_sys_wounds_leftdam				= 0.07;			// How much damage is max left when healed in the field
ace_sys_wounds_all_medics			= false;		// Set to true for everyone considered as a medic
ace_sys_wounds_auto_assist			= true;			// Should (non medic) AI units automatically assist unconscious units in their group?
ace_sys_wounds_auto_assist_any		= false;		// Should (non medic) AI units assist any unconscious friendly units (not just in their group)?
ace_sys_wounds_no_medical_vehicles	= false;		// Should medical vehicles be usable as medical facilities?
ace_sys_wounds_no_medical_gear		= true;			// To disable the adding of medical gear

/* ACE Tracking */
ace_sys_tracking_markers_enabled	= false;		// Enable groups to be tracked
ace_sys_tracking_radio_required		= true;			// Exclude tracking of units not carrying a radio
ace_sys_tracking_gps_required		= true;			// Exclude tracking of units not carrying a gps

/* BIS Miscellaneous */
_clientRadioVolume					= 0;			// Change BIS radio volume
BIS_noCoreConversations				= true;			// Disable BIS Greeting Menu
enableRadio false;									// Disable BIS radio
enableEngineArtillery false;  						// Disable BI simple artillery computer
enableSaving [false, false];						// Disable Saving
