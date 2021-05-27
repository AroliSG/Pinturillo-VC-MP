
const room = require('./room.js');
const words = require('./words.js');

var rooms = [];

function onServerLoadScripts() {
    

}



function onServerInitialise() {
    server.setServerName ( "Pinturillo - Draw and Play" );
    server.setGameModeText ( "JavaScript - DP" );
    
    

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



function onClientScriptData(player, stream) {


    /*
     //reading a stream from the client
    
     console.log(stream.readString());
     console.log(stream.readFloat());
     console.log(stream.readInt());
     console.log(stream.readByte());
     
     
     //building a stream and sending it to the client
    
     const stream = new VCMPStream();
     stream.writeString("lalaya");
     stream.writeFloat(5.9);
     stream.writeInt(51);
     stream.writeByte(3);
     stream.send(player);
     */

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