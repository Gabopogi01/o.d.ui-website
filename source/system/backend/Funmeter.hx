package system.backend;

import flixel.FlxG;

class Funmeter {
    public static function roll():Int{
        return FlxG.random.int(0, 100);
    }
}