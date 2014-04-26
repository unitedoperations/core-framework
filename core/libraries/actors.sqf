
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
	Returns:
		Actor [object]
*/

core_fnc_createActor = {
	if (!isNil "core_actors_mainGroup") then {
		private ["_actor"];
		_actor = core_actors_mainGroup createUnit ["logic", [0,0,0], [], 0, "NONE"];
		_actor setVariable ["core_actors_owner", core_clientId, true];
		_actor setVariable ["core_actors_messageHandler", (_this select 0), false];
		_actor
	} else {
		LOG_WARNING("core_fnc_createActor", "Attempted to create actor before the main actor group was initialized!");
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
	private ["_actor", "_message"];
	_actor = _this select 0;
	_message = _this select 1;
	if (local _actor) then {
		_message spawn (_actor getVariable "core_actors_messageHandler");
	} else {
		private ["_owner"];
		_owner = _actor getVariable "core_actors_owner";
		core_actors_newMessage = [_actor, _message];
		if (_owner < 0) then {
			publicVariableServer "core_actors_newMessage";
		} else {
			(_actor getVariable "core_actors_owner") publicVariableClient "core_actors_newMessage";
		};
	};
};

/*
	Function: core_fnc_allActors
	Author(s): Naught
	Description:
		Returns all actors in the current mission.
	Parameters:
		None
	Returns:
		Actor list [array]
*/

core_fnc_allActors = {
	if (!isNil "core_actors_mainGroup") then {
		units core_actors_mainGroup
	} else {
		LOG_WARNING("core_fnc_allActors", "Attempted to list actors before the main actor group was initialized!");
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
		(_val select 1) spawn (_actor getVariable "core_actors_messageHandler");
	};
};
