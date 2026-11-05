package system.states.window;

import system.backend.sprite.ui.UiWindow;
import system.backend.sprite.ui.UiButton;
import system.backend.sprite.ui.UiText;
import flixel.util.FlxColor;
import flixel.text.FlxText.FlxTextFormat;
import flixel.text.FlxText.FlxTextFormatMarkerPair;

class WipWarning extends UiWindow {
    var btn:UiButton;
    var info:UiText;
    
    public function new() {
        var redFormat = new FlxTextFormat(FlxColor.RED, true, false);
        var blueFormat = new FlxTextFormat(FlxColor.CYAN, false, true);
        var redMarker = new FlxTextFormatMarkerPair(redFormat, "$");
        var blueMarker = new FlxTextFormatMarkerPair(blueFormat, "#");

        super(500, 300, "Warning!");

        var btnX:Float = windo.x + (windo.width / 2); 
        var btnY:Float = windo.y + windo.height - 120;

        btn = new UiButton(btnX, btnY, 100, 30, "Ok", 1, function(){
            close();
        });
        info = new UiText(windo.x + 10, windo.y + 40, 0, "Test", 15);

        info.applyMarkup(
            "This is in $WIP$ and Helped #Ai# for Coding!\n  If you want to contibute, Check my #Github#!",
            [redMarker, blueMarker]
        );

        add(info);
        add(btn); 
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        btn.x = (windo.x + (windo.width / 2) - (btn.width / 2)) + 180;
        btn.y = windo.y + windo.height - btn.height - 20;
        
        info.x = windo.x + 10;
        info.y = windo.y + 40;
    }
}
