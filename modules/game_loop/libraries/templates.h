
#define END_MISSION(reason) \
	([reason, gl_time_limit] call es_fnc_endMission)

#define AREA_CLEARED(markerName, clearSide, minumum) \
	([markerName, clearSide, minumum] call gl_fnc_areaClear)

#define AREA_OCCUPIED(markerName, occupySide, minumum) \
	([markerName, occupySide, minumum] call gl_fnc_areaOccupied)

#define CASUALTIES_SUSTAINED(checkSide, limit) \
	([checkSide, limit] call gl_fnc_checkCasualties)

#define OBJECT_DESTROYED(object) \
	((isNull "object") || {!(alive object)})

#define OBJECT_IN_AREA(object, markerName) \
	([object, markerName] call cba_fnc_inArea)

#define TRIGGER_ACTIVATED(trigger) \
	(triggerActivated _trigger)
