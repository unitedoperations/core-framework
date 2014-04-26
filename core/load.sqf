
/* Load Definitions */
//#define BENCHMARK
#define C_DIARY_SUBJECT "core_docs"
#define C_DIARY_SUBJECT_NAME "Core Framework"
#define C_DIARY_BUFFER_FLUSH_INTERVAL 1 // second(s)
#define C_GET_LOG_OPT(cfg) (missionConfigFile >> "Core" >> cfg)

/* Load Headers */
#include "headers\macros.h"
#include "headers\oop.h"

/* Load Libraries */
#include "libraries\actors.sqf"
#include "libraries\arrays.sqf"
#include "libraries\chrono.sqf"
#include "libraries\config.sqf"
#include "libraries\conversions.sqf"
#include "libraries\diagnostics.sqf"
#include "libraries\environment.sqf"
#include "libraries\filesystem.sqf"
#include "libraries\math.sqf"
#include "libraries\mission.sqf"
#include "libraries\positioning.sqf"
#include "libraries\rve.sqf"
#include "libraries\strings.sqf"
#include "libraries\ui.sqf"

/* Load Objects */
#include "objects\hashmap.sqf"

/* Load Logging Configuration */
{ // forEach
	[_x, true] call core_fnc_setLogLevel;
} forEach ([(if (!isMultiplayer) then {C_GET_LOG_OPT("sp_log_level")} else {C_GET_LOG_OPT("mp_log_level")}), []] call core_fnc_getConfigValue);

core_logToDiary = [[C_GET_LOG_OPT("log_to_diary"), 0] call core_fnc_getConfigValue] call core_fnc_toBool;

/* Load Client ID Response System */
if (isServer) then {
	core_clientId = -1;
	"core_clientIdRequest" addPublicVariableEventHandler {
		private ["_clientId"];
		_clientId = owner(_this select 1);
		core_clientId = _clientId;
		_clientId publicVariableClient "core_clientId";
		core_clientId = -1;
	};
};

/* Load Player-Side Systems */
if (!isDedicated) then {
	[] spawn {
		
		/* Wait For Initialization */
		waitUntil {!isNull player};
		
		/* Request Client ID */
		if (isServer) then {
			core_clientId = owner(player);
		} else {
			LOG_INFO("Requesting Client ID.");
			core_clientIdRequest = player;
			publicVariableServer "core_clientIdRequest";
			waitUntil {!isNil "core_clientId"};
		};
		
		/* Load Log-To-Diary Pages */
		if (core_logToDiary) then {
			if (!(player diarySubjectExists C_DIARY_SUBJECT)) then {
				player createDiarySubject [C_DIARY_SUBJECT, C_DIARY_SUBJECT_NAME];
			};
		};
		
		/* Load Log-To-Diary System */
		[] spawn {
			while {true} do {
				if (core_logToDiary && {(count core_diaryLogQueue) > 0}) then {
					{ // forEach
						player createDiaryRecord [C_DIARY_SUBJECT, ["Diagnostics Log", _x]];
					} forEach core_diaryLogQueue;
					core_diaryLogQueue = []; // Okay while atomic SQF variables are guaranteed
				};
				uiSleep C_DIARY_BUFFER_FLUSH_INTERVAL;
			};
		};
	};
};
