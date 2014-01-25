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
    private var textTimer: FlxTimer;
    private var background: FlxSprite;
    private var leftText: FlxText;
    private var rightText: FlxText;

    // HUD
    private var itemBar: Array<Button>;
    private var flashback: Button;
    private var dialogBox: Button;
    private var dialogs: Array<String>;
    private var dialogIndex: Int;

    // Clickable itens:
    private var dagger1: Button;
    private var dagger2: Button;
    private var hammer: Button;

    // Clickable rooms.
    private var rooms: FlxGroup;

    // Characteres.
    private var detective: Button;
    private var woman: Button;
    private var man: Button;
    private var victim: Button;
    private var detectiveRoom: Button; // Reference to the room where detective is.

	override public function create(): Void {
        // Add background
        background = new Sprite(0, 0, "background.png");
        add(background);

        createDialogs();
        createHUD();

        createRooms();
        createCharacters();
        createItens();

        textTimer = FlxTimer.start(0.75, raiseDialog);
        dialogIndex = 0;
        // Done!!
		super.create();
	}

    private function createDialogs(): Void {
        dialogs = new Array<String>();

        dialogs.push("   This is the crime scene.\n" +
                     "   You are the detective. But not a regular one."); // 0
        dialogs.push("   While in a crime scene, you have the power so see" +
                     "\n   what happend..." ); // 1
        dialogs.push("   ... as you were the criminal."); // 2
        dialogs.push(""); // 3
        dialogs.push("   Hum... What a mystery."); // 4
        dialogs.push(""); // 5
        dialogs.push("   (crying) I can't belive what happened."); // 6
        dialogs.push(""); // 7
        dialogs.push("   You are not thinking I've done that, are you?"); // 8
        dialogs.push(""); // 9
        dialogs.push("   Bleh... I'm DEAD!!!"); // 10
        dialogs.push(""); // 11
    }

    private function raiseDialog(timer: FlxTimer): Void {
        dialogBox.text.text = dialogs[dialogIndex];
        dialogBox.revive();
    }

    // When a dialog box is clicked, it does...
    private function dialogCallback(button: Button): Void {
        dialogIndex++;
        if (dialogs[dialogIndex] == "") {
            button.kill();
            dialogIndex++;
        } else {
            button.text.text = dialogs[dialogIndex];
        }
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
        detectiveRoom = new Button(roomCallback, overRoomCallback, 304, 383,
                             "bright4.png");
        rooms.add(detectiveRoom);
        rooms.add(new Button(roomCallback, overRoomCallback, 543, 383,
                             "bright5.png"));
        add(rooms);
        rooms.setAll("visible", false);
        rooms.callAll("kill");
    }

    private function createCharacters(): Void {
        detective = new Button(detectiveCallback, 100, 100, "detective.png",
                               "", 0xffffff, 30, true, true, 32, 64);
        woman = new Button(womanCallback, 200, 100, "woman.png",
                           "", 0xffffff, 30, true, true, 32, 64);
        man = new Button(manCallback, 300, 100, "culprit.png",
                         "", 0xffffff, 30, true, true, 32, 64);
        victim = new Button(victimCallback, 400, 100, "hipster-victim.png",
                            "", 0xffffff, 30, true, true, 32, 64);

        detective.setAnchor(detective.width / 2, detective.height);
        woman.setAnchor(woman.width / 2, woman.height);
        man.setAnchor(man.width / 2, man.height);
        victim.setAnchor(victim.width / 2, victim.height);

        detective.setPosition(200, 435);
        woman.setPosition(180, 305);
        man.setPosition(490, 305);
        victim.setPosition(390, 305);

        detective.animation.add("walking", [0, 1, 2, 3, 4, 5], 10, true);
        woman.animation.add("idle", [0, 1, 2, 3], 10, true);
        man.animation.add("idle", [0, 1, 2, 3, 4, 5], 10, true);
        victim.animation.add("idle", [0, 1, 2, 3, 4], 10, true);

        detective.animation.play("walking");
        woman.animation.play("idle");
        man.animation.play("idle");
        victim.animation.play("idle");

        add(detective);
        add(woman);
        add(man);
        add(victim);
    }

    private function detectiveCallback(button: Button): Void {
        if (!dialogBox.alive) {
            dialogIndex = 4;
            raiseDialog(textTimer);
        }
    }

    private function womanCallback(button: Button): Void {
        if (!dialogBox.alive) {
            dialogIndex = 6;
            raiseDialog(textTimer);
        }
    }

    private function manCallback(button: Button): Void {
        if (!dialogBox.alive) {
            dialogIndex = 8;
            raiseDialog(textTimer);
        }
    }

    private function victimCallback(button: Button): Void {
        if (!dialogBox.alive) {
            dialogIndex = 10;
            raiseDialog(textTimer);
        }
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

    private function roomCallback(button: Button): Void {
        rooms.callAll("kill");

        var options: TweenOptions;
        options = {
            type: FlxTween.ONESHOT,
            complete: cast moveDetective,
        };
        // Explanation: linearMotion(object, fromX, fromY, toX, toY,
        //                           durationOrSpeed, useAsDuration, options)
        FlxTween.linearMotion(detective, detective.getX(), detective.getY(),
                              detectiveRoom.getX() + detectiveRoom.width
                              - detectiveRoom.width, detective.getY(),
                              0.65, true, options);
        detectiveRoom = button;
    }

    private function moveDetective(): Void {
        detectiveRoom.setPosition(detectiveRoom.getX(), detectiveRoom.getY());
    }

    private function overRoomCallback(button: Button): Void {
        button.visible = true;
    }

    private function flashbackCallback(button: Button): Void {
        rooms.callAll("revive");
    }

    private function createHUD(): Void {
        itemBar = new Array<Button>();

        leftText = new FlxText(10, 10, 200, "Explosions: ", 20);
        add(leftText);

        rightText = new FlxText(FlxG.width - 280, 10, 170, "=)", 20);
        rightText.alignment = "right";
        add(rightText);

        dialogBox = new Button(dialogCallback, 400, 523, "dialogBox.png",
                               dialogs[0], 0xffffff, 20);
        dialogBox.kill();
        add(dialogBox);
        add(dialogBox.text);

        flashback = new Button(flashbackCallback, FlxG.width - 40, 32,
                               "flashback.png");
        add(flashback);
    }

	override public function destroy(): Void {
        if (textTimer != null) {
            textTimer.abort();
            textTimer = null;
        }
		super.destroy();
	}

	override public function update(): Void {
        #if android
        for (touch in FlxG.touches.list) {
            if (touch.justReleased) {
            }
        }
        #end

        #if !mobile
        if (FlxG.mouse.justReleased) {
        }
        #end

        // HUD
        leftText.text = "Explosions: ";
        rightText.text = "=)";
        rooms.setAll("visible", false);

		super.update();
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
