
#define MARKER_CONFIG (missionConfigFile >> "Modules" >> "marker_control" >> "settings" >> "markers")

if (!isDedicated) then {
	for "_i" from 0 to (count MARKER_CONFIG) do {
		private ["_markerCfg"];
		_markerCfg = MARKER_CONFIG select _i;
		if (toLower(getText(_markerCfg >> "side")) != toLower(str(side player))) then {
			configName(_markerCfg) setMarkerAlphaLocal 0;
		};
	};
};