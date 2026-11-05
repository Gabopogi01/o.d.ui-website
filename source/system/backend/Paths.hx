package system.backend;

import flixel.FlxG;
import lime.utils.Assets;

class Paths {
    static public function file(direction:String){
        var fullDirec = "assets/" + direction; 
        
        if (Assets.exists(fullDirec) == false){
            trace(fullDirec + " Does not Exists!");
            return null;
        } else {
            return fullDirec;
        }
    }

    static public function shader(direction:String){
        var fullDirec = "assets/shader/" + direction + ".frag"; 

        if (Assets.exists(fullDirec) == false){
            trace(fullDirec + " Does not Exists!");
            return null;
        } else {
            return fullDirec;
        }
    }

    static public function image(direction:String){
        var fullDirec = "assets/images/" + direction + ".png"; 

        if (Assets.exists(fullDirec) == false){
            trace(fullDirec + " Does not Exists!");
            return null;
        } else {
            return fullDirec;
        }
    }

    static public function font(direction:String){
        var fullDirec = "assets/fonts/" + direction + ".ttf"; 

        if (Assets.exists(fullDirec) == false){
            trace(fullDirec + " Does not Exists!");
            return null;
        } else {
            return fullDirec;
        }
    }
    static public function music(direction:String){
        var fullDirec = "assets/music/" + direction + ".ogg"; 

        if (Assets.exists(fullDirec) == false){
            trace(fullDirec + " Does not Exists!");
            return null;
        } else {
            return fullDirec;
        }
    }

    static public function json(direction:String){
        var fullDirec = "jsons/" + direction; 
        
        if (Assets.exists(fullDirec) == false){
            trace(file + " Does not Exists!");
            return null;
        } else {
            return fullDirec;
        }
    }

    static public function sound(direction:String){
        var fullDirec = "assets/sounds/" + direction + ".ogg"; 
        
        if (Assets.exists(fullDirec) == false){
            trace(file + " Does not Exists!");
            return null;
        } else {
            return fullDirec;
        }
    }

    static public function pic(direction:String){
        var fullDirec = "pic/" + direction + ".png"; 
        
        if (Assets.exists(fullDirec) == false){
            trace(file + " Does not Exists!");
            return null;
        } else {
            return fullDirec;
        }
    }

}