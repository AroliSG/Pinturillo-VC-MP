const user = require("./user.js");

class room
{
    roomID = -1;
    Owner = null;
    Key = null;
    Members = null;
    Kicks = null;
    
    Draftsman = null;

    Word = null;
    Seconds = null; //Secs
    defaultSecs = 60;

    /*Type = Private or Public */
    constructor( id, owner, type, seconds )
    {
        roomID = id;
        Owner = owner.getName();
        ( type == 1 ?  Key = generateKey() : Key = "public" );
        defaultSecs = seconds;
        /*
        Members = user class;
        Kicks = save player UID.
        */

        Members = new Map([iterable]);
        Kicks = new Map([iterable]);

        Members.set(owner.getId(), user(owner, roomID))

        function onMessage(player, message)
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
    
        function addMember(player)
        {
            if ( Kicks.get(player.getUID()) ) return "pa su casa";
            else Members.set(player.getId(), user(player, this.roomID));
        }
    
        function delMember(player)
        {
            Members.delete(player.getId());
        }
    }


    /*
    Static = functions used by this class (private function)
    */
    static kickMember(player)
    {
        Kicks.set(player.getUID(), true);
        this.delMember(player);
    }
    
    static generateKey() {
        var result = [], characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789', charactersLength = characters.length;
        for ( var i = 0; i < 6; i++ ) result.push(characters.charAt(Math.floor(Math.random() *  charactersLength)));
        return result.join('');
    }

}



module.exports = room;