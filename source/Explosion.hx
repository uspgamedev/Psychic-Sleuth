import flixel.FlxG;
import flixel.system.FlxSound;
import flixel.animation.FlxAnimationController;

class Explosion extends Sprite {
    private var sound: FlxSound;

    public function new(explosionSound: FlxSound) {
        super(0, 0, "explosion.png", 128, 128);
        setAnchor(width / 2, height / 2);
        animation.add("exploding",
                      [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19],
                      20, false);
        sound = explosionSound;
    }

    override public function revive(): Void {
        super.revive();
        animation.play("exploding");
        sound.stop();
        sound.play();
    }

    override public function update(): Void {
        if (alive) {
            if (animation.finished) {
                kill();
            }
        }

        super.update();
    }
}
