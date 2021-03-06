class Paginations extends Component {
    className = "Pagination";
    id = null;
    spriteLeftId = null;
    spriteRightId = null;
    labelId = null;
    wrapperCanvasId = null;

    Position = null;
    colour = null;
    move = null;
    border =null;
    align = null;
    Size = null;

    pages = null;
    onPageClicked = null;
    PageClicked = null;

constructor(o) {
        this.id = o.id; 

        if (o.rawin ( "onPageClicked" )) this.onPageClicked = o.onPageClicked;

        if (o.rawin ( "pages" )) this.pages = o.pages
        else this.pages = 2;

        if (o.rawin ( "Size" )) this.Size = o.Size;

        if (o.rawin("Colour") ) this.colour =o.Colour;
        else this.colour = ::Colour(255,255,255);

        if (o.rawin("align")){
            this.align = o.align;
        }
        else this.align = "center";
        
        if (o.rawin("border")){
            this.border = o.border;
        }

        if (o.rawin("move")) this.move = o.move; 
        else move = {};

        if (o.rawin("Position") && o.Position != null){
            this.Position = o.Position;
        }
        else this.Position = VectorScreen(0,0);

        this.spriteLeftId = this.id + "::Pagination::spriteLeft";
        this.spriteRightId = this.id + "::Pagination::spriteRight";
        this.labelId = this.id + "::Pagination::label";
        this.wrapperCanvasId = this.id + "::Pagination::wrapperCanvas";
        
        base.constructor(this.id,o);
        this.metadata.list = "paginations";
        this.build();
    }     

    
    function build(){
        local left = UI.Sprite({
            id = this.spriteLeftId 
            context = this
            file = "decui/left.png" 
            align = "mid_left"
            onClick = function () {
                context.prevPage ();
            }            
        })

        local right = UI.Sprite({
            id = this.spriteRightId  
            context = this
            file = "decui/right.png" 
            align = "mid_right"
            onClick = function () {
                context.nextPage ();
            }
        })

        local wrapper = UI.Canvas({
            id=this.wrapperCanvasId,
            context = this,
            Color = Colour (255,255,255), 
            Position = this.Position,  
            align = this.align,
            Size =  VectorScreen(this.Size.X/2,this.Size.Y)
        });

        local c = UI.Canvas({
            id=this.id,
            context = this,
            Color = Colour (255,255,255), 
            Position = this.Position,  
            align = this.align,
            Size = this.Size == null ? VectorScreen(400,50) : this.Size
            move = this.move,
        });
        c.shiftPos ();
         
        local debug;
        for (local index = 0; index < this.pages; index++) {
            local e = UI.Label({ 
                id = this.labelId+index 
                context = this
                Text = index + 1
                align = "mid_left"
                FontSize = c.Size.Y/2
                onClick = function () {
                    if (context.PageClicked) {
                        this.TextColour = ::Colour (0, 0, 255)
                        
                        context.PageClicked.TextColour = ::Colour(0,0,0);
                        context.PageClicked = this;
                    }  
                    else {
                        context.PageClicked = this;
                    }
                    if (context.onPageClicked != null) context.onPageClicked (this.Text.tointeger()-1);
                } 
            })  
            wrapper.add(e,false);

            if (index == 0) {
                if (this.onPageClicked != null)  this.onPageClicked (0);
            }
            else {
                debug = index-1; 
                UI.Label(this.labelId+index).Pos.X = UI.Label(this.labelId+debug).Pos.X + c.Size.X*0.04;
                Console.Print (UI.Label(this.labelId+debug).Pos.X + " " + UI.Label(this.labelId+index).Pos.X)
                if (UI.Label(this.labelId+index).Pos.X >= wrapper.Size.X) {
                    UI.Label(this.labelId+index).hide ();
                } 
            } 
        }
 
        // centering canvas of labels.
        debug = this.pages-1;
        if (UI.Label(this.labelId+debug).Pos.X <= wrapper.Size.X) {
            wrapper.Size.X = UI.Label(this.labelId+debug).Pos.X + 20;
        } 
 
        // resizing button size depending on width of canva
        left.Size = VectorScreen(c.Size.X*0.1/2, c.Size.Y*0.6);
        right.Size = VectorScreen(c.Size.X*0.1/2, c.Size.Y*0.6); 


        c.add(left, false);
        c.add(right, false);
        c.add(wrapper, false);

        c.realign();
        c.resetMoves();
        c.shiftPos ();
        return c; 
    }

    nextPage = function () {
        local page;
        if (!this.PageClicked) {
            if (pages == 1) page = 0;
            else page = 1;
        } 
        else {
            this.PageClicked.TextColour = ::Colour(0,0,0);
            if (this.PageClicked.Text.tointeger () == this.pages) page = 0;   
            else {
                page = (this.PageClicked.Text.tointeger ());
            }
        }
        local e = (this.PageClicked = UI.Label(this.labelId+page)); 
        e.TextColour = ::Colour(0,0,255);

        if (this.onPageClicked != null) this.onPageClicked (page);
    }

    prevPage = function () {
        local page;
        if (!this.PageClicked) {
            if (pages == 1) page = 0;
            else page = pages-1;
        } 
        else {
            this.PageClicked.TextColour = ::Colour(0,0,0);
            if (this.PageClicked.Text.tointeger () == 1) page = pages-1;   
            else {
                page = (this.PageClicked.Text.tointeger ()-1)-1;
            }
        }
        local e = (this.PageClicked = UI.Label(this.labelId+page)); 
        e.TextColour = ::Colour(0,0,255);

        if (this.onPageClicked != null) this.onPageClicked (page);
    }
}

