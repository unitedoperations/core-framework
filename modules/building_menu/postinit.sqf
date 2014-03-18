
/* Initialize Self Interaction Menu */
[
	'selfInteraction',
	'deployMenu',
	'Build Menu',
	true,
	"_this call build_fnc_menuCondition",
	'Build Menu >',
	"",
	"",
	"Building / Deploy Menu for Base Construction"
] call fmh_fnc_addFlexiMenu;

/* Initialize Self Interaction Buttons */
private ["_structures"];
_structures = ["building_menu", "structures"] call core_fnc_getSetting;
for "_i" from 0 to ((count _structures) - 1) do {
	private ["_struct", "_name"];
	_struct = _structures select _i;
	_name = [_struct >> "name"] call core_fnc_getConfigValue;
	[
		'selfInteraction',
		_name,
		(compile format["[player, ['%1','%2','%3',%4,%5,%6]] spawn build_fnc_buildStruct;",
			_name,
			configName(_struct),
			[_struct >> "preview", configName(_struct)] call core_fnc_getConfigValue,
			[_struct >> "deploy_delay", 4] call core_fnc_getConfigValue,
			[_struct >> "deploy_distance", 3] call core_fnc_getConfigValue,
			[_struct >> "deploy_attitude", 0] call core_fnc_getConfigValue
		]),
		'deployMenu',
		true,
		true,
		"",
		(format["Build '%1' in front of your player", _name])
	] call fmh_fnc_addFlexiButton;
};