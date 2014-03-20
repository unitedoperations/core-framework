
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

/* ACE Tracking */
ace_sys_tracking_radio_required		= false;		// Black vehicle tracking marker, require Radio
ace_sys_tracking_markers_enabled	= true;			// Black vehicle tracking marker global enabled

/* BIS Miscellaneous */
_clientRadioVolume					= 0;			// Change BIS radio volume
BIS_noCoreConversations				= true;			// Disable BIS Greeting Menu
enableRadio false;									// Disable BIS radio
enableEngineArtillery false;  						// Disable BI simple artillery computer
enableSaving [false, false];						// Disable Saving
