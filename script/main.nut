dofile ("decui/decui.nut"); 
dofile ("translater.nut");
dofile ("lobby.nut");



GUI.SetMouseEnabled(true);

function errorHandling(err) {
    local stackInfos = getstackinfos(2);

    if (stackInfos) {
        local locals = "";

        foreach(index, value in stackInfos.locals) {
            if (index != "this")
                locals = locals + "[" + index + "] " + value + "\n";
        }

        local callStacks = "";
        local level = 2;
        do {
            callStacks += "*FUNCTION [" + stackInfos.func + "()] " + stackInfos.src + " line [" + stackInfos.line + "]\n";
            level++;
        } while ((stackInfos = getstackinfos(level)));

        local errorMsg = "AN ERROR HAS OCCURRED [" + err + "]\n";
        errorMsg += "\nCALLSTACK\n";
        errorMsg += callStacks; 
        errorMsg += "\nLOCALS\n";
        errorMsg += locals;

        Console.Print(errorMsg);
    }    
}   

seterrorhandler(errorHandling);



UI.Data({ 
    pList = [{Name = "Players"}]
    Language = "English"
    Entrance = true
});

local wrapper = GUI.GetScreenSize();

function Script::ScriptLoad() {
    Hud.RemoveFlags (HUD_FLAG_CASH|HUD_FLAG_CLOCK|HUD_FLAG_HEALTH|HUD_FLAG_WEAPON|HUD_FLAG_WANTED|HUD_FLAG_RADAR);
   

    UI.Sprite({
        id = "entrance_page"   
        file = "main.png" 
        RelativeSize = ["100%", "100%"]
        flags = GUI_FLAG_DISABLED
    })
     createLobby ();
}

function Server::ServerData(Stream) {
    local string = Stream.ReadString(), integer = Stream.ReadInt(); 
    local separator = split (string ",");
    switch (integer) {
        case 1: {
            local e = [{Name = "Players"}];
            foreach (playerId in separator) {
                if (World.FindPlayer (playerId.tointeger ())){
                    e.push (World.FindPlayer (playerId.tointeger ()));                    
                }
            }
            UI.setData ("pList", e);
            playerList (e.len () == 1 ? [{Name = "Players"}, World.FindLocalPlayer()] : e);
        }
        break;

        case 2: {
            World.FindLocalPlayer ().drawToPlayerScreen (separator [0].tointeger (),separator [1].tointeger (),separator [2],separator [3]);
        }
        break;

        case 3: {
           Console.Print(separator [0] + " " + separator [1])
           drawBoard (true);
        }
        break;
    }
}

function wordsToScreen (word_one, word_two, word_three) {
    UI.Canvas({
        id = "before-starting"   
        align="center"
        RelativeSize = ["50%", "65%"]
        Color= Colour(20,20,20,200)
        border = {}
        children = [
            UI.Canvas({
                id           = "before-starting-wrapper"
                RelativeSize = ["40%", "20%"]
                align        = "center"
                move = {up = "5%" }
                children = [
                    UI.Label({ 
                        id = "before-starting-text"
                        Text = "elije una palabra"
                        FontSize = wrapper.Size.X * 0.015
                        FontFlags = GUI_FFLAG_BOLD | GUI_FFLAG_NOAA
                    })

            ]})

            UI.Button({
                id = "before-starting-word1"  
                Text = word_one
                align = "center"
                FontSize = wrapper.Size.X * 0.01
                RelativeSize = ["15%", "10%"]
                move = {left = "30%"}
                onClick = function() {
                }
            })
            UI.Button({
                id = "before-starting-word2"  
                Text = word_two
                align = "center"
                FontSize = wrapper.Size.X * 0.01
                RelativeSize = ["15%", "10%"]
                onClick = function() {
                }
            })
            UI.Button({
                id = "before-starting-word3"  
                Text = word_three 
                align = "center"
                FontSize = wrapper.Size.X * 0.01
                move = {right = "30%"}
                RelativeSize = ["15%", "10%"]
                onClick = function() {
                }
            })
        ]
    }) 
}

function drawBoard (await) {
    local disabled = GUI_FLAG_NONE;
    UI.Draw ({
        id = "drawboard"
        RelativeSize = ["50%", "65%"]
        border = {color = Colour (0,0,0)}
        onBrushMove = function (x,y,Id,wrapperId) {
            dataToServer (x + "," + y + "," + Id + "," + wrapperId, 1);
        }
    });
    
    UI.Canvas({
        id = "draw-bar",
        context = this,
        Color = Colour (255,255,255),   
        align = "center",
        flags = GUI_FLAG_MOUSECTRL | disabled
        RelativeSize = ["70%", "6%"]
        move = {up = "36%", left = "10%"}
        border = {color = Colour (0,0,0)}

        children = [
            UI.Label({
                id = "wordToGuess"  
                Text = "-------" 
                FontSize = wrapper.X * 0.015
                align = "center"
                move = {right = "20%"}
            })
            UI.Label({
                id = "Timer"  
                Text = "Time left: 100" 
                FontSize = wrapper.X * 0.015
                align = "mid_left"
                move = {right = "2%"}
            })
        ]
      
    });

    local e = UI.Slider({
        id = "sliderDemoID"
        direction = "vertical"  //
        align = "center"
        buttonAlign = "right" //left | right
        buttonColour = Colour (255,0,2)

        buttonWidth = 0 // button width
        Size = VectorScreen (wrapper.X*0.07,wrapper.Y*0.1) 

        onValue = function (value) {
            //Console.Print(value)
        }    
        move = {right = "30%",down = "25%" }
    })
    .attachToShadow ()

    local c = UI.Sprite({ 
        id = "sand-watch"  
        file = "sand-watch.png" 
        RelativeSize = ["10%", "15%"]
        align = "center"  
        move = {right = "30%", down = "25%"}
    })  
/*
    local index = 0, h;
    h = Timer.Create(::UI, function (a){
        index++
    
        local decrease = 100 - index;
        if (::UI.Label ("Timer") != null) ::UI.Label ("Timer").Text = "Time left: " + decrease;
        if (decrease == 0) ::UI.Label ("Timer").Text = "Time Is Over";

        if (::UI.Slider ("sliderDemoID") != null) ::UI.Slider ("sliderDemoID").setValue (index);  
    
    }, 1500, 0, "a");*/
    
    local e = UI.getData("pList");
    playerList (e.len () == 1 ? [{Name = "Players"}, World.FindLocalPlayer()] : e);
}



function playerList (data) { 
    if (!UI.getData ("Entrance")) {
        if (UI.Canvas ("playerlist-wrapper")) UI.Canvas ("playerlist-wrapper").destroy ();
        local c = UI.Canvas({
            id = "playerlist-wrapper"   
            align="center"
            Color= Colour(150,150,150,100)
            move = {left = "35%"}
            RelativeSize = ["19.5%", "65%"]
            border = {}  
        })  
            
        local height = 40;
        foreach (p in data) {
            local points = 0;
            if (p.Name == "Players") points = "Points"
    
            local label = UI.Label ({
                id = "displayName" + p.Name
                Text = p.Name
                FontSize = wrapper.X * 0.01
                Position = VectorScreen(10, p.Name == "Players" ? 20 : height)
            })
            
            local points = UI.Label ({
                id = "displayPoints" + p.Name 
                Text = points
                FontSize = wrapper.X * 0.01
                Position = VectorScreen(wrapper.X * 0.15, p.Name == "Players" ? 20 : height)
            })
            
            c.add (points, false);
            c.add (label, false);
            height += wrapper.Y * 0.022;
        }
    }
}



function Player::drawToPlayerScreen (x,y, Id, wrapperId) {
    local wrapper = UI.Canvas (wrapperId);
    if (wrapper) {
        local b  = UI.Canvas({
            id = Id,
            context = this,
            Color = Colour (0,255,255),   
            Size = VectorScreen (10, 10)
            flags = GUI_FLAG_MOUSECTRL
        });
        
        b.Pos.X = x-wrapper.Pos.X; 
        if (b.Pos.X <= 0) b.Pos.X = 0;
        if (b.Pos.X >= wrapper.Size.X - b.Size.X) b.Pos.X = wrapper.Size.X - b.Size.X;

        b.Pos.Y = y-wrapper.Pos.Y; 
        if (b.Pos.Y <= 0) b.Pos.Y = 0;
        if (b.Pos.Y >= wrapper.Size.Y - b.Size.Y) b.Pos.Y = wrapper.Size.Y - b.Size.Y;

        wrapper.AddChild(b)
    }
}

function dataToServer ( ... )
{
    local stream = Stream ();
    foreach( val in vargv ) 
    {
        switch(typeof val)
        {
            case "string":
            stream.WriteString( val );
            break;
            
            case "integer":
            stream.WriteInt( val );
            break;

            case "float":
            stream.WriteFloat( val );
            break;
        }
    }
    Server.SendData( stream );
}
