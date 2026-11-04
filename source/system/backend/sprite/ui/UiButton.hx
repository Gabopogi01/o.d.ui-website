package system.backend.sprite.ui;

import flixel.addons.ui.FlxUI9SliceSprite;
import flash.geom.Rectangle;
import flixel.FlxG;
import flixel.util.FlxTimer;
import system.backend.Paths;
import system.backend.sprite.ui.UiText;

class UiButton extends FlxUI9SliceSprite {
    var rect:Rectangle;
    var temp:FlxUI9SliceSprite;
    public static var label:UiText;
    static inline var STATE_HOVER:Int = 2;
    static inline var STATE_PRESSED:Int = 3;
    private var currentState:Int = 1;

    public function new(X:Float, Y:Float, Width:Float, Height:Float, ?Text:String = "") {
        rect = new Rectangle(0, 0, Width, Height);
        super(X, Y, Paths.image("ui/button/button1"), rect, FlxUI9SliceSprite.TILE_NONE);

        label = new UiText(X, Y, Width, Text, Std.int((Height / 2) - (Text.length) / 2));

        new FlxTimer().start(0.01, (timer) -> {
            FlxG.state.add(label);
            label.updateHitbox();
        });
        this.cameras = [FlxG.camera];
        label.cameras = [FlxG.camera];
    }

    override function update(elapsed){
        super.update(elapsed);
        updateSprite();
        label.x = this.x;
        label.y = this.y + 5;
        updateHitbox();
        if (temp != null){
            temp.x = this.x;
            temp.y = this.y;
        }
    }

    public function updateSprite():Void {
        var isOverlapped:Bool = FlxG.mouse.overlaps(this);

        if (!isOverlapped) {
            if (currentState != 1) {
                unloadtemp();
                currentState = 1;
            }
            return;
        }

        if (FlxG.mouse.justPressed) {
            change(STATE_PRESSED);
        } 
        else if (FlxG.mouse.justReleased) {
            unloadtemp();
            change(STATE_HOVER); 
        } 
        else if (!FlxG.mouse.pressed && currentState != STATE_HOVER) {
            change(STATE_HOVER);
        }
    }

    private function change(id:Int):Void {
        if (currentState == id && temp != null) return;
        
        unloadtemp(); 
        FlxG.state.remove(label);
        
        currentState = id;
        temp = new FlxUI9SliceSprite(this.x, this.y, Paths.image("ui/button/button" + id), rect, FlxUI9SliceSprite.TILE_NONE);
        temp.cameras = this.cameras;
        FlxG.state.add(temp);
        this.alpha = 0.01;

        FlxG.state.add(label);
    }

    private function unloadtemp():Void {
        this.alpha = 1;
        FlxG.state.remove(label);
        if (temp != null) {
            FlxG.state.remove(temp);
            temp.destroy();
            temp = null;
        }
        FlxG.state.add(label);
    }
}
