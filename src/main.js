
const rooms = require('./room.js');

function onServerLoadScripts() {
}

function onServerInitialise() {
    server.setServerName ( "Pinturillo - Draw and Play" );
    server.setGameModeText ( "JavaScript 0.1" );
    
    server.setOption(VCMP.Server.Option.AutoJoinMessages, false);
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
   
    // adding player to tab list
    server.getAllPlayers().forEach(p => {
        let pList;
        server.getAllPlayers().forEach(p => {
            if (pList) pList +=  "," + p.getId ();
            else pList = ""+p.getId ();
        })
        dataToClient (p, pList, 1);
    })
}


function onPlayerDisconnect(player, reason) {
    server.getAllPlayers().forEach(p => {
        // deleting player from tab list
        let pList;
        server.getAllPlayers().forEach(p => {
            if (pList) pList +=  "," + p.getId ();
            else pList = ""+p.getId ();
        });
        dataToClient (p, pList, 1);
    });
}


function onClientScriptData(player, stream) {
    let string = stream.readString(), integer = stream.readInt(); 
    switch (integer) {
        // drawing on guesser screen.
        case 1: {
            server.getAllPlayers().forEach(p => {
                if (p.getId () != player.getId ()) dataToClient (p, string, 2);
            });
        }
        break;

        // words to screen for the drawer
        case 2: {
            let replyback = rooms.general.start (string);
            dataToClient (player, replyback, 3);
        }
        break;
    }
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


function onPlayerMessage(player, message) {

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




/*
 the following 5 events are very CPU and memory intensive, if you're not using them,
 comment them out or just remove them and the server will not process them,
 saving you alot of resources CPU/memory-wise and overall improving server performance
 */
/*
 function onPlayerUpdate(player, updateType) {
 
 }
 
 function onPlayerMove(player, oldX, oldY, oldZ, newX, newY, newZ) {
 
 }
 
 
 function onPlayerHealthChange(player, lastHP, newHP) {
 
 }
 
 function onPlayerArmourChange(player, lastArmour, newArmour) {
 
 }
 
 function onPlayerWeaponChange(player, oldWep, newWep) {
 
 }
 */

function dataToClient (p, ...args )
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

