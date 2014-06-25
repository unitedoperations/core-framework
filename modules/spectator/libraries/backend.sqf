
sp_fnc_onKilled = {
	private ["_unit", "_killer", "_spectating"];
	_unit = _this select 0;
	_killer = _this select 1;
	_spectating = _unit getVariable ["spectating", false];
	
	if (hasInterface && {!_spectating}) then
	{
		_unit setVariable ["spectating", true, true];
		
		(if (sp_showKilledBy == 1) then {
			format["%1 killed you\nEntering spectator mode", (name _killer)];
		} else {
			"You are dead\nEntering spectator mode";
		}) spawn {
			titleText [_this, "BLACK", 0.2];
			uisleep 1;
			titleText [_this, "BLACK FADED", 10];
		};
		
		_unit spawn
		{
			waitUntil {alive player};
			player setVariable ["spectating", true, true];
			
			if (sp_leaveGroup == 1) then {[player] join grpNull};
			player setPos (call compile sp_spectatePos);
			player setCaptive true;
			//player addEventHandler ["HandleDamage", {false}];
			
			removeAllWeapons player;
			removeAllItems player;
			removeBackpack player;
			
			[true] call acre_api_fnc_setSpectator;
			[_this] call sp_fnc_spectate;
		};
	};
};

sp_fnc_spectate = {
	private["_keyDownNightVision", "_keyDownLeftClick", "_keyDownRightClick", "_keydownMouseWheel"];
	sp_target = _this select 0;
	sp_index = 0;
	
	sp_viewModes = ["none"];
	sp_viewMode = 1;
	
	if (sp_nightVision == 1) then {
		sp_viewModes set [count sp_viewModes, "nv"];
	};

	if (sp_thermalVision == 1) then {
		sp_viewModes set [count sp_viewModes, "ti0"];
		sp_viewModes set [count sp_viewModes, "ti1"];
	};

	if (sp_thirdPerson == 1) then {
		sp_camera = "camconstruct" camcreate (getPos sp_target);
		sp_camera setpos [((position sp_target) select 0) + ((sin (getdir sp_target)) * ( - 10)), ((position sp_target) select 1) + ((cos (getdir sp_target)) * (- 10)), ((position sp_target) select 2) + 2];
		sp_camera camConstuctionSetParams [getPos sp_target, 40000, 20000];
		sp_camera setdir (getdir sp_target);
		sp_camera cameraeffect ["internal", "back"];
		sp_thirdPerson = true;
	} else {
		cutText [name sp_target, "PLAIN DOWN"];
		sp_target switchCamera "EXTERNAL";
		sp_thirdPerson = false;
	};
	sleep 1;
	titleText ["", "BLACK IN", 0.2];
	
	if ((count sp_viewModes) > 1) then {
		_keyDownNightVision = (finddisplay 46) displayaddeventhandler ["keydown", "
			if ((_this select 1) in (actionkeys 'NightVision') && {sp_thirdPerson}) then {
				switch (sp_viewModes select sp_viewMode) do {
					case 'none': {
						camUseNVG false;
						false setCamUseTi 0;
					};
					case 'nv': {
						camUseNVG true;
					};
					case 'ti0': {
						true setCamUseTi 0;
					};
					case 'ti1': {
						true setCamUseTi 1;
					};
				};
				sp_viewMode = sp_viewMode + 1;
				if (sp_viewMode > ((count sp_viewModes) - 1)) then {
					sp_viewMode = 0;
				};
			};
		"];
	};
	
	if (sp_thirdPerson) then {
		_keyDownLeftClick = (finddisplay 46) displayaddeventhandler ["MouseButtonDown", "
			if (((_this select 1) == 0) && {!sp_thirdPerson}) then {
				sp_camera cameraeffect ['INTERNAL', 'BACK'];
				sp_camera setpos [((position sp_target) select 0) + ((sin (getdir sp_target)) * ( - 10)), ((position sp_target) select 1) + ((cos (getdir sp_target)) * (- 10)), ((position sp_target) select 2) + 2];
				sp_camera setdir (getdir sp_target);
				cutText [name sp_target, 'PLAIN DOWN'];
				sp_thirdPerson = true;
			};
		"];
			
		_keyDownRightClick = (finddisplay 46) displayaddeventhandler ["MouseButtonDown", "
			if (((_this select 1) == 1) && {sp_thirdPerson}) then {
				sp_camera cameraeffect ['TERMINATE', 'BACK'];
				sp_target switchCamera 'INTERNAL';
				cutText [name sp_target, 'PLAIN DOWN'];
				sp_thirdPerson = false;
			};
		"];
	};
		
	_keydownMouseWheel = (findDisplay 46) displayAddEventHandler ["mousezchanged", "
		_targets = [];
		{
			if (!(_x getVariable ['spectating', false]) && {(side _x) == sp_side}) then {
				_targets set [count _targets, _x];
			}
		} forEach playableUnits;
		
		if ((count _targets) > 0) then {
			if ((_this select 1) < 0) then {
				sp_index = sp_index - 1;
				if (sp_index < 0) then {
					sp_index = ((count _targets) - 1);
				};
			};
			if ((_this select 1) > 0) then {
				sp_index = sp_index + 1;
				if (sp_index >= (count _targets)) then {
					sp_index = 0;
				};
			};
			sp_target = _targets select (sp_index mod (count _targets));
		} else {
			sp_target = sp_body;
		};
		
		diag_log sp_index;

		cutText [name sp_target, 'PLAIN DOWN'];
		if (sp_thirdPerson) then {
				sp_camera setpos [((position sp_target) select 0) + ((sin (getdir sp_target)) * ( - 10)), ((position sp_target) select 1) + ((cos (getdir sp_target)) * (- 10)), ((position sp_target) select 2) + 2];
				sp_camera setdir (getdir sp_target);
		} else {
			sp_target switchCamera 'INTERNAL';
		};
	"];
};
