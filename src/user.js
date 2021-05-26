class user
{
    ID = -1;
    room = -1;
    Points = -1;
    voteKick = -1;
    drawed = null;
    userName = null;

    wordAcerted = null;

    constructor(player, room)
    {
        ID = player.getId();
        userName = player.getName();
        room = room;

        drawed = false;
        wordAcerted = false;
        voteKick = 0;
        Points = 0;
    }
}

module.exports = user;