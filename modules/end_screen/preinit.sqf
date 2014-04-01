es_fnc_trackAsset = {
    private["_asset"];
    _asset = vehicle (_this select 0);
    
    _asset setVariable ["vehName", (_this select 1)];
    _asset setVariable ["vehTeam", (_this select 2)];
};