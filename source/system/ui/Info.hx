package system.ui;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxCamera;

class Info {
    public static var pusha:Array<FlxText> = [];
    public static var textCam:FlxCamera;
    public static var whilekill = false;

    public static function create(parsed:Array<{type:String, label:String, path:String}>){
        if (textCam == null){
            textCam = new FlxCamera(0, 0, 600, 25);
            textCam.bgColor = 0x00000000;
            FlxG.cameras.add(textCam);
        }

        var next = 0;

        for (i in parsed)  {
            if (i == null){
                next++;
                continue;
            }

            if (i.label != null) {
                //trace(i.label);
                //trace(i.type);
                trace(i.path);
                if (i.type == null) {
                    var textobj = new FlxText(15, 15 + (next * 16), 0, null, 9);
                    textobj.camera = textCam;
                    textobj.text = i.label;
                    FlxG.state.insert(100, textobj);
                    next++;
                    pusha.push(textobj);
                }
            }

            textCam.height += 15;
        }
    }

    public static function destroy(){
        for (i in pusha){
            i.kill();
            FlxG.state.remove(i);
        }
        pusha = [];
        trace("destroyed text!");
    }
}