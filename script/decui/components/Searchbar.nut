class SearchBar extends Component {
    className = "Searchbar";
    id = null;
    barId = null;
    listId = null;
    closeId = null;

    Position = null;
    colour = null;
    move = null;
    align = null;
    Size = null;
    placeholder = null;
    listbox = null;
    style = null;
    items = null;
    typingTimer = null;
    heigth = null;
   
    //tags
    tags = null;
    margin  = null; 
    tag_component = null
    input = null;
    createBox = null;
    
    // events
    onHoverOver = null;
    onHoverOut  = null;
    onTyping = null;
    onTags = null;
    onResults = null;
    onSelect = null;
    onClose = null;
    test = null;

    constructor(o) {
        // applying variables to their already set keys
        this.id = o.id; 
        this.tag_component = {tags_created = [], tags_alive = []};
        this.margin = VectorScreen (1,1);
        this.placeholder = {Text = "Search" Opacity = 255 Colour = Colour (0,0,0) FontSize = 0 FontStyle=0};
        this.listbox = {Opacity = 255 FontSize = 0 FontStyle=0};

        if (o.rawin("Size")) this.Size = o.Size;
        else this.Size = VectorScreen(500,40);
        
        if (o.rawin("Colour")) this.colour = o.Colour;
        else this.colour = ::Colour(255,255,255);

        if (o.rawin ("items")) this.items = o.items;
        else this.items = [];     

        if (o.rawin ("tags")) this.tags = o.tags; 

        local fonts = {bold = 1 italic = 2 uline = 4 strike = 8 noaa = 16 outline = 32};
        if (o.rawin ("style")) {
            local debug;
            if (o.style.rawin ("placeholder"))  {
                debug = o.style.placeholder;
               
                if (debug.rawin ( "Text" )) this.placeholder.Text = debug.Text;
                if (debug.rawin ( "Opacity" )) this.placeholder.Opacity = debug.Opacity;
                if (debug.rawin ( "FontSize" )) this.placeholder.FontSize = debug.FontSize;
                if (debug.rawin ( "applyTo" ) && debug.applyTo == "listbox") this.listbox = this.placeholder
                if (debug.rawin ( "FontStyle" )) {
                    if (fonts.rawin (debug.FontStyle)) this.placeholder.FontStyle = fonts [debug.FontStyle];
                }                      
            }

            if (o.style.rawin ("listbox"))  {
                debug = o.style.listbox;

                if (debug.rawin ( "Opacity" )) this.listbox.Opacity = debug.Opacity;
                if (debug.rawin ( "FontSize" )) this.listbox.FontSize = debug.FontSize;   
                if (debug.rawin ( "FontStyle" )) {
                    if (fonts.rawin (debug.FontStyle)) this.listbox.FontStyle = fonts [debug.FontStyle];
                }              
            }            
        }

        if (o.rawin("heigth")) this.heigth = o.heigth;
        else this.heigth = 200;

        if (o.rawin("align")) this.align = o.align;
        else this.align = "center";

        if (o.rawin("move")) this.move = o.move; 
        else move = {};

        if (o.rawin("Position") && o.Position != null) this.Position = o.Position;
        else this.Position = VectorScreen(0,0);

        // search events
        if (o.rawin ("onResults") ) this.onResults = o.onResults;
        if (o.rawin ("onTags") ) this.onTags = o.onTags;
        if (o.rawin ("onTyping") ) this.onTyping = o.onTyping;
        if (o.rawin ("onSelect") ) this.onSelect = o.onSelect;
        if (o.rawin ("onClose") ) this.onClose = o.onClose;

        // necessary stuff
        this.barId = this.id + "::Searchbar::bar";
        this.listId = this.id + "::Searchbar::list";
        this.closeId = this.id + "::Searchbar::ClosableBtn";

        base.constructor(this.id,o);
        this.metadata.list = "searchbar";
        this.build();
    }     

    
    function build(){
        local c = UI.Canvas({
            id=this.id,
            context = this,
            Color = this.colour, 
            Position = this.Position,  
            align = this.align,
            Size = this.Size
            move = this.move,
            flags = GUI_FLAG_MOUSECTRL,
        });

        this.createBox = function (Id, context, option = null) {
            context.test = context.barId + Id;
            local tag_quantity, tag_text, tag_colour, tag_flags = array(2), input_x, closable, except;

            if (context.tags) {
                if (context.tags.rawin ( "quantity" )) tag_quantity = context.tags.quantity;
                else tag_quantity = 4;

                if (context.tags.rawin ("Colour")) tag_colour = context.tags.Colour;
                else tag_colour = ::Colour (0,0,0);

                if (context.tags.rawin ("closable")) {
                    closable = true;

                    if (context.tags.closable.rawin ("except")) except = context.tags.closable.except;
                    else except = [];
                }

                tag_text = option;
                tag_flags[0] = GUI_FLAG_DISABLED;
                tag_flags [1] = GUI_FLAG_NONE;

                if (typeof option == "table") {
                    tag_flags [1] = GUI_FLAG_BACKGROUND | GUI_FLAG_DISABLED;
                    input_x = option.wrapper.Size.X;
                    tag_text = context.placeholder.Text
                }
            }
            else {
                tag_flags[0] = GUI_FLAG_NONE;
                tag_flags [1] = GUI_FLAG_BACKGROUND;
            }

            // saving original quantity, saving extra work!~
            local original_quantity = tag_quantity;
            local debug = 1

            // dividing the total mass of the wrapper among the qunatity of tags
            if (tag_quantity) tag_quantity = c.Size.X/tag_quantity;
            else tag_quantity = c.Size.X;

            //creating tags and searchbar
            local e = ::UI.Editbox({
                id = context.barId + Id
                context = context
                Size = VectorScreen(input_x ? input_x : tag_quantity, context.Size.Y)
                Text = tag_text ? tag_text : context.placeholder.Text
                FontSize = context.placeholder.FontSize == 0 ? c.Size.X * 0.04 : context.placeholder.FontSize
                Colour = tag_colour
                TextColour = context.placeholder.Colour
                FontFlags = context.placeholder.FontStyle
              //  flags = option ? tag_flags [0] : 0 
                RemoveFlags = tag_flags [1]

                onInputReturn = function () {
                    if (this.Text != "" && context.tags) {
                        context.createBox ("tags::" + this.Text.tolower () + Script.GetTicks(), context, this.Text);
                        if (context.onTags != null) context.onTags (this.Text);
                    }
                    this.Text = "";
                }

                onFocus = function () {
                    if (this.Text == context.placeholder.Text) this.Text = "";
                    this.Alpha = 255;

                    context.onTypingStart (this, typeof option == "table" ? true : null);
                }

                onBlur = function () {
                    if (this.Text == "") this.Text = context.placeholder.Text;
                    if (this.Text == context.placeholder.Text) this.Alpha = context.placeholder.Opacity;

                    context.onTypingEnded (this);
                }
            });

            local master = context.tag_component.tags_created;
            local alive = context.tag_component.tags_alive;
            if (closable && except != null && except.find(e.Text) == null && option) {
                local sprite = ::UI.Sprite({ 
                    id =  context.closeId + "::closable::" + e.Text + Script.GetTicks (),
                    file = "decui/closew.png",
                    align = "top_right" ,
                    context = context,
                    Size =VectorScreen(e.Size.Y/2,e.Size.Y/2),
                    move = {down = 10, left = 10},
                    onClick = function(){
                        if (context.onClose != null) context.onClose (e.Text);
                        e.destroy ();
                        
                        // element from master
                        if (master.find (e) != null) master.remove(master.find (e));
                           
                        alive.remove (alive.find (e.Text));
                       // context.sortTags ();
                    }
                })
                

                e.add(sprite, false)
            }
            
            if (master.len () >= 1) {
                local prev = master [ context.tag_component.tags_created.len()-1 ]; 
                if (original_quantity <= master.len ()) {
                    master.clear(); 
 
                    c.Size.Y += e.Size.Y + context.margin.Y;
                    e.Pos.Y = prev.Size.Y + prev.Pos.Y + context.margin.Y;
                    
                    // reloading border
                    c.removeBorders ();
                    c.addBorders ({offset = 1});

                    // re-locating listbox
                    UI.Listbox(context.listId).Pos.Y = c.Position.Y+c.Size.Y + 5;
                }
                else {
                    // locating next tag depending on last tag pos.
                    e.Pos.Y = prev.Pos.Y; // processing Y pos.

                    e.Pos.X = prev.Pos.X; 
                    e.Pos.X += prev.Size.X + context.margin.X;
                    e.Size.X -= context.margin.X;
                }
            }    
            
            
            e.Alpha = context.placeholder.Opacity;
            if (typeof option != "table") {
                c.add (e, false);
                alive.push (e.Text);
                master.push (e);
            
            }
        } 

        // when tags is null, normal searchbar will appear
        local itemLocal = ["..."]
        if (!this.tags) {
            this.createBox ("normal::searchbar", this);
        }
        else {
            if (this.tags.rawin ("input")) {
                this.input = this.tags.input;
                itemLocal = [];
            }
            else itemLocal = this.items;
        }

        local list = UI.Listbox({
            id = this.listId  
            context = this
            Position = VectorScreen (c.Position.X, c.Position.Y+c.Size.Y + 5)
            Size = VectorScreen(this.Size.X,this.heigth)
            FontSize = this.listbox.FontSize == 0 ? c.Size.X * 0.04 : this.listbox.FontSize
            FontFlags = this.listbox.FontStyle
            Colour = this.colour 
            options = itemLocal
            onOptionSelect = function(option) {
               if (context.tags) {
                    this.RemoveItem(option);
                    context.createBox ("tags::" + option.tolower () + Script.GetTicks(), context, option);
                    if (context.onTags != null) context.onTags (option);
               } 
               else {
                   if (context.onSelect != null) context.onSelect (option);
               }
            }
        })
        list.Alpha = this.listbox.Opacity;

        if (this.input == "in") {
            list.hide ();
            this.createBox ("tags::inputbar", this);
        }
        else if (this.input == "out") {
            list.Size = VectorScreen (c.Size.X,c.Size.Y);
            
            this.createBox ("tags::inputbar", this, {wrapper = list});
            list.add(UI.Editbox(this.barId + "tags::inputbar"),false)
        }
        else if (this.input == "none") list.hide ();

        c.addBorders ({offset = 1});
        c.shiftPos ();
        c.realign ();
        c.resetMoves (); 
        return c; 
    }

    // outside functions

    addTag = function (items) {
        if (this.tags) {
            if (typeof items == "string") {
                this.createBox ( "::addtags::" + items.tolower (), this, items);
                if (this.onTags != null) this.onTags (items);
            }
            else foreach (index,e in items) {
                this.createBox ( "::addtags::" + e.tolower (), this, e);
                if (this.onTags != null) this.onTags (e);
            }
        }
    }

    addItem = function () {

    }

    // internal functions
    sortTags = function () {
    }

    match = function (word) {
        local options = []; 
        for (local a = 0; a < this.items.len (); a++) {
            local out = typeof this.items [a] == "table" ? this.items [a] : word;
            foreach (index,string in out) {
                if (typeof items [a] == "table") {
                    if (index.len() >= word.len () && index.slice(0,word.len ()).tolower () == word.tolower ()) {
                        options.push("-- " + index + " --");
                        foreach(e in string) options.push (e);
                    }
                } 
                else {
                    if (items [a].len() >= word.len () && items[a].slice(0,index+1).tolower () == word.tolower ()) {
                        options.push(items [a]);
                    }
                }
            }
        }
        return options.len() == 0 ? [ "0 results" ] : options;
    }

    onTypingStart = function (e,tag) {
        local LastText; 
        if (this.typingTimer == null ) {
            this.typingTimer = Timer.Create (::UI, function (e,context) {    
                if (LastText != e.Text && e.Text != "") {
                    if (tag == null) {
                        ::UI.Listbox (context.listId).Clean ();
                        foreach (e in context.match (e.Text)) ::UI.Listbox (context.listId).AddItem (e);
                        if (context.onResults != null) context.onResults (context.match (e.Text));
                    }
                    if (context.onTyping != null) context.onTyping (e.Text);
                }
                LastText = e.Text;
            }, 1, 0, e, this);
        } 
    }

    onTypingEnded = function (e) {
        if (Timer.Exists (this.typingTimer)) Timer.Destroy(this.typingTimer);
        this.typingTimer = null;
        
        if (this.onTyping != null) this.onTyping (null);
    }

    function dragTag () {
        Timer.Create (::UI, function (context) {    
            if (GUI.GetMousePos() != null) {
               
               // ::Console.Print(GUI.GetMousePos().X + " " +  UI.Editbox (context.test).Size.X)
            }
        }, 1, 0, this);
    }    
}  

