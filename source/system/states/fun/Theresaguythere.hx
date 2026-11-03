package system.states.fun;

import flixel.FlxState;
import flixel.FlxG;
import system.backend.Paths;
import system.backend.sprite.fun.Tree;
import openfl.events.Event;
import flixel.system.scaleModes.StageSizeScaleMode;

class Theresaguythere extends FlxState {
    private var tree:Tree;
    override public function create() {
        super.create();
        FlxG.camera.bgColor = 0xFFFFFF;
        FlxG.sound.playMusic(Paths.music("loading"));
        
        tree = new Tree();
        tree.scale.set(2, 2);
        add(tree);
    }

    override public function update(elapsed) {
        super.update(elapsed);

        tree.updateSprite();
        tree.screenCenter();
        tree.x -= 80;
        tree.y -= 50;
    }
}