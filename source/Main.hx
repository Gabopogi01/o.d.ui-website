package;

import flixel.FlxGame;
import openfl.display.Sprite;
import flixel.FlxG;
import openfl.Lib;
import openfl.events.Event;
import flixel.system.scaleModes.StageSizeScaleMode;
import system.backend.Funmeter;

class Main extends Sprite
{
	public function new()
	{
		super();
		// system.states.MainWebsite
		if (Funmeter.roll() >= 60){
			addChild(new FlxGame(0, 0, system.states.fun.Theresaguythere, 60, 60, true));
		} else {
			addChild(new FlxGame(0, 0, system.states.MainWebsite, 60, 60, true));
		}
		FlxG.scaleMode = new StageSizeScaleMode();
		FlxG.mouse.useSystemCursor = true;
		FlxG.autoPause = false;

		Lib.current.stage.addEventListener(Event.RESIZE, onWindowResize);
	}

	private function onWindowResize(e:Event):Void{
		if (FlxG.stage != null && FlxG.camera != null)
		{
			var stageWidth:Int = Lib.current.stage.stageWidth;
			var stageHeight:Int = Lib.current.stage.stageHeight;

			FlxG.camera.width = stageWidth;
			FlxG.camera.height = stageHeight;
		}
	}
}
