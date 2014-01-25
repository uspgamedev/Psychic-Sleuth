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

	override public function create(): Void {
        // Add background
        background = new Sprite(0, 0, "background.png");
        add(background);

        createRooms();
        createDialogs();

        // Setup the HUD
        createHUD();

        // Place all itens on the scene
        createItens();

        textTimer = FlxTimer.start(0.75, raiseDialog);
        dialogIndex = 0;
        // Done!!
		super.create();
	}

    private function createDialogs(): Void {
        dialogs = new Array<String>();

        dialogs.push("   This is the crime scene.\n" +
                     "   You are the detective. But not a regular one.");
        dialogs.push("   While in a crime scene, you have the power so see" +
                     "\n   what happend..." );
        dialogs.push("   ... as you were the criminal.");
        dialogs.push("");
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

    private function roomCallback(button: Button): Void {
        rooms.callAll("kill");
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
