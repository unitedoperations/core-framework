
rs_fnc_channelGen = {
	private ["_channelCount", "_base", "_seed", "_channelStep", "_seedStep",
			"_startChannel", "_seedFunc", "_channels"];
	_channelCount	= _this select 0;
	_base			= _this select 1;
	_seed 			= _this select 2;
	_channelStep 	= _this select 3;
	_seedStep		= _this select 4;
	_startChannel	= [_this, 5, ["SCALAR"], 0] call core_fnc_param;
	_seedFunc		= [_this, 6, ["CODE"], core_fnc_rand] call core_fnc_param;
	
	_channels = [];
	for "_i" from _startChannel to (_channelCount - 1) do {
		private ["_freq"];
		_seed = [_seed, _base, _channelCount, _i] call _seedFunc;
		_freq = _base + (_i * _channelStep) + (round(_seed % (_channelStep / _seedStep)) * _seedStep);
		_channels set [(_i - _startChannel), _freq];
	};
	_channels
};

rs_fnc_setChannelDefaults = {
	private ["_seed", "_freqStep", "_seedStep"];
	_seed		= _this select 0;
	_freqStep	= [_this, 1, ["SCALAR"], 5] call core_fnc_param;
	_seedStep	= [_this, 2, ["SCALAR"], 0.025] call core_fnc_param;
	
	// Long Range Radios
	_base = 30;
	_channelCount = 100;
	_channels = [_channelCount, _base, _seed, _freqStep, _seedStep] call rs_fnc_channelGen;
	
	["ACRE_PRC148", _channels] call acre_api_fnc_setDefaultChannels;
	["ACRE_PRC148_UHF", _channels] call acre_api_fnc_setDefaultChannels;
	["ACRE_PRC152", _channels] call acre_api_fnc_setDefaultChannels;
	["ACRE_PRC117F", _channels] call acre_api_fnc_setDefaultChannels;
	
	// PRC119 Work-Around
	_channels resize 6;
	
	["ACRE_PRC119", _channels] call acre_api_fnc_setDefaultChannels;
	
	// Short Range Radios
	_base = 2400;
	_channelCount = 16;
	_channels = [_channelCount, _base, _seed, _freqStep, _seedStep] call rs_fnc_channelGen;
	
	["ACRE_PRC343", _channels] call acre_api_fnc_setDefaultChannels;
};
