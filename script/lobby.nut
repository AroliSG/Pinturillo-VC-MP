local wrapper = GUI.GetScreenSize();
function createLobby () {  
    local w = UI.Window({
        id = "main_entrance"  
        RelativeSize = ["40%", "25%"]
        Position =  VectorScreen (wrapper.X * 0.32, wrapper.Y * 0.58)

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
                        FontSize = wrapper.X * 0.015
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
                        FontSize = wrapper.X * 0.015
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
                FontSize = wrapper.X * 0.015
                FontFlags = GUI_FFLAG_BOLD
                onClick = function() {
                local edit = ::UI.Editbox("nickname-provider");
                if (strip(edit.Text) == "") {
                    ::translate ("Pinturillo2 - [#ffffff]Porfavor, introduce un nombre.", "Pinturillo2 - [#ffffff]Please, introduce a name.", "Pinturillo2 - [#ffffff] Por favor, insira um nome." );
                }
                else {
                    dataToServer (::UI.getData ( "Language"), 2);
                    UI.setData ("Entrance", false);
                    
                    UI.Window ("main_entrance").destroy (); // destroying entrance
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
                FontSize = wrapper.X * 0.015
                move = { up = "30%", right = "5%"}
            })

            UI.Listbox({
                id = "selector-lang"  
                align = "center"
                Colour = Colour (51,51,51)
                move = {right = "52%"} 
                TextColour = Colour (255,255,255) 
                RelativeSize = ["22.5%", "90%"]
                options = ["English", "Espanol", "Portuguese"] 
                FontSize = wrapper.X * 0.015
                FontFlags = GUI_FFLAG_NOAA | GUI_FFLAG_BOLD
                
                onOptionSelect = function(option) {
                    UI.setData("Language", option);
                    local playText = "Play now", LangText = "Language:";
                    if  (option == "Espanol") {
                        playText = "Juega ahora";
                        LangText = "Idioma:   ";
                    }
                    else if (option == "Portuguese") {
                        playText = "Jogue agora";
                        LangText = "Idioma:   ";
                    }

                    UI.Editbox ("lang-provider").Text = option;
                    UI.Button ("start").Text = playText;
                    UI.Label ("language").Text = LangText;
                }
            }) 

            UI.Editbox({
                id = "lang-provider"
                Colour = Colour (200,200,200)
                RelativeSize = ["50%", "20%"]
                RemoveFlags = GUI_FLAG_BORDER | GUI_FLAG_SHADOW
                align = "center"
                Text = "English"
                FontSize = wrapper.X * 0.015
                move = {  right = "5%"}
                flags = GUI_FLAG_DISABLED
            })]
        })   
}

