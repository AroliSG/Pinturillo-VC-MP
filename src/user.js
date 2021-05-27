class user
{
    ID = -1;
    room = -1;
    Points = -1;
    voteKick = -1;
    drawed = null;
    userName = null;
    Position = -1;

    wordAcerted = null;

    constructor(player, room, pos)
    {
        ID = player.getId();
        userName = player.getName();
        room = room;

        drawed = false;
        wordAcerted = false;
        voteKick = 0;
        Points = 0;
        Position = pos;
    }
}

module.exports = user;