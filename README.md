# ctfws-timer-web
A webpage to display info from the CtFwS timer and game status server

A more detailed description of the project can be found at
https://github.com/cmukgb/ctfws-timer-iot

## The Page
The page `timer.html` is entirely self contained. To deploy, just ssh to the
website server, navigate to `/home/www/activities/ctfws_timer`, and git pull.

## The Scripts
This repo also contains convenience scripts to send commands to the server.
They should be self-explanatory and will report usage if used with the wrong
number of arguments. To make things simpler, the startgame, endgame, and
message commands assume a timestamp of when you run the command. Also the
startgame command assumes the setup and game time specified in the CtFwS rules
(setup of 15 minutes, game time of 1 hour, jailbreaks every 15 minutes).

So as not to commit the password to a public repo, the scripts assume the
existence of a file `password.txt` containing the server password and nothing
else (no trailing endline). This file should be added to the local copy of the
repo any where the scripts are to be run.

As with all scripts, make sure to chmod the executable bit.

The commands are:
* `./no_game.sh` (sets there to be no current game)
* `./start_game.sh`
* `./end_game.sh`
* `./set_flags.sh`
* `./send_message.sh`
* `./send_player_message.sh`
* `./send_jail_message.sh`
* `./clear_messages.sh`

## The Broker
The MQTT broker is run from the kgb.club.cc.cmu.edu server. It should start
itself properly when the server boots up. The config is in `/etc/mosquitto/`.
To start, stop, or reload the broker, use `/etc/init.d/mosquitto`.
