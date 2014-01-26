
import flixel.system.FlxSound;
import flixel.util.FlxTimer;
import flixel.FlxG;
import haxe.ds.ObjectMap;

class SoundPlayback {

    private var sound: FlxSound;
    private var timer: FlxTimer;
    private var duration: Float;

    public function new(path:String, the_duration: Float = 1) {
        sound = new FlxSound();
        sound.loadEmbedded(path, true, false, play);
        duration = the_duration;
    }

    private function playCallback (the_timer: FlxTimer): Void {
        play();
    }

    public function play(): Void {
        sound.stop();
        sound.play(true);
        timer = FlxTimer.start(duration, playCallback);
    }

}
