
Headless Client Module Readme
-----------------------------

The headless client module automatically sends units, marked as below, to any available headless clients.

A headless client is a GUI-less Arma game instance which connects to the server for the sole purpose of
processing AI and other such features to relieve strain from the server application.

This allows AI to react much quicker and to act much smarter, for the system to support a much higher
concurrent level of AI, and for the server to run at a faster pace, reducing lag.

## Usage

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
