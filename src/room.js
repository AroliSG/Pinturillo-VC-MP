const user = require("./user.js");
const words = require('./words.json');

class General {
    constructor () {
    }

    start = function (lang) {
        let drawer, index = server.getAllPlayers().length;
        if (index >= 2) drawer = server.getPlayer (Math.floor(Math.random() * index));
        
        return this.getRandomWords (lang) + "," + drawer;
    }

    getRandomWords = function (lang)
    {
        let words_list = words [lang];
        let catalogue = [];
        for(var i = 0; i < 3; i++)
        {
            var random = Math.floor(Math.random() * words_list.length);
            catalogue.push(words_list [random]);
        }
        return catalogue;
    }
}

class individual extends General
{
    roomID = -1;
    Owner = null;
    Key = null;
    Members = null;
    Kicks = null;
    Language = 0; 
    /*
    Languages:
    0 > English
    1 > Spanish
    2 > Portuguese
    */
    
    Draftsman = null;
    draftsPosition = null;

    Word = null;
    Seconds = null; //Secs
    defaultSecs = 60;

    /*Type = Private or Public */
    constructor( id, owner, type, seconds, lang )
    {
        roomID = id;
        Owner = owner.getName();
        ( type == 1 ?  Key = generateKey() : Key = "public" );
        defaultSecs = seconds;

        Language = lang;
        /*
        Members = user class;
        Kicks = save player UID.
        */

        Members = new Map([iterable]);
        Kicks = new Map([iterable]);

        Members.set(owner.getId(), user(owner, roomID, Members.length ))

        onMessage = function(player, message)
        {
            var user = Members.get(owner.getId());
            if ( user.wordAcerted == true )
            {
                console.log("[ROOM-"+roomID+"] [ACERTED-ROOM-CHAT]" + player.getName() + ": " + message);
            }
            else if ( message == Word && player.getId() != Draftsman.getId())
            {
                user.Points += (Seconds * 2);
                user.wordAcerted = true; 
    
                console.log("[ROOM] " + player.getName() + " score increase to " + user.Points);
            }
            else console.log("[ROOM-"+roomID+"] [GLOBAl-ROOM-CHAT]" + player.getName() + ": " + message);
        }
    
        addMember = function(player)
        {
            if ( Kicks.get(player.getUID()) ) return "pa su casa";
            else Members.set(player.getId(), user(player, this.roomID));
        }
    
        delMember = function(player)
        {
            Members.delete(player.getId());
        }
    }


    static kickMember(player)
    {
        Kicks.set(player.getUID(), true);
        this.delMember(player);
    }
    
    static generateKey() {
        var result = [], characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789', charactersLength = characters.length;
        for ( var i = 0; i < 6; i++ ) result.push(characters.charAt(Math.floor(Math.random() *  charactersLength) ));
        return result.join('');
    }
}

 
module.exports = {general: new General};