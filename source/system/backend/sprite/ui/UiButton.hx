package system.backend.sprite.ui;

import flixel.addons.ui.FlxUI9SliceSprite;
import flash.geom.Rectangle;
import flixel.FlxG;
import system.backend.Paths;
import system.backend.sprite.ui.UiText;

class UiButton extends FlxUI9SliceSprite {
    var rect:Rectangle;
    var temp:FlxUI9SliceSprite;
    public var label:UiText; 
    public var Func:Void->Void;
    
    static inline var STATE_NORMAL:Int = 1;
    static inline var STATE_HOVER:Int = 2;
    static inline var STATE_PRESSED:Int = 3;
    private var currentState:Int = STATE_NORMAL;

    public function new(X:Float, Y:Float, Width:Float, Height:Float, ?Text:String = "", ?UiBorder:Float = 1.6, ?Fun:Void->Void) {
        rect = new Rectangle(0, 0, Width, Height);
        super(X, Y, Paths.image("ui/button/button1"), rect, FlxUI9SliceSprite.TILE_NONE);

        var calculatedSize:Int = Std.int((Height / 2) - (Text.length / 4));
        if (calculatedSize < 8) calculatedSize = 8;

        label = new UiText(X, Y + 100, Width, Text, calculatedSize, UiBorder);
        this.cameras = [FlxG.camera];
        label.cameras = this.cameras;

        Func = Fun;
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        updateSprite();
        
        if (label != null) {
            label.x = this.x;
            label.y = this.y + 5;
            label.cameras = this.cameras;
            label.update(elapsed);
        }
        
        updateHitbox();
        
        if (temp != null) {
            temp.x = this.x;
            temp.y = this.y;
            temp.cameras = this.cameras;
            temp.update(elapsed);
        }
    }

    override public function draw():Void {
        if (temp != null) {
            temp.draw();
        } else {
            super.draw();
        }
        
        if (label != null) {
            label.draw();
        }
    }

    public function updateSprite():Void {
        var isOverlapped:Bool = FlxG.mouse.overlaps(this, this.camera);

        if (!isOverlapped) {
            if (currentState != STATE_NORMAL) {
                unloadtemp();
                currentState = STATE_NORMAL;
            }
            return;
        }

        if (FlxG.mouse.justPressed) {
            change(STATE_PRESSED);
        } 
        else if (FlxG.mouse.justReleased) {
            unloadtemp();
            change(STATE_HOVER); 
            Func();
        } 
        else if (!FlxG.mouse.pressed && currentState != STATE_HOVER) {
            change(STATE_HOVER);
        }
    }

    private function change(id:Int):Void {
        if (currentState == id && temp != null) return;
        
        unloadtemp(); 
        
        currentState = id;
        temp = new FlxUI9SliceSprite(this.x, this.y, Paths.image("ui/button/button" + id), rect, FlxUI9SliceSprite.TILE_NONE);
        temp.cameras = this.cameras;
    }

    private function unloadtemp():Void {
        if (temp != null) {
            temp.destroy();
            temp = null;
        }
    }

    override public function destroy():Void {
        if (temp != null) {
            temp.destroy();
        }
        if (label != null) {
            label.destroy();
        }
        super.destroy();
    }
}
