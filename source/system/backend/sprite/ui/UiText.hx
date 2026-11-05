package system.backend.sprite.ui;

import flixel.text.FlxText;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.util.FlxColor;
import system.backend.Paths;

class UiText extends FlxText{
    public function new(X, Y, Width, Text, Size, ?Bodersize:Float = 1.2){
        super(X, Y, Width, Text, Size);

        setFormat(Paths.font("vcr"), Size, FlxColor.WHITE, CENTER);
        setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, Bodersize);
    }

    public function changeFont(fonte:String){
        font = fonte;
    }
}