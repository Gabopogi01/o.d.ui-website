package system.ui;

import flixel.FlxG;
import system.backend.sprite.ui.UiText;
import flixel.FlxCamera;
import flixel.FlxSprite;
import system.backend.Paths;

enum UiElement {
    Text(element: UiText);
    Sprite(element: FlxSprite);
}

class Info {
    public static var pusha:Array<UiElement> = [];
    public static var textCam:FlxCamera;
    public static var whilekill = false;

    public static function create(parsed:Array<{type:String, label:String, path:String}>){
        if (textCam == null){
            textCam = new FlxCamera(0, 0, 600, 25);
            textCam.bgColor = 0x00000000;
            FlxG.cameras.add(textCam);
        }

        var next = 0.0;

        for (i in parsed)  {
            if (i == null){
                var textobj = new UiText(15, (15 + (next * 16)), 0, "--------------------------------------------", 14);
                textobj.camera = textCam;
                FlxG.state.insert(100, textobj);
                textobj.changeFont(Paths.font("Shag-Lounge"));
                
                pusha.push(Text(textobj));

                textCam.height += 20;
                next++;
                continue;
            }

            if (i.type == null) {
                var textobj = new UiText(15, 15 + (next * 16), 0, null, 14);
                textobj.camera = textCam;
                textobj.text = i.label;
                FlxG.state.insert(100, textobj);
                textobj.changeFont(Paths.font("Shag-Lounge"));
                next++;
                
                pusha.push(Text(textobj));

                textCam.height += 20;
            } else if (i.type == "img") {
                var imgobj = new FlxSprite(0,0);
                imgobj.loadGraphic(Paths.pic(i.path));
                imgobj.scale.set(0.45, 0.45);
                imgobj.updateHitbox();
                imgobj.x = 15;
                imgobj.y = 15 + (next * 16);
                trace(i.path);
                imgobj.camera = textCam;
                FlxG.state.add(imgobj);
                next += 20.5;
                
                pusha.push(Sprite(imgobj));

                textCam.height += 350;
            } else if (i.type == "header") {
                var textobj = new UiText(15, 15 + (next * 16), 0, null, 20);
                textobj.changeFont(Paths.font("5by7"));
                textobj.camera = textCam;
                textobj.text = i.label;
                FlxG.state.insert(100, textobj);
                next += 2;
                
                pusha.push(Text(textobj));

                textCam.height += 26;
            }
        }
    }

    public static function destroy(){
        for (i in pusha){
            switch (i) {
                case Text(textobj):
                    textobj.kill();
                    FlxG.state.remove(textobj);
                case Sprite(imgobj):
                    imgobj.kill();
                    FlxG.state.remove(imgobj);
            }
        }
        pusha = [];
        trace("destroyed text!");
    }
}
