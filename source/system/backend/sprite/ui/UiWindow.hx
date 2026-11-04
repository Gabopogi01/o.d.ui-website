package system.backend.sprite.ui;

import flixel.math.FlxMath;
import flixel.addons.ui.FlxUI9SliceSprite;
import flash.geom.Rectangle;
import flixel.FlxSubState;
import flixel.FlxCamera;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.FlxG;
import flixel.graphics.tile.FlxGraphicsShader;
import openfl.filters.ShaderFilter;
import system.backend.sprite.ui.UiText;

private class UiWindowSprite extends FlxUI9SliceSprite {
    var rect:Rectangle;
    public function new(?Width:Float = 400.0, ?Height:Float = 400.0) {
        rect = new Rectangle(0, 0, Width, Height);
        super(0, 0, Paths.image("ui/normal-popup"), rect, [12, 61, 147, 90], FlxUI9SliceSprite.TILE_NONE);
        screenCenter();
    }
    override function update(elapsed){
        super.update(elapsed);
        screenCenter();
    }
}

private class BlurShader extends FlxGraphicsShader {
    @:glFragmentSource('
        #pragma header

        uniform float uIntensity;

        void main() {
            vec2 uv = openfl_TextureCoordv;
            vec4 color = vec4(0.0);
            
            float weights[5];
            weights[0] = 0.227027; weights[1] = 0.1945946; weights[2] = 0.1216216; weights[3] = 0.054054; weights[4] = 0.016216;
            
            color += flixel_texture2D(bitmap, uv) * weights[0];
            
            for (int i = 1; i < 5; i++) {
                float offset = float(i) * uIntensity;
                color += flixel_texture2D(bitmap, uv + vec2(offset, 0.0)) * weights[i];
                color += flixel_texture2D(bitmap, uv - vec2(offset, 0.0)) * weights[i];
                color += flixel_texture2D(bitmap, uv + vec2(0.0, offset)) * weights[i];
                color += flixel_texture2D(bitmap, uv - vec2(0.0, offset)) * weights[i];
            }
            
            gl_FragColor = color / 2.0; 
        }
    ')
    public function new() {
        super();
        this.uIntensity.value = [0.005]; 
    }
}


class UiWindow extends FlxSubState {
    var windowCam:FlxCamera;
    public var windo(default, null):UiWindowSprite;
    var blur = new ShaderFilter(new BlurShader());
    var text:UiText;

    public function new(?Width:Float, ?Height:Float, ?Text:String) {
        super();

        for(c in FlxG.cameras.list) {
            c.filters = [blur];
        }

        windowCam = new FlxCamera();
        windowCam.bgColor = 0;
        windowCam.zoom = 0.001;
        windo = new UiWindowSprite(Width, Height);
        windo.camera = windowCam;
        add(windo);

        text = new UiText(windo.x + 5, windo.y + 5, 0, Text, 15);
        text.cameras = [windowCam];
        add(text);
        
        FlxG.cameras.add(windowCam);
        FlxTween.tween(windowCam, {zoom: 1}, 1, {ease: FlxEase.elasticOut});
    }

    override function update(elapsed){
        super.update(elapsed);
        text.x = windo.x + 5;
        text.y = windo.y + 5;
    }
}