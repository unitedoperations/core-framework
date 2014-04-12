
/* Initialize Variables */

private ["_clientVD", "_clientTG", "_serverVD", "_serverTG", "_clientRadioVolume", "_noCoreConversations"];

/* Load settings */
#include "settings.sqf"

/* Initialize Settings */
if (hasInterface) then { // Players
	setViewDistance _clientVD;
	setTerrainGrid	_clientTG;
	0 fadeRadio _clientRadioVolume;
	player setVariable ["BIS_noCoreConversations", _noCoreConversations, true];
} else { // Servers
	setViewDistance _serverVD;
	setTerrainGrid	_serverTG;
};
