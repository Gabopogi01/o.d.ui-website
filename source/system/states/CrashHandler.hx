package system.states;

import system.backend.sprite.ui.UiWindow;
import system.backend.sprite.ui.UiText;

class CrashHandler extends UiWindow {
    public function new(infoa:Dynamic){
        super(400, 500, "Crash!");
        var info = new UiText(windo.x + 5, windo.y + 40, 0, Std.string(infoa), 15);
        add(info);
    }
}