
/*
	Title: Actor Framework Library
	Notes:
		1. This framework utilizes the Actor-Oriented Programming (AOP) paradigm.
		   http://en.wikipedia.org/wiki/Actor_model
*/

/*
	Function: core_fnc_createActor
	Author(s): Naught
	Description:
		Creates an actor unit with the specified message handler.
	Parameters:
		0 - Message Handler Code [code]
		1 - Actor unit [object] (optional)
		2 - Actor group [group] (optional)
	Returns:
		Actor [object]
*/

core_fnc_createActor = {
	private ["_actor", "_group"];
	_actor = [_this, 1, ["OBJECT"], objNull] call core_fnc_param;
	_group = [_this, 2, ["GROUP"], core_actors_mainGroup] call core_fnc_param;
	if (!isNil "_group") then {
		if (isNull _actor) then {
			_actor = _group createUnit ["logic", [0,0,0], [], 0, "NONE"];
		} else {
			if (!(isNull _group) && {(group _actor) != _group}) then {
				[_actor] joinSilent _group;
			};
		};
		_actor setVariable ["core_actors_owner", core_clientId, true];
		_actor setVariable ["core_actors_messageHandler", (_this select 0), false];
		_actor
	} else {
		LOG_WARNING("core_fnc_createActor", "Attempted to create actor before the main actor group was created!");
		objNull
	};
};

/*
	Function: core_fnc_sendMessage
	Author(s): Naught
	Description:
		Sends a message a given actor, which is then executed on the actor's machine.
	Parameters:
		0 - Actor [object]
		1 - Message [any]
	Returns:
		Nothing [nil]
*/

core_fnc_sendMessage = {
	private ["_actor"];
	_actor = _this select 0;
	if (local _actor) then {
		+(_this) spawn (_actor getVariable "core_actors_messageHandler");
	} else {
		private ["_owner"];
		_owner = _actor getVariable ["core_actors_owner", -1];
		core_actors_newMessage = _this;
		if (_owner < 0) then {
			publicVariableServer "core_actors_newMessage";
		} else {
			_owner publicVariableClient "core_actors_newMessage";
		};
	};
};

/*
	Function: core_fnc_allActors
	Author(s): Naught
	Description:
		Returns all actors in the current mission.
	Parameters:
		0 - Actor group [group] (optional)
	Returns:
		Actor list [array]
*/

core_fnc_allActors = {
	private ["_group"];
	_group = [_this, 1, ["GROUP"], core_actors_mainGroup] call core_fnc_param;
	if (!isNil "_group") then {
		units _group
	} else {
		LOG_WARNING("core_fnc_allActors", "Attempted to list actors before the main actor group was created!");
		[]
	};
};

/*
	Section: Library Initialization
*/

if (isServer) then {
	core_actors_mainGroup = createGroup sideLogic;
	publicVariable "core_actors_mainGroup";
};

"core_actors_newMessage" addPublicVariableEventHandler {
	private ["_val", "_actor"];
	_val = _this select 1;
	_actor = _val select 0;
	if (local _actor) then {
		+(_val) spawn (_actor getVariable "core_actors_messageHandler");
	};
};
