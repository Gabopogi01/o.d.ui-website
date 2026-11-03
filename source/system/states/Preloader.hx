package system.states;

import flixel.system.FlxBasePreloader;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.display.Shape;
import flixel.math.FlxMath;

class Preloader extends FlxBasePreloader
{
    private var progressBar:Shape;
    private var track:Shape;
    
    private var barWidth:Float = 20;
    private var barHeight:Float = 300;
    private var larp:Float = 0;

    public function new(MinDisplayTime:Float = 3, ?AllowedURLs:Array<String>)
    {
        super(MinDisplayTime, AllowedURLs);
    }

    override function create():Void
    {
        super.create();

        track = new Shape();
        track.graphics.beginFill(0x333333);
        track.graphics.drawRect(0, 0, barWidth, barHeight);
        track.graphics.endFill();
        track.x = 10; track.y = 10;
        addChild(track);

        progressBar = new Shape();
        progressBar.x = 10; progressBar.y = 10;
        addChild(progressBar);
    }

    override function update(Percent:Float):Void
    {
        super.update(Percent);

        larp = FlxMath.lerp(larp, Percent, 0.5);
    
        progressBar.graphics.clear();
        progressBar.graphics.beginFill(0x00FF00);
        progressBar.graphics.drawRect(0, 0, barWidth, barHeight * larp);
        progressBar.graphics.endFill();

        barHeight = openfl.Lib.current.stage.stageHeight / 1.05;
        
        track.graphics.beginFill(0x333333);
        track.graphics.drawRect(0, 0, barWidth, barHeight);
        track.graphics.endFill();

        track.alpha = progressBar.alpha = Percent;
    }
}
