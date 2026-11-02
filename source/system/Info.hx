package system;

import haxe.Json;
import lime.utils.Assets;
import flixel.FlxG;
import flixel.text.FlxText;

class Info {
    public static var pusha:Array<FlxText>;

    static public function read(file:String){
        if (Assets.exists(file) == false) {
            FlxG.log.error(file + " Does not Exists!");
            return;
        } else {
            text(Assets.getText(file));
        };
    }
}