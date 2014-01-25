import flash.Lib;
import flash.events.Event;
import flash.events.KeyboardEvent;

import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxState;
import flixel.util.FlxArrayUtil;

/**
 * Flixel crashes when trying to reuse a FlxState in HTML5. So when the target
 * is not web, our State is just an FlxState. Otherwise, our class does not
 * extends any other and needs to implement every method of FlxState. Besides
 * that, a StateManager is needed once we are not using FlxState.
 */
#if !web
class State extends FlxState {
    public function new() {
        super();
        manageListener();
    }

    public function switchState(newState: State) {
        FlxG.switchState(newState);
    }

    override public function destroy(): Void {
        if (Lib.current.stage.hasEventListener(KeyboardEvent.KEY_UP)) {
            Lib.current.stage.removeEventListener(KeyboardEvent.KEY_UP,
                                                  onBackButton);
        }

        super.destroy();
    }
#else
class State {
    public var stateManager(null,default): StateManager;
    private var entities: Array<FlxBasic>;
    private var length: Int;

    public function new() {
        stateManager = null;
        length = 0;
        entities = new Array<FlxBasic>();
        FlxArrayUtil.setLength(entities, 1);
        manageListener();
    }

    public function create(): Void {
    }

    public function destroy(): Void {
        var i: Int = 0;
        while (i < length) {
            var entity: FlxBasic = entities[i++];
            if (entity != null) {
                entity.destroy();
            }
        }
        if (Lib.current.stage.hasEventListener(KeyboardEvent.KEY_UP)) {
            Lib.current.stage.removeEventListener(KeyboardEvent.KEY_UP,
                                                  onBackButton);
        }
    }

    public function update(): Void {
        var i: Int = 0;
        while (i < length) {
            var entity: FlxBasic = entities[i++];
            if (entity != null && entity.exists && entity.active) {
                entity.update();
            }
        }
    }

    public function draw(): Void {
        var i: Int = 0;
        while (i < length) {
            var entity: FlxBasic = entities[i++];
            if (entity != null && entity.exists && entity.visible) {
                entity.draw();
            }
        }
    }

    #if !FLX_NO_DEBUG
    public function drawDebug(): Void {
        var i: Int = 0;
        while (i < length) {
            var entity: FlxBasic = entities[i++];
            if (entity != null && entity.exists && entity.visible) {
                entity.drawDebug();
            }
        }
    }
    #end

    public function switchState(newState: State): Void {
        if (stateManager != null) {
            stateManager.switchState(newState);
        }
    }

    public function add(entity: FlxBasic): FlxBasic {
        if (entity != null) {
            // got it already
            if (FlxArrayUtil.indexOf(entities, entity) >= 0) {
                return entity;
            }

            // add entity to the list
            if (++length > entities.length) {
                FlxArrayUtil.setLength(entities, entities.length * 2);
            }
            entities[length - 1] = entity;

            // done!
            return entity;
        }
        else {
            return null;
        }
    }
#end

    /**
     * This methods are the same for web or non-web targets.
     */
    private function manageListener(): Void {
        if (Lib.current.stage.hasEventListener(KeyboardEvent.KEY_UP)) {
            Lib.current.stage.removeEventListener(KeyboardEvent.KEY_UP, onBackButton);
        }
        Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, onBackButton);
    }

    public function onBackButton(event: KeyboardEvent): Void {
    }
}
