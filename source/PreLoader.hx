import flash.Lib;
import flash.system.System;
import flash.events.Event;
import flash.events.KeyboardEvent;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.system.FlxSound;

class PreLoader extends State {
    private var spriteAssets: Array<String>;
    private var soundAssets: Array<String>;

    private var spriteAssetIndex: Int;
    private var soundAssetIndex: Int;

    private var text: FlxText;
    private var string: String;

	override public function create(): Void {
        super.create();
        Lib.trace("Loading");
        string = "Loading";
        spriteAssets = [
            "background.png",
            "button.png",
            "explosion.png",
        ];
        soundAssets = [
            "underwater_explosion.ogg",
        ];

        spriteAssetIndex = 0;
        soundAssetIndex = 0;

        text = new FlxText(20, 20, 600, string);
        text.color = 0xFFFFFF;
        text.size = 30;
        add(text);
    }

	override public function destroy(): Void {
		super.destroy();
	}

    override public function update(): Void {
        if (spriteAssetIndex < spriteAssets.length) {
            Lib.trace("Loading " + spriteAssets[spriteAssetIndex]);
            string = "Loading " + spriteAssets[spriteAssetIndex];

            var sprite: Sprite = new Sprite(0, 0,
                                            spriteAssets[spriteAssetIndex]);
            spriteAssetIndex++;
        } else if (soundAssetIndex < soundAssets.length) {
            Lib.trace("Loading " + soundAssets[soundAssetIndex]);
            string = "Loading " + soundAssets[soundAssetIndex];

            var sound: FlxSound = new FlxSound();
            sound.loadEmbedded("assets/sounds/" + soundAssets[soundAssetIndex]);
            soundAssetIndex++;
        } else {
            Lib.trace("Loading finished!");
            string = "Loading finished!";
            switchState(new MenuState());
        }
        text.text = string;
        super.update();
    }

    override public function onBackButton(event: KeyboardEvent): Void {
        // Get ESCAPE from keyboard or BACK from android.
        if (event.keyCode == 27) {
            #if android
            System.exit(0);
            event.stopImmediatePropagation();
            #end
        }
    }
}
