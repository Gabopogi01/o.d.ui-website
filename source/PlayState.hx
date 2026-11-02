package;

import flixel.FlxState;
import openfl.Lib;
import flixel.addons.display.FlxBackdrop;
import flixel.system.scaleModes.StageSizeScaleMode;
import flixel.math.FlxMath;
import flixel.tweens.FlxTween;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.util.FlxAxes;
import openfl.geom.Rectangle;
import flixel.FlxCamera;
import system.Paths;
import flixel.tweens.FlxEase;
import haxe.Json;
import lime.utils.Assets;
import flixel.FlxG;
import flixel.text.FlxText;

class PlayState extends FlxState
{
	private var backdrop:FlxBackdrop;
	private var context:FlxUI9SliceSprite;
	public var canPress = false;
	private var scrooll = 0;
	public static var textCam:FlxCamera;

	override public function create()
	{
		super.create();
		FlxG.scaleMode = new StageSizeScaleMode();
		FlxG.mouse.useSystemCursor = true;
		
		backdrop = new FlxBackdrop(Paths.image("charter"));
		backdrop.velocity.set(100, 100);
		backdrop.alpha = 0;
        backdrop.scale.x = 0.9;
        backdrop.scale.y = 0.9;
		backdrop.camera = FlxG.camera;
		add(backdrop);
		FlxTween.tween(backdrop.scale, {x: 1, y: 1}, 2, {ease: FlxEase.expoOut, onComplete: function(_:FlxTween) {canPress = true;}});
		FlxTween.tween(backdrop, {alpha: 1, angle: 0}, 2, {ease: FlxEase.expoOut});
		trace(new Rectangle(0, 0, 100, 100));

		textCam = new FlxCamera(0, 0, 600, 1000);
		textCam.bgColor = 0x00000000;
		FlxG.cameras.add(textCam);

		context = new FlxUI9SliceSprite(0, 900, Paths.image("context-bg"), new Rectangle(0, 0, 600, 1000), FlxUI9SliceSprite.TILE_NONE);
		context.scrollFactor.set(0.2, 1);
		context.updateHitbox();
		context.screenCenter(FlxAxes.X);
		add(context);

		FlxTween.tween(context, {y: 100}, 1, {ease: FlxEase.cubeOut});

		var parsed:Array<{type:String, text:String}> = Json.parse(Assets.getText(Paths.file("data/info/actually.json")));
        var next = 0;

        for (i in parsed)   {
            if (i.text != null) {
                trace(i.text);
                var textobj = new FlxText(0, 0 + (next * 4));
                textobj.camera = textCam;
                FlxG.state.insert(100,textobj);
                next++;
                trace(textobj);
                //pusha.push(textobj);
            }
        }
		
		trace(scrooll);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		FlxG.camera.width = Lib.current.stage.stageWidth;
		FlxG.camera.height = Lib.current.stage.stageHeight;	
		context.updateHitbox();
		context.screenCenter(FlxAxes.X);

		var mouseX = (FlxG.mouse.viewX - (FlxG.width/2)) / 30;
        var mouseY = (FlxG.mouse.viewY - (FlxG.height/2)) / 30;

		if (canPress) {
    		var maxScroll:Int = Std.int(context.width * (2 - (context.width / 1000)));

			if (FlxG.mouse.wheel < 0) {
					var nextScroll:Int = scrooll + 45;
					if (nextScroll > maxScroll) nextScroll = maxScroll;
					var targetY:Int = -nextScroll + 100;

					if (Math.abs(context.y - targetY) > 1) {
						scrooll = nextScroll;
						FlxTween.cancelTweensOf(context);
						FlxTween.cancelTweensOf(backdrop);
						FlxTween.tween(context, {y: targetY}, 0.3, {ease: FlxEase.cubeOut});
						FlxTween.tween(backdrop, {y: -scrooll}, 0.3, {ease: FlxEase.cubeOut});
					}
				} 
			else if (FlxG.mouse.wheel > 0) {
					var nextScroll:Int = scrooll - 45;
					if (nextScroll < 0) nextScroll = 0;
					var targetY:Int = -nextScroll + 100;

				if (Math.abs(context.y - targetY) > 1) {
					scrooll = nextScroll;
					FlxTween.cancelTweensOf(context);
					FlxTween.cancelTweensOf(backdrop);
					FlxTween.tween(context, {y: targetY}, 0.3, {ease: FlxEase.cubeOut});
					FlxTween.tween(backdrop, {y: -scrooll}, 0.3, {ease: FlxEase.cubeOut});
				}
			}
		}

		//context.y = FlxMath.lerp(context.y, 100, 0.10);

		FlxG.camera.scroll.x = FlxMath.lerp(FlxG.camera.scroll.x, mouseX, 1 - Math.exp(-elapsed * 5));
		FlxG.camera.scroll.y = FlxMath.lerp(FlxG.camera.scroll.y, mouseY, 1 - Math.exp(-elapsed * 5));

		textCam.x = FlxMath.lerp(textCam.x, context.x - (mouseX / 4), 1 - Math.exp(-elapsed * 5));
		textCam.y = FlxMath.lerp(textCam.y, context.y - mouseY, 1 - Math.exp(-elapsed * 5));
	}
}
