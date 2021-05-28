class Quickdraw extends Component {
   
    className =  "Draw"; 
    id = null;
    size = null; 
    Position = null;
    brushTimer = null;
    align = null
    RelativeSize = null;
    border = null;
    onBrushMove = null;
    draw = null;

    constructor(o) {
        this.id = o.id; 
        this.draw = [];

        if (o.rawin ( "align")) this.align = o.align;
        else this.align = "center";

        if (o.rawin ("onBrushMove")) this.onBrushMove = o.onBrushMove;
        if (o.rawin ( "border")) this.border = o.border;

        if (o.rawin ("RelativeSize")) this.RelativeSize = o.RelativeSize;
        else RelativeSize = ["20%", "30%"];

        base.constructor(this.id,o);
        this.metadata.list = "quickdraws";
        this.build();
    } 

 
    function build(){
        local wrapper = UI.Canvas({
            id = this.id,
            context = this,
            Color = Colour (255,255,255),   
            align = this.align,
            Size = VectorScreen (400, 400)
            flags = GUI_FLAG_MOUSECTRL
            RelativeSize = this.RelativeSize
            onClick = function () {
                context.attachToMouse ()
            }

            onRelease = function (x,y) {
                context.detachFromMouse ();
            }
        });
        
        if (this.border != null) {
            wrapper.addBorders(this.border) 
        }

        return wrapper;
    }

    attachToMouse = function () {
        local wrapper = UI.Canvas (this.id), b, prev = GUI.GetMousePos ();
        if (this.brushTimer  == null) {
            this.brushTimer = Timer.Create (::UI, function (wrapper, randomId, context) {
            local mouse = GUI.GetMousePos ();
            if (mouse != null) { 
                local random = "b" + GUI.GetMousePos().X;
                    if  (UI.Canvas (random) != null) random = "brush" + randomId (15,1).tostring ();
                    b = UI.Canvas({
                        id= random,
                        context = context,
                        Color = Colour (0,255,255),   
                        Size = VectorScreen (10, 10)
                        flags = GUI_FLAG_MOUSECTRL
                        onClick = function () {
                            context.attachToMouse ()
                        }

                        onRelease = function (x,y) {
                            context.detachFromMouse ();
                        }
                    });
                    //context.draw.push ({Name = random, Pos = mouse});
                    if (context.onBrushMove != null) context.onBrushMove (mouse.X,mouse.Y, random, context.id);
                    
                    b.Pos.X = mouse.X-wrapper.Pos.X; 
                    if (b.Pos.X <= 0) b.Pos.X = 0;
                    if (b.Pos.X >= wrapper.Size.X - b.Size.X) b.Pos.X = wrapper.Size.X - b.Size.X;

                    b.Pos.Y = mouse.Y-wrapper.Pos.Y; 
                    if (b.Pos.Y <= 0) b.Pos.Y = 0;
                    if (b.Pos.Y >= wrapper.Size.Y - b.Size.Y) b.Pos.Y = wrapper.Size.Y - b.Size.Y;

                    wrapper.AddChild(b)
                }
            }, 1, 0, wrapper, this.randomId, this);
        }
    }

    detachFromMouse = function () {
        if (Timer.Exists (this.brushTimer)) Timer.Destroy(this.brushTimer);
        this.brushTimer = null;
    }

   randomId = function (size, e) {
        local Id,  characters = (e == 1 ? "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@^%()=-_?+><[]{}&" : "1234567890" );
        for (local index = 0; index < size; index++ ) {
                local r =  ( ( rand() % ( characters.len () - 1 ) ) + 1 );  
                if (Id) Id += characters.slice(r-1, r);
                else Id = characters.slice(r-1, r);
        }
        return Id;
    }    
}

