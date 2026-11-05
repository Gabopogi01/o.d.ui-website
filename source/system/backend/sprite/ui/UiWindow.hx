package system.backend.sprite.ui;

import flixel.FlxSprite;
import flixel.addons.ui.FlxUI9SliceSprite;
import flash.geom.Rectangle;
import flixel.FlxSubState;
import flixel.FlxCamera;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.FlxG;
import flixel.util.FlxColor;
import system.backend.Paths;
import system.backend.sprite.ui.UiText;

private class UiWindowSprite extends FlxUI9SliceSprite {
    var rect:Rectangle;
    public function new(?Width:Float = 400.0, ?Height:Float = 400.0) {
        rect = new Rectangle(0, 0, Width, Height);
        super(0, 0, Paths.image("ui/normal-popup"), rect, [12, 61, 147, 90], FlxUI9SliceSprite.TILE_NONE);
        screenCenter();
    }
    
    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        screenCenter();
    }
}

class UiWindow extends FlxSubState {
    var windowCam:FlxCamera;
    var windowelemCam:FlxCamera;
    public var windo(default, null):UiWindowSprite;
    var text:UiText;
    var bg:FlxSprite;

    public function new(?Width:Float, ?Height:Float, ?Text:String) {
        super();

        windowCam = new FlxCamera();
        windowCam.bgColor = FlxColor.TRANSPARENT;
        windowCam.zoom = 0.01;
        
        windowelemCam = new FlxCamera();
        windowelemCam.bgColor = FlxColor.TRANSPARENT;
        windowelemCam.zoom = 0.01;

        bg = new FlxSprite(0, 0).makeGraphic(FlxG.camera.width, FlxG.camera.height, FlxColor.BLACK);
        bg.alpha = 0;
        add(bg);

        windo = new UiWindowSprite(Width, Height);
        windo.cameras = [windowCam];
        add(windo);

        text = new UiText(windo.x + 5, windo.y + 5, 0, Text, 15);
        text.cameras = [windowCam];
        add(text);
        
        FlxG.cameras.add(windowCam, false); 
        FlxG.cameras.add(windowelemCam, false);

        FlxTween.tween(windowCam, {zoom: 1.0}, 1, {ease: FlxEase.elasticOut});
        FlxTween.tween(windowelemCam, {zoom: 1.0}, 1, {ease: FlxEase.elasticOut});
        FlxTween.tween(bg, {alpha: 0.3}, 0.4, {ease: FlxEase.cubeInOut});
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        if (windo != null && text != null) {
            text.x = windo.x + 5;
            text.y = windo.y + 5;
        }
    }

    override public function close():Void {
        FlxG.cameras.remove(windowCam);
        FlxG.cameras.remove(windowelemCam);
        super.close();
        FlxG.sound.play(Paths.sound("windowClose"), 1.0);
    }

    override public function add(basic:flixel.FlxBasic):flixel.FlxBasic {
        if (basic == null) return null;
        if (members.indexOf(basic) >= 0) return basic;

        var result = super.add(basic);
        if (result != null && basic != bg && basic != windo && basic != text) {
            basic.cameras = [windowelemCam];
        }
        return result;
    }

    override public function insert(position:Int, object:flixel.FlxBasic):flixel.FlxBasic {
        if (object == null) return null;
        if (members.indexOf(object) >= 0) return object;

        if (position > length) position = length; 

        var result = super.insert(position, object);
        if (result != null) {
            object.cameras = [windowelemCam];
        }
        return result;
    }
}
