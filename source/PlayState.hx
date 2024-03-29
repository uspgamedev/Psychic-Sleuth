import flash.Lib;
import flash.events.Event;
import flash.events.KeyboardEvent;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxTimer;
import flixel.util.FlxArrayUtil;
import flixel.util.FlxSoundUtil;
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

    // Sounds and musics
    private var gettoSound: FlxSound;
    private var checkSound: FlxSound;
    private var buttonSound: FlxSound;
    private var talkSound: FlxSound;
    //private var bgMusic: FlxSound;
    private var bgMusic: SoundPlayback;

    // Dialog nexter
    private var next: Button;

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
    private var fridge: Button;

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
    private var finalScene: Bool = false;
    private var finished: Bool = false;

	override public function create(): Void {
        // Add background
        background = new Sprite(0, 0, "background.png");
        add(background);

        next = new Button(moveToBar, 400, 300, "invisibleButton.png");
        add(next);

        createDialogs();
        createHUD();
        loadSounds();

        createRooms();
        createItens();
        createCharacters();

        timer = FlxTimer.start(0.75, raiseDialog);
        dialogIndex = 0;

        bgMusic.play();
        //playbackBG();

        // Done!!
		super.create();
	}

    private function loadSounds(): Void {
        //bgMusic = new FlxSound();
        //bgMusic.loadEmbedded("assets/sounds/start_game.ogg", true, false, playbackBG);
        bgMusic = new SoundPlayback("assets/sounds/start_game.ogg", 12.0);
        gettoSound = new FlxSound();
        gettoSound.loadEmbedded("assets/sounds/qubodupItemHandling2.wav");
        checkSound = new FlxSound();
        checkSound.loadEmbedded("assets/sounds/qubodupItemHandling4.wav");
        buttonSound = new FlxSound();
        buttonSound.loadEmbedded("assets/sounds/Clic07.mp3.ogg");
        talkSound = new FlxSound();
        talkSound.loadEmbedded("assets/sounds/button05.mp3.ogg");
    }

    private function playbackBG(): Void {
        //bgMusic.stop();
        //bgMusic.play();
        FlxG.sound.play("start_game.ogg", 1, true, true, playbackBG);
        //FlxSoundUtil.playWithCallback("assets/sounds/start_game.ogg", playbackBG);
    }

    private function createDialogs(): Void {
        dialogs = new Array<String>();
        Dialog.createAll(dialogs);
    }

    private function raiseDialog(timer: FlxTimer): Void {
        if (!next.alive) {
            next.revive();
            dialogBox.changeText("   " + dialogs[dialogIndex]);
            dialogBox.revive();
        }
    }

    // When a dialog box is clicked, it does...
    private function dialogCallback(button: Button): Void {
        buttonSound.stop();
        buttonSound.play();
        dialogIndex++;
        if (dialogs[dialogIndex] == "") {
            dialogBox.kill();
            dialogIndex++;
            next.kill();
            if (finished) {
                switchState(new MenuState());
            }
        } else {
            dialogBox.changeText("   " + dialogs[dialogIndex]);
        }
    }

    private function createItens(): Void {
        hammer    = new Button(moveToBar, 520, 400, "hammer.png");
        hammer.kill();
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
        fridge    = new Button(endGame, 570, 400, "fridge.png");

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
        add(fridge);
        add(hammer);
    }

    private function createRooms(): Void {
        rooms = new FlxGroup();
        rooms.add(new Button(roomCallback, overRoomCallback, 240, 270,
                             "bright1.png", "bedroom"));
        rooms.add(new Button(roomCallback, overRoomCallback, 430, 270,
                             "bright1.png", "office"));
        rooms.add(new Button(roomCallback, overRoomCallback, 575, 270,
                             "bright3.png", "bathroom"));
        detectiveRoom = new Button(roomCallback, overRoomCallback, 304, 383,
                             "bright4.png", "livingroom");
        rooms.add(detectiveRoom);
        rooms.add(new Button(roomCallback, overRoomCallback, 543, 383,
                             "bright5.png", "kitchen"));
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
        shadow.animation.add("throw", [0, 1, 2, 3, 4, 5, 0], 10, false);
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
        talkSound.stop();
        talkSound.play();
        if (!dialogBox.alive) {
            dialogIndex = 7;
            raiseDialog(timer);
        }
    }

    private function womanCallback(button: Button): Void {
        talkSound.stop();
        talkSound.play();
        if (!dialogBox.alive) {
            dialogIndex = 13;
            if (hasKey) {
                dialogIndex = 19;
            } else if (hasBooklet) {
                dialogIndex = 15;
                fakeWhy = true;
                key.revive();
            } else if (knownAffair) {
                dialogIndex = 21;
            } else if (hasDrugs) {
                dialogIndex = 17;
            }
            raiseDialog(timer);
        }
    }

    private function manCallback(button: Button): Void {
        talkSound.stop();
        talkSound.play();
        if (!dialogBox.alive) {
            dialogIndex = 27;
            if (hasKey) {
                dialogIndex = 29;
            } else if (noHammer) {
                dialogIndex = 23;
            } else if (hasDrugs) {
                dialogIndex = 25;
            }
            raiseDialog(timer);
        }
    }

    private function victimCallback(button: Button): Void {
        talkSound.stop();
        talkSound.play();
        if (!dialogBox.alive) {
            dialogIndex = 9;
            raiseDialog(timer);
        }
    }

    // Move an item to itemBar.
    private function moveToBar(button: Button): Void {
        var maybeDialogIndex: Int = -1;
        do {
            // If it is already on the bar, do nothing.
            if (button.getY() < 40) {
                break;
            }
            if (button == next) {
                dialogCallback(button);
                break;
            } if (next.alive) {
                return;
            } else if (button == dialogBox) {
                break;
            } else if (button == booklets) {
                maybeDialogIndex = 51;
                hasBooklet = true;
            } else if (button == key) {
                hasKey = true;
                if (noKeyInBathroom) {
                    maybeDialogIndex = 41;
                    how = true;
                } else {
                    maybeDialogIndex = 43;
                }
            } else if (button == lamp) {
                maybeDialogIndex = 49;
                break;
            } else if (button == door) {
                if (!noKeyInBathroom && hasKey) {
                    maybeDialogIndex = 39;
                    how = true;
                    break;
                }
                noKeyInBathroom = true;
                maybeDialogIndex = 35;
                if (hasKey) {
                    maybeDialogIndex = 37;
                    how = true;
                }
                break;
            } else if (button == pc) {
                maybeDialogIndex = 53;
                knownAffair = true;
                why = true;
                break;
            } else if (button == toilet) {
                maybeDialogIndex = 55;
                drugs.revive();
                hasDrugs = true;
                button = drugs;
            } else if (button == toolbox) {
                if (carpinter) {
                    maybeDialogIndex = 33;
                    noHammer = true;
                } else {
                    maybeDialogIndex = 31;
                }
                break;
            } else if (button == newspaper) {
                carpinter = true;
                maybeDialogIndex = 45;
                break;
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
            gettoSound.stop();
            gettoSound.play();
        } while (false);
        checkSound.stop();
        checkSound.play();
        if (maybeDialogIndex >= 0) {
            dialogIndex = maybeDialogIndex;
            raiseDialog(timer);
        }
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
        if (next.alive) {
            return;
        }
        rooms.callAll("revive");

        if (!dialogBox.alive) {
            dialogCallback(button);
            dialogIndex = 11;
            raiseDialog(timer);
        }
    }

    private function flashbackCallback(button: Button): Void {
        if (next.alive) {
            return;
        }
        if (detectiveRoom.text.text == "office") {
            sceneInOffice();
        } else if (detectiveRoom.text.text == "kitchen") {
            sceneInKitchen();
            finalScene = true;
        }
    }

    /***
     * Scene:
     * Everybody is hiden. Shadow apears in the offiece, where victim is alive.
     * Shadow goes to victim, attack and victim dies.
     * Shadow fades and everybody reapears.
     */
    private function sceneInOffice(): Void {
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

    /***
     * Scene:
     * Everybody is hiden. Shadow apears in the kitchen.
     * Shadow attacks. Hammer drops.
     * Shadow fades and everybody reapears.
     */
    private function sceneInKitchen(): Void {
        shadow.revive();
        shadow.alpha = 0;
        shadow.setPosition(465, 430);
        shadow.animation.play("idle");
        hammer.setPosition(520, 400);

        var options: TweenOptions;
        options = {
            type: FlxTween.ONESHOT,
            complete: cast shadowDropHammer,
        };
        FlxTween.multiVar(shadow, { x: 480, alpha: 1}, 2.0, options);

        detective.kill();
        woman.kill();
        man.kill();
        victim.kill();
    }

    private function shadowAttack(): Void {
        shadow.animation.play("kill");
        timer = FlxTimer.start(0.4, shadowWaits);
    }

    private function shadowDropHammer(): Void {
        shadow.animation.play("throw");
        timer = FlxTimer.start(0.4, hammerFall);
    }

    private function hammerFall(timer: FlxTimer): Void {
        hammer.revive();

        var options: TweenOptions;
        options = {
            type: FlxTween.ONESHOT,
            complete: cast hideHammer,
        };
        var p1: FlxPoint = new FlxPoint(hammer.getX() + 10, hammer.getY() - 10);
        var p2: FlxPoint = new FlxPoint(hammer.getX() + 20, hammer.getY());
        var p3: FlxPoint = new FlxPoint(hammer.getX() + 30, hammer.getY() + 15);
        var p4: FlxPoint = new FlxPoint(hammer.getX() + 40, hammer.getY() + 30);
        FlxTween.linearPath(hammer, [p1, p2, p3, p4], 0.6, true, options);
    }

    private function hideHammer(): Void {
        shadowFade2(timer);

        var options: TweenOptions;
        options = {
            type: FlxTween.ONESHOT,
            complete: cast killHammer
        };
        FlxTween.multiVar(hammer, { alpha: 0}, 2.0, options);
    }

    private function killHammer(): Void {
        hammer.alpha = 1;
        hammer.kill();
        reviveAll();
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

    private function shadowFade2(timer: FlxTimer): Void {
        var options: TweenOptions;
        options = {
            type: FlxTween.ONESHOT,
        };
        FlxTween.multiVar(shadow, { x: 550, alpha: 0}, 0.8, options);
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

        dialogBox = new Button(moveToBar, 400, 523, "dialogBox.png",
                               "   " + dialogs[0], 0xffffff, 20);
        add(dialogBox);
        add(dialogBox.text);

        flashback = new Button(flashbackCallback, FlxG.width - 80, 32,
                               "flashback.png");
        add(flashback);

        move = new Button(moveCallback, FlxG.width - 40, 32, "move.png");
        add(move);
    }

    private function endGame(button: Button): Void {
        if (!finalScene) {
            return;
        }
        dialogIndex = 57;
        raiseDialog(timer);
        hammer.revive();
        hammer.alpha = 0;
        var options: TweenOptions;
        options = {
            type: FlxTween.ONESHOT,
        };
        FlxTween.multiVar(hammer, { x: 400, y: 100, alpha: 1, angle: -90}, 5.0, options);
        finished = true;
    }

    private function accusationScene(): Void {
        switchState(new MenuState());
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
