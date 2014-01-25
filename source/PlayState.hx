import flash.events.Event;
import flash.events.KeyboardEvent;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxMath;
import flixel.util.FlxTimer;
import flixel.util.FlxArrayUtil;
import flixel.group.FlxGroup;
import flixel.system.FlxSound;

class PlayState extends State {
    private var background: FlxSprite;
    private var explosions: FlxGroup;
    private var leftText: FlxText;
    private var rightText: FlxText;
    private var deepExplosionSound: FlxSound;

	override public function create(): Void {
        // Load sound
        deepExplosionSound = new FlxSound();
        deepExplosionSound.loadEmbedded("assets/sounds/underwater_explosion.ogg");

        // Add background
        background = new Sprite(0, 0, "background.png");
        add(background);

        // Setup explosion groups.
        createExplosions();

        // Setup the HUD
        createHUD();

        // Done!!
		super.create();
	}

    private function createExplosions(): Void {
        explosions = new FlxGroup();
        for (i in 0...30) {
            var explosion: Explosion = new Explosion(deepExplosionSound);
            explosion.kill();
            explosions.add(explosion);
        }
        add(explosions);
    }

    private function createHUD(): Void {
        leftText = new FlxText(10, 10, 200, "Explosions: " +
                               explosions.countLiving(), 20);
        add(leftText);

        rightText = new FlxText(FlxG.width - 180, 10, 170, "=)", 20);
        rightText.alignment = "right";
        add(rightText);
    }

	override public function destroy(): Void {
		super.destroy();
	}

	override public function update(): Void {
        #if android
        for (touch in FlxG.touches.list) {
            if (touch.justReleased) {
                createExplosionAt(touch.x, touch.y);
            }
        }
        #end

        #if !mobile
        if (FlxG.mouse.justReleased) {
            createExplosionAt(FlxG.mouse.x, FlxG.mouse.y);
        }
        #end

        // HUD
        leftText.text = "Explosions: " + explosions.countLiving();
        rightText.text = "=)";

		super.update();
	}


    /**
     * Creates a new explosion sprite
     */
    private function createExplosionAt(x: Float, y: Float): Explosion {
        if (explosions.countDead() > 0) {
            var explosion: Explosion = cast explosions.getFirstDead();
            explosion.setPosition(x, y);
            explosion.revive();
            return explosion;
        }
        else {
            return null; // this should never happen...
        }
    }

    override public function onBackButton(event: KeyboardEvent): Void {
        // Get ESCAPE from keyboard or BACK from android.
        if (event.keyCode == 27) {
            switchState(new MenuState());
            #if android
            event.stopImmediatePropagation();
            #end
        }
    }
}
