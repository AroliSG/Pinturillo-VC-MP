
const rooms = require('./room.js');
const map = new Map ();

function onServerLoadScripts() {
}

function onServerInitialise() {
    server.setServerName ( "Pinturillo - Draw and Play" );
    server.setGameModeText ( "JavaScript 0.1" );
    
    server.setOption(15, false); // join messages
}
 
function onServerUnloadScripts() {

}

function onServerShutdown() {

}


function onPlayerSpawn(player) {
   

}


function onPlayerConnect(player) {
    player.setName ("Player" + player.getId ());
    server.sendClientMessageToAll (`Player ${[player.getId ()]} joined the server.`);
}

function onPlayerDisconnect(player, reason) {
    // deleting player from tab list
    server.getAllPlayers().forEach(p => {
        let pList;
        server.getAllPlayers().forEach(p => {
            if (map.has (p.getId ()) && map.has (player.getId ()) && map.get (p.getId ()) == map.get (player.getId ()) && pList) pList +=  "," + p.getId ();
            else if (map.has (p.getId ()) && map.has (player.getId ()) && map.get (p.getId ()) == map.get (player.getId ()) && pList == null) pList = p.getId ().toString ();
        });
        if (map.has (p.getId ()) && map.has (player.getId ()) && map.get (p.getId ()) == map.get (player.getId ())) {
            dataToClient (p, pList, 1);

            if (pList.split(',').length == 1) {
                map.delete (map.get (player.getId ()) + "count"); 
                if (map.has (map.get (player.getId ()))) map.delete (map.get (player.getId ())); // deleting saved draws
            }
            else map.set (map.get (player.getId ()) + "count", pList.split(',').length); // re-counting players once one left the game
        }
    });
    map.delete (player.getId ())
    
    // if player was a drawer, game will restart.
    // let replyback = rooms.general.start (string, player);
    // dataToClient (player, replyback, 3);
}
 
function onPlayerMessage(player, message) {
    let Timer = rooms.general.Timer;
    if (player.data.word != undefined && player.data.word.toLowerCase() == message.toLowerCase ()) {
        console.log (Timer [map.get (player.getId ())] )
    }
}
 
function onClientScriptData(player, stream) {
    let string = stream.readString(), integer = stream.readInt(); 
    switch (integer) {
        // drawing on guesser screen.
        case 1: {
            server.getAllPlayers().forEach(p => {
                if (p.getId () != player.getId ()) {
                   if (map.has (p.getId ()) && map.get (p.getId ()) == string.split(',') [4]) dataToClient (p, string.substring(0, string.lastIndexOf(",")), 2);
                }
            });

            // detecting in which room the new player joined en,es,pt
            if (map.has (string.split(',') [4]) && map.has (player.getId ()) && map.get (player.getId ()) == string.split(',') [4]) {

                let target = map.get (string.split(',') [4]);
                if (target && target.data.drawPos) target.data.drawPos += string.substring(0, string.lastIndexOf(",")) + "|";
                else if (target) target.data.drawPos = string.substring(0, string.lastIndexOf(","));
            }
        }
        break;

        // words to screen for the drawer
        case 2: {
            let replyback = rooms.general.start (string, player, map);
            dataToClient (player, replyback, 3);

            // drawing on new player screen
            if (map.has (string)) { 
                let target = map.get (string);
                if (target.data.drawPos) {
                    let draw = target.data.drawPos.split('|');
                    draw.forEach (drawPos => { dataToClient (player, drawPos, 2); });
                }
            }

            server.getAllPlayers().forEach(p => {
                let pList;
                server.getAllPlayers().forEach(p => {
                    if (map.has (p.getId ()) && map.get (p.getId ()) == string && pList) pList +=  "," + p.getId ();
                    else if (map.has (p.getId ()) && map.get (p.getId ()) == string && pList == null) pList = p.getId ().toString ();
                });
                if (map.has (p.getId ()) && map.get (p.getId ()) == string) {
                    dataToClient (p, pList, 1);

                    map.set (string + "count", pList.split(',').length); // counting players
                }
            });
        }
        break;

        // activate timer, set word to guess
        case 3: {
            let Timer = rooms.general.Timer;
            player.data.Timer = setInterval( () => {
                // interval of time
                server.getAllPlayers().forEach(p => {
                    player.data.word = string;
                    dataToClient (p, Timer [map.get (player.getId ())].toString (), 4);
                });

                // increasing time
                Timer [map.get (player.getId ())] --;

                //Time is Over
                if (Timer [map.get (player.getId ())]== -1) {
                    clearInterval(player.data.Timer);

                    Timer [map.get (player.getId ())] = 100;

                    // restarting game
                    server.getAllPlayers().forEach(p => {
                        if (map.get (map.get (p.getId ())).getId () != p.getId ()) {
                            if (map.has (map.get (player.getId ()))) map.delete (map.get (player.getId ())); // deleting saved draws
                            
                        } 
                    });
                } 
            }, 1000);


        }
    }
}


function restartgame () {

}


function onPlayerEnterVehicle(player, vehicle, slot) {
}

function onPlayerExitVehicle(player, vehicle) {
}

function onVehicleExplode(vehicle) {
}

function onPlayerCommand(player, message) {
}

function onPlayerCrashReport(player, crashLog) {
}

function onCheckPointExited(checkPoint, player) {
}

function onCheckPointEntered(checkPoint, player) {
}

function onPickupRespawn(pickup) {
}

function onPickupPicked(pickup, player) {
}

function onPickupPickAttempt(pickup, player) {
    return true;
}

function onObjectTouched(object, player) {
}

function onObjectShot(object, player, weaponId) {
}

function onVehicleRespawn(vehicle) {
}

function onVehicleUpdate(vehicle, updateType) {
}

function onPlayerSpectate(player, spectated) {
}

function onPlayerKeyBindUp(player, keyBindIndex) {
}

function onPlayerKeyBindDown(player, keyBindIndex) {
}

function onPlayerPrivateMessage(player, recipient, message) {
    return true;
}

function onPlayerAwayChange(player, isAway) {
}

function onPlayerEndTyping(player) {
}

function onPlayerBeginTyping(player) {
}

function onPlayerGameKeysChange(player, oldKeys, newKeys) {
}

function onPlayerCrouchChange(player, isCrouching) {
}

function onPlayerOnFireChange(player, isOnFire) {
}

function onPlayerActionChange(player, oldAction, newAction) {
}

function onPlayerStateChange(player, oldState, newState) {
}

function onPlayerNameChange(player, oldName, newName) {
}

function onPlayerRequestEnterVehicle(player, vehicle, slot) {
    return true;
}

function onPlayerDeath(player, killer, reason, bodyPart) {
}

function onPlayerRequestSpawn(player) {
    return true;
}

function onPlayerRequestClass(player, classIndex) {
}

function onPlayerModuleList(player, list) {
}

function onIncomingConnection(name, password, ip) {
    return name;
}

function dataToClient (p, ...args)
{
    const stream = new VCMPStream();   
    args.forEach(data => {
        switch(typeof data)
        {
            case "string": stream.writeString (data); break;
            case "number": stream.writeInt (data); break;
        }
    })
    stream.send(p);
}

