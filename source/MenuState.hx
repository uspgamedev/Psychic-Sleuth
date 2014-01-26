import flash.Lib;
import flash.system.System;
import flash.events.Event;
import flash.events.KeyboardEvent;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxRandom;
import flixel.system.FlxSound;

class MenuState extends State {
    private var buttonPlay: Button;
    private var buttonExit: Button;
    private var background: Sprite;
    private var confirmSound: FlxSound;

	override public function create(): Void {
        Lib.trace("MenuState: update: create");
		FlxG.cameras.bgColor = 0xff131c1b;

        background = new Sprite(0, 0, "titlescreen.png");
        add(background);

        buttonPlay = new Button(playCallback, 400, 350, "button.png", " Play",
                                0x000000);
        buttonExit = new Button(exitCallback, 400, 430, "button.png", " Exit",
                                0x000000);

        confirmSound = new FlxSound();
        confirmSound.loadEmbedded("assets/sounds/archiviment.ogg");

        add(buttonPlay);
        add(buttonPlay.text);
        add(buttonExit);
        add(buttonExit.text);

		super.create();
	}

	override public function destroy(): Void {
		super.destroy();
	}

	override public function update(): Void	{
        #if !mobile
        if (FlxG.keyboard.justReleased("SPACE")) {
            Lib.trace("MenuState: update: SPACE");
            switchState(new PlayState());
        }
        #end

		super.update();
	}

    override public function onBackButton(event: KeyboardEvent): Void {
        // Get ESCAPE from keyboard or BACK from android.
        if (event.keyCode == 27) {
            #if !web
            //event.stopImmediatePropagation();
            System.exit(0);
            #end
        }
    }

    private function playCallback(button: Button): Void {
        confirmSound.stop();
        confirmSound.play();
        switchState(new PlayState());
    }

    private function exitCallback(button: Button): Void {
        #if !web
        //event.stopImmediatePropagation();
        System.exit(0);
        #end
    }
}
