import flash.Lib;
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

import flixel.tweens.FlxTween;                                                  
import flixel.tweens.motion.LinearMotion;                                       
import flixel.tweens.FlxTween.TweenOptions;

class PlayState extends State {
    private var background: FlxSprite;
    private var explosions: FlxGroup;
    private var leftText: FlxText;
    private var rightText: FlxText;
    private var deepExplosionSound: FlxSound;

    // HUD
    private var itemBar: Array<Button>;
    private var dialogBox: Button;
    private var flashback: Button;

    // Clickable itens:
    private var dagger1: Button;
    private var dagger2: Button;
    private var hammer: Button;

    // Clickable rooms.
    private var rooms: FlxGroup;

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

        // Place all itens on the scene
        createItens();

        createRooms();

        // Done!!
		super.create();
	}

    private function createItens(): Void {
        dagger1 = new Button(moveToBar, 200, 200, "dagger.png");
        dagger2 = new Button(moveToBar, 300, 300, "dagger.png");
        hammer = new Button(moveToBar, 200, 350, "hammer.png");
        add(dagger1);
        add(dagger2);
        add(hammer);
    }

    private function createRooms(): Void {
        rooms = new FlxGroup();
        rooms.add(new Button(roomCallback, overRoomCallback, 240, 270,
                             "bright1.png"));
        rooms.add(new Button(roomCallback, overRoomCallback, 430, 270, 
                             "bright1.png"));
        rooms.add(new Button(roomCallback, overRoomCallback, 575, 270,
                             "bright3.png"));
        rooms.add(new Button(roomCallback, overRoomCallback, 304, 383,
                             "bright4.png"));
        rooms.add(new Button(roomCallback, overRoomCallback, 543, 383,
                             "bright5.png"));
        add(rooms);
        rooms.setAll("visible", false);
        rooms.callAll("kill");
    }

    // Move an item to itemBar.
    private function moveToBar(button: Button): Void {
        itemBar.push(button);

        var options: TweenOptions;                                              
        options = {                                                             
            type: FlxTween.ONESHOT,                                             
        };                                                                      
        // Explanation: linearMotion(object, fromX, fromY, toX, toY,            
        //                           durationOrSpeed, useAsDuration, options)   
        FlxTween.linearMotion(button, button.getX(), button.getY(),
                                      40 * itemBar.length, 32, 0.65, true,
                                      options); 
    }

    // When a dialog box is clicked, it does...
    private function dialogCallback(button: Button): Void {
        if (button.text.text == "   Ameba!") {
            button.kill();
        } else {
            button.text.text = "   Ameba!";
        }
    }

    private function roomCallback(button: Button): Void {
        rooms.callAll("kill");
    }

    private function overRoomCallback(button: Button): Void {
        button.visible = true;
    }

    private function flashbackCallback(button: Button): Void {
        rooms.callAll("revive");
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
        itemBar = new Array<Button>();

        leftText = new FlxText(10, 10, 200, "Explosions: " +
                               explosions.countLiving(), 20);
        add(leftText);

        rightText = new FlxText(FlxG.width - 280, 10, 170, "=)", 20);
        rightText.alignment = "right";
        add(rightText);

        dialogBox = new Button(dialogCallback, 400, 523, "dialogBox.png",
                               "   Long long text. =)\n" +
                               "   Second line.",
                               0xffffff, 20);
        dialogBox.kill();
        add(dialogBox);
        add(dialogBox.text);

        flashback = new Button(flashbackCallback, FlxG.width - 40, 32,
                               "flashback.png");
        add(flashback);
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

        if (FlxG.keyboard.justReleased("SPACE")) {
            //create dialog box.
            dialogBox.revive();
        }
        #end

        // HUD
        leftText.text = "Explosions: " + explosions.countLiving();
        rightText.text = "=)";
        rooms.setAll("visible", false);

		super.update();
	}


    /**
     * Creates a new explosion sprite
     */
    private function createExplosionAt(x: Float, y: Float): Explosion {
        if (explosions.countDead() > 0) {
            var explosion: Explosion = cast(explosions.getFirstDead(), Explosion);
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
