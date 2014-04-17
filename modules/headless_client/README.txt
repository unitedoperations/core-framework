
Headless Client Module Readme
-----------------------------

The headless client module automatically sends units, marked as below, to any available headless clients.

A headless client is a GUI-less Arma game instance which connects to the server for the sole purpose of
processing AI and other such features to relieve strain from the server application.

This allows AI to react much quicker and to act much smarter, for the system to support a much higher
concurrent level of AI, and for the server to run at a faster pace, reducing lag.

## Usage

First you must place down the headless client player unit, as shown below.

1. Place down a civilian unit somewhere out of the AO, so it won't be noticed. This will be the HC unit.
2. Name that unit `headless_client`, not for any reason but finding it in the `mission.sqm` file later.
3. Make the HC unit playable.
4. Copy this code and put it in the HC's init field:
	this setCaptive true; this allowDamage false; hideObject this; this setVariable ["ace_w_allow_dam",false];
5. Save the mission. Do not save again until after step #8.
6. Open your `mission.sqm` file, and search (CRTL+F) for the text `headless_client`.
7. Right under the line which reads `text="headless_client";`, copy and pase the following code:
	forceHeadlessClient=1;
8. Load your mission again in the editor.

To send a unit to the headless client, first make sure this module is enabled in the `modules.cpp` file.
Then do the following for each unit you want to send:

1. Create the AI in the editor and set all of the options you wish to set.
2. Set the probability of presence slider all of the way to zero. It is important that this value is actually
   zero and not 0.04 or similar.
3. The AI will now not spawn at mission start, but will be spawned either on the headless client when it
   connects, or on the server after 30 seconds as a fallback for when no headless clients connect.

## Notes

Currently, this system can only support one concurrent headless client. The first one to load into the game
will be used by the module.
