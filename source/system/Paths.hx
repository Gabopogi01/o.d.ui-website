package system;

import flixel.FlxG;
import lime.utils.Assets;

class Paths {
    static public function file(direction:String){
        var fullDirec = "assets/" + direction; 
        
        if (Assets.exists(fullDirec) == false){
            FlxG.log.warn(file + " Does not Exists!");
            return null;
        } else {
            return fullDirec;
        }
    }

    static public function image(direction:String){
        var fullDirec = "assets/images/" + direction + ".png"; 

        if (Assets.exists(fullDirec) == false){
            FlxG.log.warn(file + " Does not Exists!");
            return null;
        } else {
            return fullDirec;
        }
    }
}