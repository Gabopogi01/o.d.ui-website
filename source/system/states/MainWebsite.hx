package system.states;

import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.math.FlxMath;
import flixel.tweens.FlxTween;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.util.FlxAxes;
import openfl.geom.Rectangle;
import flixel.FlxCamera;
import system.backend.Paths;
import flixel.tweens.FlxEase;
import haxe.Json;
import lime.utils.Assets;
import flixel.FlxG;
import flixel.text.FlxText;
import system.ui.Info;

class MainWebsite extends FlxState
{
	private var backdrop:FlxBackdrop;
	private var context:FlxUI9SliceSprite;
	public var canPress = false;
	private var scrooll = 0;
	public static var textCam:FlxCamera;
	public static var backdropCam:FlxCamera;
	public static var pusha:Array<FlxText>;
	private static var offset = {y: 0};

	override public function create()
	{
		super.create();

		backdropCam = new FlxCamera(0, 0, 9999, 9999);
		FlxG.cameras.add(backdropCam);
		
		backdrop = new FlxBackdrop(Paths.image("charter"));
		backdrop.velocity.set(100, 100);
		backdrop.alpha = 0;
		backdrop.scale.x = 0.9;
		backdrop.scale.y = 0.9;
		backdrop.y = -40;
		backdrop.camera = backdropCam;
		add(backdrop);
		FlxTween.tween(backdrop.scale, {x: 1, y: 1}, 2, {ease: FlxEase.expoOut, onComplete: function(_:FlxTween) {canPress = true;}});
		FlxTween.tween(backdrop, {alpha: 1, angle: 0}, 2, {ease: FlxEase.expoOut});

		var parsed = Json.parse(Assets.getText(Paths.json("news.json")));

		Info.create(parsed);

		trace(Info.textCam.height);

		context = new FlxUI9SliceSprite(0, 900, Paths.image("context-bg"), new Rectangle(0, 0, 600, Info.textCam.height), FlxUI9SliceSprite.TILE_NONE);
		context.scrollFactor.set(0.2, 1);
		context.updateHitbox();
		context.screenCenter(FlxAxes.X);
		context.cameras = [backdropCam];
		add(context);

		FlxTween.tween(context, {y: 100}, 1, {ease: FlxEase.cubeOut, onUpdate: (_:FlxTween) -> {
			Info.textCam.x = context.x;
			Info.textCam.y = context.y;
		}});

		trace(scrooll);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		context.updateHitbox();
		context.screenCenter(FlxAxes.X);

		var mouseX = (FlxG.mouse.viewX - (FlxG.width / 2)) / 30;
		var mouseY = (FlxG.mouse.viewY - (FlxG.height / 2)) / 30;

		if (canPress && FlxG.mouse.wheel != 0) {
			var maxScroll:Int = Std.int(context.width * (2 - (context.width / 4000)));
			
			var scrollDelta = (FlxG.mouse.wheel > 0) ? -45 : 45;
			var nextScroll:Int = scrooll + scrollDelta;
			
			if (nextScroll > maxScroll) nextScroll = maxScroll;
			if (nextScroll < 0) nextScroll = 0;

			var targetY:Int = Std.int(-nextScroll + 100);

			if (Math.abs(context.y - targetY) > 1) {
				scrooll = nextScroll;
				
				FlxTween.cancelTweensOf(offset);
				
				FlxTween.tween(offset, {y: -targetY + 100}, 0.3, {ease: FlxEase.cubeOut});
			}
		}

		//context.y = FlxMath.lerp(context.y, 100, 0.10);

		backdropCam.scroll.x = FlxMath.lerp(backdropCam.scroll.x, mouseX, 1 - Math.exp(-elapsed * 5));
		backdropCam.scroll.y = FlxMath.lerp(backdropCam.scroll.y, mouseY + offset.y, 1 - Math.exp(-elapsed * 5));

		Info.textCam.x = FlxMath.lerp(Info.textCam.x, context.x - (mouseX / 4), 1 - Math.exp(-elapsed * 5));
		Info.textCam.y = FlxMath.lerp(Info.textCam.y, (context.y - mouseY) - offset.y, 1 - Math.exp(-elapsed * 5));
	}
}
