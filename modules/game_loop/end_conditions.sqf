
if (OBJECT_DESTROYED(SU25) && {AREA_CLEARED("enemy_area", EAST, 4)}) exitWith {
	END_MISSION("Force Recon has cleared the airfield and destroyed the Su-25 Frogfoot.");
};

if (CASUALTIES_SUSTAINED(WEST, 70)) exitWith {
	END_MISSION("Force Recon has sustained more than 70% casualties.");
};
