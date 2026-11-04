package system.backend.sprite.ui;

import flixel.math.FlxMath;
import flixel.addons.ui.FlxUI9SliceSprite;
import flash.geom.Rectangle;
import flixel.FlxState;
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
        // Assuming your project has a Paths class setup; otherwise use openfl/flixel asset tracking paths
        super(0, 0, Paths.image("ui/normal-popup"), rect, [12, 61, 147, 90], FlxUI9SliceSprite.TILE_NONE);
        screenCenter();
    }
    
    override function update(elapsed:Float) { // Added explicit type :Float
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
            
            // Track total weights sampled to normalize brightness perfectly
            float totalWeight = weights[0];
            color += flixel_texture2D(bitmap, uv) * weights[0];
            
            for (int i = 1; i < 5; i++) {
                float offset = float(i) * uIntensity;
                color += flixel_texture2D(bitmap, uv + vec2(offset, 0.0)) * weights[i];
                color += flixel_texture2D(bitmap, uv - vec2(offset, 0.0)) * weights[i];
                color += flixel_texture2D(bitmap, uv + vec2(0.0, offset)) * weights[i];
                color += flixel_texture2D(bitmap, uv - vec2(0.0, offset)) * weights[i];
                
                totalWeight += weights[i] * 4.0;
            }
            
            gl_FragColor = color / totalWeight; // Dynamic weight normalization keeps native brightness
        }
    ')
    public function new() {
        super();
        
        #if openfl
        @:privateAccess this.initGL(); // Prevents Null Access crashes by compiling GLSL uniforms early
        #end
        
        if (this.uIntensity != null) {
            this.uIntensity.value = [0.005]; 
        }
    }
}

class UiWindow extends FlxState {
    var windowCam:FlxCamera;
    public var windo(default, null):UiWindowSprite;
    var blur:ShaderFilter;
    var text:UiText;

    // Temporary variables to preserve configuration setup values from new() into create()
    var _initWidth:Float;
    var _initHeight:Float;
    var _initText:String;

    public function new(?Width:Float, ?Height:Float, ?Text:String) {
        super();
        _initWidth = Width != null ? Width : 400.0;
        _initHeight = Height != null ? Height : 400.0;
        _initText = Text != null ? Text : "";
    }

    override public function create():Void {
        super.create();

        // 1. Instantiate the shader inside the engine workflow loop
        var blurShader = new BlurShader();
        blur = new ShaderFilter(blurShader);

        // 2. Safely apply filters to all current game camera lists
        for(c in FlxG.cameras.list) {
            c.filters = [blur];
        }

        // 3. Construct your isolated pop-up camera canvas
        windowCam = new FlxCamera();
        windowCam.bgColor = 0x00000000; // Fully transparent color profile
        windowCam.zoom = 0.001;
        
        // Passing 'false' blocks generic game objects from rendering inside this layer automatically
        FlxG.cameras.add(windowCam, false);

        // 4. Setup your window sprite layout components
        windo = new UiWindowSprite(_initWidth, _initHeight);
        windo.camera = windowCam;
        add(windo);

        // 5. Build text layout fields aligned to the isolated view
        text = new UiText(windo.x + 5, windo.y + 5, 0, _initText, 15);
        text.camera = windowCam; // Singular variable declaration is cleaner for isolated mappings
        add(text);
        
        // 6. Smooth opening animation sequence
        FlxTween.tween(windowCam, {zoom: 1}, 1, {ease: FlxEase.elasticOut});
    }

    override function update(elapsed:Float) { // Added explicit type :Float
        super.update(elapsed);
        
        if (text != null && windo != null) {
            text.x = windo.x + 5;
            text.y = windo.y + 5;
        }
    }
}
