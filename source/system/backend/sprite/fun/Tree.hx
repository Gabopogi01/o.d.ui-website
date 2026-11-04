package system.backend.sprite.fun;

import flixel.FlxSprite;
import system.backend.Paths;
import flixel.FlxG;

class Tree extends FlxSprite {
    private static var leaves1:FlxSprite;
    private static var leaves2:FlxSprite;
    private static var leaves3:FlxSprite;
    public static var sprites:Array<FlxSprite>;
    private static var time:Float;

    public function new() {
        super();
        leaves1 = new FlxSprite().loadGraphic(Paths.image("fun/thetree"), true, 105, 91);
        leaves2 = new FlxSprite().loadGraphic(Paths.image("fun/thetree"), true, 105, 91);
        leaves3 = new FlxSprite().loadGraphic(Paths.image("fun/thetree"), true, 105, 91);
        leaves1.antialiasing = false;
        leaves2.antialiasing = false;
        leaves1.animation.add("leaves", [0]);
        leaves1.animation.play('leaves');
        leaves2.animation.add("leaves", [1]);
        leaves2.animation.play('leaves');
        
        FlxG.state.insert(2,leaves1);
        FlxG.state.insert(3,leaves2);

        leaves3.loadGraphic(Paths.image("fun/thetree"), true, 105, 91);
        leaves3.antialiasing = false;
        leaves3.animation.add('branch', [2]);
        leaves3.animation.play('branch');
        FlxG.state.add(leaves3);

        for (i in [leaves1, leaves2, leaves3]){
            sprites.push(i);
        }
        alpha = 0;
    }

    public function updateSprite(){
        time += 0.1;
        for (i in sprites){
            i.scale.set(this.scale.x, this.scale.y);
        }

        leaves2.x = Math.sin(time / 2) + this.x;
        leaves2.y = this.y;
        leaves1.y = this.y;
        leaves1.x = this.x;
        leaves3.x = Math.sin(time / 3) + this.x;
        leaves3.y = (Math.sin(time / 4) / 2) + this.y;
    }
}