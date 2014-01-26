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
    private var timer: FlxTimer;
    private var background: Sprite;

    // HUD
    private var itemBar: Array<Button>;
    private var flashback: Button;
    private var move: Button;
    private var dialogBox: Button;
    private var dialogs: Array<String>;
    private var dialogIndex: Int;

    // House itens:
    private var hammer: Button;
    private var booklets: Button;
    private var fireplace: Sprite;
    private var key: Button;
    private var lamp: Button;
    private var drugs: Button;
    private var newspaper: Button;
    private var door: Button;
    private var pc: Button;
    private var toilet: Button;
    private var toolbox: Button;

    // Clickable rooms.
    private var rooms: FlxGroup;

    // Characteres.
    private var shadow: Sprite;
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
        createItens();
        createCharacters();

        timer = FlxTimer.start(0.75, raiseDialog);
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
/* 02 */dialogs.push("... as you if you were the criminal."); // 2
/* 03 */dialogs.push(""); // 3
/* 04 */dialogs.push("Hum... What a mystery."); // 4
/* 05 */dialogs.push(""); // 5
/* 06 */dialogs.push("(crying) I can't belive what happened."); // 6
/* 07 */dialogs.push(""); // 7
/* 08 */dialogs.push("You are not thinking I've done that, are you?"); // 8
/* 09 */dialogs.push(""); // 9
/* 10 */dialogs.push("Cause of death: trauma to the back of the head by" +
                     "\n   a blunt weapon."); // 10
/* 11 */dialogs.push(""); // 11
/* 12 */dialogs.push("Click on the room where you wish to go."); //12
/* 13 */dialogs.push(""); //13

        // Woman
/* 14 */dialogs.push("This is terrible... With all the things I've done..." +
                     "\n   sob... He even hugged me after seeing the body...");
/* 15 */dialogs.push("");
/* 16 */dialogs.push("Me and Hipster Guy argued about sending Big Guy to rehab." +
                     "\n   He said it wasn't necessary! Did he not care about my" +
                     "\n   my husband!?");
/* 17 */dialogs.push("");
/* 18 */dialogs.push("You know, I love my husband, but he has a problem with" +
                     "\n   drugs...");
/* 19 */dialogs.push("");
/* 20 */dialogs.push("I don't know where this key came from!");
/* 21 */dialogs.push("");
/* 22 */dialogs.push("Yes, we had an affair. Hipster Guy consoled me when my" +
                     "\n   husband was... altered.");
/* 23 */dialogs.push("");

        // Man
/* 24 */dialogs.push("My hammer? I lent it to a friend.");
/* 25 */dialogs.push("");
/* 26 */dialogs.push("Yes, the drugs are mine... By that has nothing to do" +
                     "\n   with the issue at hand, so shouldn't we focus in the" +
                     "\n   murder?");
/* 27 */dialogs.push("");
/* 28 */dialogs.push("I was taking a shower. When I left the bathroom, he was" +
                     "\n   already laying on the floor. The house was locked with only" +
                     "\n   my wife and I, until you arrived.");
/* 29 */dialogs.push("");
/* 30 */dialogs.push("Why the hell was she with the key?! That's very suspecious!");
/* 31 */dialogs.push("");

        // Toolbox
/* 32 */dialogs.push("What a nice toolbox, hum.");
/* 33 */dialogs.push("");
/* 34 */dialogs.push("Well, well. It looks like there is no hammer in this" +
                     "\n   toolbox. Strange, isn't it?");
/* 35 */dialogs.push("");

        // Door
/* 36 */dialogs.push("This door's lock is reachable from both sides. But there is no key.");
/* 37 */dialogs.push("");
/* 38 */dialogs.push("Here we go, let's test it. Yup, the missing key is definetly" +
                     "\n   this one.");
/* 39 */dialogs.push("");
/* 40 */dialogs.push("This door's lock is reachable from both sides. Hum, the key is" +
                     "\n   missing, but perhaps... Yup, that key goes here.");
/* 41 */dialogs.push("");

        // Key
/* 42 */dialogs.push("Hum... This must open that door.");
/* 43 */dialogs.push("");
/* 44 */dialogs.push("Let's find out where I can use it.");
/* 45 */dialogs.push("");

        // Newspaper
/* 46 */dialogs.push("There is a picture of Big Guy holding a hammer in front of a" +
                     "\n   huge treehouse. Hum, where can I find that hammer?");
/* 47 */dialogs.push("");

        // Hammer
/* 48 */dialogs.push("This is the murder weapon! Now I can solve the case." +
                     "\n   The cuprit is...");
/* 49 */dialogs.push("");

        // Lamp
/* 50 */dialogs.push("Maybe this could have caused the trauma to the victim's head.");
/* 51 */dialogs.push("");
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
        hammer    = new Button(moveToBar, 520, 400, "hammer.png");
        booklets  = new Button(moveToBar, 210, 370, "booklets.png");
        fireplace = new Sprite(290, 352, "fireplace.png", true, false, 96, 96);
        fireplace.animation.add("burn", [0, 1, 2, 3], 10, true);
        fireplace.animation.play("burn");
        key       = new Button(moveToBar, 240, 300, "key.png");
        key.kill();
        lamp      = new Button(moveToBar, 240, 400, "lamp.png");
        drugs     = new Button(moveToBar, 590, 292, "marijuana.png");
        drugs.kill();
        newspaper = new Button(moveToBar, 270, 270, "newspaper.png");
        door      = new Button(moveToBar, 539, 274, "open-door.png");
        pc        = new Button(moveToBar, 363, 290, "pc.png");
        toilet    = new Button(moveToBar, 590, 292, "toilet.png");
        toolbox   = new Button(moveToBar, 400, 290, "toolkit.png");

        add(hammer);
        add(booklets);
        add(fireplace);
        add(key);
        add(lamp);
        add(drugs);
        add(newspaper);
        add(door);
        add(pc);
        add(toilet);
        add(toolbox);
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
        shadow = new Sprite(100, 100, "shadow.png", true, true, 32, 64);
        detective = new Button(detectiveCallback, 100, 100, "detective.png",
                               "", 0xffffff, 30, true, true, 32, 64);
        woman = new Button(womanCallback, 200, 100, "woman.png",
                           "", 0xffffff, 30, true, true, 32, 64);
        man = new Button(manCallback, 300, 100, "culprit.png",
                         "", 0xffffff, 30, true, true, 32, 64);
        victim = new Button(victimCallback, 400, 100, "hipster-victim.png",
                            "", 0xffffff, 30, true, true, 32, 64);

        shadow.setAnchor(shadow.width / 2, shadow.height);
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

        shadow.animation.add("idle", [0], 10, false);
        shadow.animation.add("kill", [0, 1, 2, 3, 4, 5], 10, false);
        detective.animation.add("idle", [0, 1, 2, 3, 4, 5], 10, true);
        detective.animation.add("walking", [6, 7, 8, 9, 10, 11], 10, true);
        woman.animation.add("idle", [0, 1, 2, 3], 10, true);
        man.animation.add("idle", [0, 1, 2, 3, 4, 5], 10, true);
        victim.animation.add("stand", [0], 10, false);
        victim.animation.add("dying", [0, 1, 2, 3, 4, 3], 10, false);
        victim.animation.add("dead", [3], 10, false);

        shadow.animation.play("idle");
        shadow.kill();
        detective.animation.play("idle");
        woman.animation.play("idle");
        man.animation.play("idle");
        victim.animation.play("dead");

        add(shadow);
        add(detective);
        add(woman);
        add(man);
        add(victim);
    }

    private function detectiveCallback(button: Button): Void {
        if (!dialogBox.alive) {
            dialogIndex = 4;
            raiseDialog(timer);
        }
    }

    private function womanCallback(button: Button): Void {
        if (!dialogBox.alive) {
            dialogIndex = 14;
            if (hasKey) {
                dialogIndex = 20;
            } else if (hasBooklet) {
                dialogIndex = 16;
                fakeWhy = true;
                key.revive();
            } else if (hasDrugs) {
                dialogIndex = 18;
            } else if (knownAffair) {
                dialogIndex = 22;
            }
            raiseDialog(timer);
        }
    }

    private function manCallback(button: Button): Void {
        if (!dialogBox.alive) {
            dialogIndex = 28;
            if (hasKey) {
                dialogIndex = 30;
            } else if (noHammer) {
                dialogIndex = 24;
            } else if (hasDrugs) {
                dialogIndex = 26;
            }
            raiseDialog(timer);
        }
    }

    private function victimCallback(button: Button): Void {
        if (!dialogBox.alive) {
            dialogIndex = 10;
            raiseDialog(timer);
        }
    }

    // Move an item to itemBar.
    private function moveToBar(button: Button): Void {
        // If it is already on the bar, do nothing.
        if (button.getY() < 40) {
            return;
        }
        if (button == hammer) {
            //TODO
        } else if (button == booklets) {
            hasBooklet = true;
        } else if (button == key) {
            hasKey = true;
            if (noKeyInBathroom) {
                how = true;
            }
        } else if (button == lamp) {
            dialogIndex = 50;
            raiseDialog(timer);
            return;
        } else if (button == door) {
            noKeyInBathroom = true;
            if (hasKey) {
                how = true;
            }
            return;
        } else if (button == pc) {
            knownAffair = true;
            why = true;
            return;
        } else if (button == toilet) {
            drugs.revive();
            hasDrugs = true;
            button = drugs;
        } else if (button == toolbox) {
            noHammer = true;
            return;
        } else if (button == newspaper) {
            carpinter = true;
            dialogIndex = 46;
            raiseDialog(timer);
            return;
        }
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
                              detectiveRoom.y + detectiveRoom.height - 4);
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
            raiseDialog(timer);
        }
    }

    /***
     * Scene:
     * Everybody is hiden. Shadow apears in the offiece, where victim is alive.
     * Shadow goes to victim, attack and victim dies.
     * Shadow fades and everybody reapears.
     */
    private function flashbackCallback(button: Button): Void {
        shadow.revive();
        shadow.alpha = 0;
        shadow.setPosition(360, 305);
        shadow.animation.play("idle");

        var options: TweenOptions;
        options = {
            type: FlxTween.ONESHOT,
            complete: cast shadowAttack,
        };
        FlxTween.multiVar(shadow, { x: 450, alpha: 1}, 2.0, options);

        detective.kill();
        woman.kill();
        man.kill();
        victim.animation.play("stand");
    }

    private function shadowAttack(): Void {
        shadow.animation.play("kill");
        timer = FlxTimer.start(0.4, shadowWaits);
    }

    private function shadowWaits(timer: FlxTimer): Void {
        timer = FlxTimer.start(1, shadowFade);
        victim.animation.play("dying");
    }

    private function shadowFade(timer: FlxTimer): Void {
        var options: TweenOptions;
        options = {
            type: FlxTween.ONESHOT,
            complete: cast reviveAll,
        };
        FlxTween.multiVar(shadow, { x: 490, alpha: 0}, 0.8, options);
    }

    private function reviveAll(): Void {
        shadow.kill();
        detective.revive();
        woman.revive();
        man.revive();
        victim.animation.play("dead");
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
        if (timer != null) {
            timer.abort();
            timer = null;
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
