package;

import flixel.FlxGame;
import openfl.display.Sprite;
import flixel.FlxG;
import openfl.Lib;
import openfl.events.Event;
import flixel.system.scaleModes.StageSizeScaleMode;
import system.backend.Funmeter;
import openfl.events.UncaughtErrorEvent;
import flixel.tweens.FlxTween;

class Main extends Sprite
{
	public function new()
	{
		super();
		loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);

		if (Funmeter.roll() >= 80){
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

   	private function onCrash(e:UncaughtErrorEvent):Void
    {
        e.preventDefault();
        e.stopPropagation();

        var msg = "Error: " + Std.string(e.error) + "\n\nCall Stack:\n";
        for (item in haxe.CallStack.exceptionStack()) {
            switch (item) {
                case FilePos(_, file, line, _): msg += '  at $file:$line\n';
                case Method(c, m): msg += '  at $c.$m()\n';
                default: msg += '  at ' + Std.string(item) + '\n';
            }
        }
			lime.app.Application.current.window.alert(msg, Std.string(e.error));

			#if html5
			js.Browser.console.error(msg + "Copy all of them and Post it on Our Github issue!");
			#end
    }
}
