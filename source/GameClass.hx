import flash.Lib;
import flixel.FlxGame;
import flixel.FlxG;

class GameClass extends FlxGame {
    public function new() {
        var stageWidth: Int = Lib.current.stage.stageWidth;
        var stageHeight: Int = Lib.current.stage.stageHeight;

        var canvasWidth: Int = 960;
        var canvasHeight: Int = 640;

        var ratioX: Float = stageWidth / canvasWidth;
        var ratioY: Float = stageHeight / canvasHeight;
        var ratio: Float = Math.min(ratioX, ratioY);

        if (ratio < 0.7) {
            canvasWidth = Math.floor(canvasWidth / 2);
            canvasHeight = Math.floor(canvasHeight / 2);
            ratioX = stageWidth / canvasWidth;
            ratioY = stageHeight / canvasHeight;
            ratio = Math.min(ratioX, ratioY);
        }

        var fps: Int = 30;

        #if !FLX_NO_DEBUG
        FlxG.debugger.visualDebug = true;
        #end

        #if web
        StateManager.initialState = PreLoader;
        super(canvasWidth, canvasHeight, StateManager, ratio, fps, fps, true);
        #else
        super(canvasWidth, canvasHeight, PreLoader, ratio, fps, fps, true);
        #end
    }
}
