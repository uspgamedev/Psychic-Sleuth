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
    private var background: Sprite;

    // HUD
    private var itemBar: Array<Button>;
    private var flashback: Button;
    private var move: Button;
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
    private var originRoom: Button;
    private var detectiveRoom: Button; // Reference to the room where detective is.

    // Flags
    private var hasBooklet: Bool = false;
    private var hasDrugs: Bool = false;
    private var hasKey: Bool = false;
    private var knownAffair: Bool = false;
    private var noHammer: Bool = false;
    private var carpinter: Bool = false;
    private var noKeyInBathroom: Bool = false;
    private var why: Bool = false;
    private var how: Bool = false;
    private var fakeWhy: Bool = false;

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

/* 00 */dialogs.push("This is the crime scene." +
                     "\n   You are the detective. But not a regular one."); // 0
/* 01 */dialogs.push("While in a crime scene, you have the power so see" +
                     "\n   what happend..." ); // 1
/* 02 */dialogs.push("... as you were the criminal."); // 2
/* 03 */dialogs.push(""); // 3
/* 04 */dialogs.push("Hum... What a mystery."); // 4
/* 05 */dialogs.push(""); // 5
/* 06 */dialogs.push("(crying) I can't belive what happened."); // 6
/* 07 */dialogs.push(""); // 7
/* 08 */dialogs.push("You are not thinking I've done that, are you?"); // 8
/* 09 */dialogs.push(""); // 9
/* 10 */dialogs.push("Bleh... I'm DEAD!!!"); // 10
/* 11 */dialogs.push(""); // 11
/* 12 */dialogs.push("Click on the romm where you wish to go."); //12
/* 13 */dialogs.push(""); //13

        // Woman
/* 14 */dialogs.push("I'm traumatized and a bit guilty.");
/* 15 */dialogs.push("");
/* 16 */dialogs.push("I've had a little disaffection with Mr. Hipster.");
/* 17 */dialogs.push("");
/* 18 */dialogs.push("You know, I love my husband.");
/* 19 */dialogs.push("");
/* 20 */dialogs.push("I don't know where this key came from!");
/* 21 */dialogs.push("");
/* 22 */dialogs.push("Yes, we had an affair.");
/* 23 */dialogs.push("");

        // Man
/* 24 */dialogs.push("I lent my hammer.");
/* 25 */dialogs.push("");
/* 26 */dialogs.push("Yes, the drugs are mine!");
/* 27 */dialogs.push("");
/* 28 */dialogs.push("When I left the bathroom, he was laid on the floor.");
/* 29 */dialogs.push("");
/* 30 */dialogs.push("Why the hell she was with the key?!");
/* 31 */dialogs.push("");

        // Toolbox
/* 32 */dialogs.push("What a nice toolbox, hun.");
/* 33 */dialogs.push("");
/* 34 */dialogs.push("Well, well. I looks like there is no hammer in this" +
                     "toolbox. Strange, isn't it?");
/* 35 */dialogs.push("");

        // Door
/* 36 */dialogs.push("This door is locked.");
/* 37 */dialogs.push("");
/* 38 */dialogs.push("Here we go. The door is unlocked now.");
/* 39 */dialogs.push("");
/* 40 */dialogs.push("So that key goes here.");
/* 41 */dialogs.push("");

        // Key
/* 42 */dialogs.push("Hum... This must open that door.");
/* 43 */dialogs.push("");
/* 44 */dialogs.push("Let's find out where I can use it.");
/* 45 */dialogs.push("");
    }

    private function raiseDialog(timer: FlxTimer): Void {
        dialogBox.text.text = "   " + dialogs[dialogIndex];
        dialogBox.revive();
    }

    // When a dialog box is clicked, it does...
    private function dialogCallback(button: Button): Void {
        dialogIndex++;
        if (dialogs[dialogIndex] == "") {
            dialogBox.kill();
            dialogIndex++;
        } else {
            dialogBox.text.text = "   " + dialogs[dialogIndex];
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

        // Positioning everybody.
        detective.setPosition(200, 440);
        woman.setPosition(180, 310);
        man.setPosition(390, 440);
        victim.setPosition(490, 316);
        man.facing = FlxObject.LEFT;

        detective.animation.add("idle", [0, 1, 2, 3, 4, 5], 10, true);
        detective.animation.add("walking", [6, 7, 8, 9, 10, 11], 10, true);
        woman.animation.add("idle", [0, 1, 2, 3], 10, true);
        man.animation.add("idle", [0, 1, 2, 3, 4, 5], 10, true);
        victim.animation.add("dying", [0, 1, 2, 3, 4], 10, true);
        victim.animation.add("dead", [3], 10, false);

        detective.animation.play("idle");
        woman.animation.play("idle");
        man.animation.play("idle");
        victim.animation.play("dead");

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
            dialogIndex = 14;
            if (knownAffair) {
                dialogIndex = 22;
            } else if (hasKey) {
                dialogIndex = 20;
            } else if (hasDrugs) {
                dialogIndex = 18;
            } else if (hasBooklet) {
                dialogIndex = 16;
            }
            raiseDialog(textTimer);
        }
    }

    private function manCallback(button: Button): Void {
        if (!dialogBox.alive) {
            dialogIndex = 28;
            if (hasKey) {
                dialogIndex = 30;
            } else if (hasDrugs) {
                dialogIndex = 26;
            } else if (noHammer) {
                dialogIndex = 24;
            }
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
                              140 + 40 * itemBar.length, 32, 0.65, true,
                              options);
    }

    private function roomCallback(button: Button): Void {
        rooms.callAll("kill");

        originRoom = detectiveRoom;
        moveDetective();
        detectiveRoom = button;
    }

    private function moveDetective(): Void {
        var options: TweenOptions;
        options = {
            type: FlxTween.ONESHOT,
            complete: cast fadeDetective,
        };
        var toX = originRoom.x + originRoom.width / 2;
        FlxTween.multiVar(detective, { x: toX,
                                     }, 0.8, options);
        detective.animation.play("walking");
    }

    private function fadeDetective() {
        var options: TweenOptions;
        options = {
            type: FlxTween.ONESHOT,
            complete: cast stopDetective,
        };
        var toX = originRoom.x + originRoom.width - detective.width / 2;
        FlxTween.multiVar(detective, { x: toX,
                                       alpha: 0,
                                     }, 0.8, options);
    }

    private function stopDetective(): Void {
        detective.setPosition(detectiveRoom.x,
                              detectiveRoom.y + detectiveRoom.height - 8);
        var options: TweenOptions;
        options = {
            type: FlxTween.ONESHOT,
            complete: cast idleDetective,
        };
        var toX = detectiveRoom.x + detective.width / 2;
        FlxTween.multiVar(detective, { x: toX,
                                       alpha: 1,
                                     }, 0.8, options);
    }

    private function idleDetective(): Void {
        detective.animation.play("idle");
    }

    private function overRoomCallback(button: Button): Void {
        button.visible = true;
    }

    private function moveCallback(button: Button): Void {
        rooms.callAll("revive");

        if (!dialogBox.alive) {
            dialogCallback(button);
            dialogIndex = 12;
            raiseDialog(textTimer);
        }
    }

    private function flashbackCallback(button: Button): Void {
    }

    private function createHUD(): Void {
        add(new FlxText(32, 16, 180, "Evidences: ", 20));
        add(new FlxText(600, 16, 180, "Actions: ", 20));
        itemBar = new Array<Button>();

        dialogBox = new Button(dialogCallback, 400, 523, "dialogBox.png",
                               "   " + dialogs[0], 0xffffff, 20);
        add(dialogBox);
        add(dialogBox.text);

        flashback = new Button(flashbackCallback, FlxG.width - 80, 32,
                               "flashback.png");
        add(flashback);

        move = new Button(moveCallback, FlxG.width - 40, 32, "move.png");
        add(move);
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
