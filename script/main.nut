dofile("decui/decui.nut"); 
GUI.SetMouseEnabled(true);
Hud.RemoveFlags (HUD_FLAG_CASH|HUD_FLAG_CLOCK|HUD_FLAG_HEALTH|HUD_FLAG_WEAPON|HUD_FLAG_WANTED|HUD_FLAG_RADAR);

UI.Data({Language = "English"});
local wrapper = UI.Sprite({
    id = "entrance_page"   
    file = "main.png" 
    RelativeSize = ["100%", "100%"]
    flags = GUI_FLAG_DISABLED
})

local w = UI.Window({
    id = "main_entrance"  
    RelativeSize = ["40%", "25%"]
    Position =  VectorScreen (wrapper.Size.X * 0.32, wrapper.Size.Y * 0.58)

    RemoveFlags = GUI_FLAG_BORDER | GUI_FLAG_SHADOW | GUI_FLAG_WINDOW_TITLEBAR | GUI_FLAG_BACKGROUND 
    children = [
        UI.Canvas({
            id           = "nickname-wrapper"
            RelativeSize = ["40%", "20%"]
            align        = "center"
            move = { left = "25%", up = "30%" }
            children = [
                UI.Label({ 
                    id = "nickname"
                    Text = "Nick:"
                    FontSize = wrapper.Size.X * 0.015
                    FontFlags = GUI_FFLAG_BOLD | GUI_FFLAG_NOAA
                })
        ]}),
        UI.Canvas({ 
            id = "language-wrapper" 
            RelativeSize = ["40%", "20%"]
            align = "center"
            move = { left = "25%" }
            children = [
                UI.Label({ 
                    id = "language"
                    Text = "Language:"
                    FontSize = wrapper.Size.X * 0.015
                    FontFlags = GUI_FFLAG_BOLD | GUI_FFLAG_NOAA
                    
                })
        ]})
        UI.Button({  
            id = "start"  
            Text = "Play now"  
            RelativeSize = ["50%", "20%"]
            Colour = Colour (102,153,153)
            align = "center" 
            move = {down = "25%"}
            FontSize = wrapper.Size.X * 0.015
            FontFlags = GUI_FFLAG_BOLD
            onClick = function() {
               local edit = ::UI.Editbox("nickname-provider");
               if (strip(edit.Text) == "") {
                   ::translate ("Pinturillo2 - [#ffffff]Porfavor, introduce un nombre.", "Pinturillo2 - [#ffffff]Please, introduce a name." );
               }
               else {
                   UI.Window ("main_entrance").destroy (); // destroying entrance
                   ::sendTodrawBoard()
               }
            }
        }) 

        UI.Editbox({
            id = "nickname-provider"
            Colour = Colour (200,200,200)
            RelativeSize = ["50%", "20%"]
            RemoveFlags = GUI_FLAG_BORDER | GUI_FLAG_SHADOW
            align = "center"
            Text = "Player" + World.FindLocalPlayer ().ID
            FontSize = wrapper.Size.X * 0.015
            move = { up = "30%", right = "5%"}
        })

        UI.Listbox({
            id = "selector-lang"  
            align = "center"
            Colour = Colour (51,51,51)
            move = {right = "50%"} 
            TextColour = Colour (255,255,255) 
            RelativeSize = ["20%", "90%"]
            options = ["English", "Espanol"] 
            FontSize = wrapper.Size.X * 0.015
            FontFlags = GUI_FFLAG_NOAA | GUI_FFLAG_BOLD
            
            onOptionSelect = function(option) {
                UI.Editbox ("lang-provider").Text = option;
                UI.setData("Language", option);
                if  (option == "Espanol") {
                    UI.Button ("start").Text = "Juega ahora";
                    local lang = UI.Label ("language").Text = "Idioma:   ";
                }
                else {
                    UI.Button ("start").Text = "Play now";
                    UI.Label ("language").Text = "Language";
                }
            }
        }) 

        UI.Editbox({
            id = "lang-provider"
            Colour = Colour (200,200,200)
            RelativeSize = ["50%", "20%"]
            RemoveFlags = GUI_FLAG_BORDER | GUI_FLAG_SHADOW
            align = "center"
            Text = "English"
            FontSize = wrapper.Size.X * 0.015
            move = {  right = "5%"}
            flags = GUI_FLAG_DISABLED
        })
    ]
})  

function translate (es,en) {
    if (::UI.getData ( "Language") == "Espanol") {
        Console.Print (es);
    }
    else {
        Console.Print (en);
    }
}

function sendTodrawBoard() {
    UI.Sprite ("entrance_page").SetTexture("lobby.png"); // loading lobby
    UI.Draw ({
        id = "drawboard"
        RelativeSize = ["50%", "65%"]
        border = {offset = 1, color = Colour (0,0,0)}
    })
    
    UI.Canvas({
        id = "holabar",
        context = this,
        Color = Colour (255,255,255),   
        align = "center",
        flags = GUI_FLAG_MOUSECTRL
        RelativeSize = ["70%", "6%"]
        move = { up = "36%", left = "10%"}
        border = {offset = 1, color = Colour (0,0,0)}

        children = [
            UI.Label({
                id = "wordToGuess"  
                Text = "Juan" 
                FontSize = wrapper.Size.X * 0.015
                align = "center"
                move = {right = "20%"}
            })
            UI.Label({
                id = "Timer"  
                Text = "Time left: 100" 
                FontSize = wrapper.Size.X * 0.015
                align = "mid_left"
                move = {right = "2%"}
            })
        ]
      
    });
}

        local e = UI.Slider({
            id = "sliderDemoID"
            direction = "vertical"  //
            align = "center"
            buttonAlign = "right" //left | right
            buttonColour = Colour (255,0,2)
 
            buttonWidth = 0 // button width
            Size = VectorScreen (wrapper.Size.X*0.07,wrapper.Size.Y*0.1) 

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


   

 
local index = 0, h;
h = Timer.Create(::UI, function (a){
    index++
 
    local decrease = 100 - index;
    if (::UI.Label ("Timer") != null) ::UI.Label ("Timer").Text = "Time left: " + decrease;
    if (decrease == 0) ::UI.Label ("Timer").Text = "Time Is Over";

    if (::UI.Slider ("sliderDemoID") != null) ::UI.Slider ("sliderDemoID").setValue (index);  
 
}, 2000, 0, "a");