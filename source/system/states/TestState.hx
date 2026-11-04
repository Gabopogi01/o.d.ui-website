package system.states;

import flixel.FlxState;
import system.backend.sprite.ui.UiButton;

class TestState extends FlxState {
    var bnt:UiButton;
    override function create() {
        super.create();
        bnt = new UiButton(0, 0, 90, 30, "Reload");
        add(bnt);
    }

    override function update(elapsed){
        super.update(elapsed);
        
    }
}