import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxState;
import flixel.util.FlxArrayUtil;

/**
 * This class is only necessary when the target is HTML5. See comment in
 * State.hx for the explanation.
 */
#if web
class StateManager extends FlxState {
    public static var initialState(null,default): Class<State> = null;
    private var currentState: State;
    private var nextState: State;

    public function new() {
        super();
        currentState = null;
        nextState = null;
    }

    public function switchState(state: State): Void {
        state.stateManager = this;
        nextState = state;
    }

	override public function create(): Void {
		super.create();

        if (initialState != null) {
            switchState(Type.createInstance(initialState, []));
        }
	}

	override public function destroy(): Void {
		super.destroy();

        if (currentState != null) {
            currentState.destroy();
            currentState = null;
        }
	}

	override public function update(): Void	{
		super.update();

        if (currentState != null) {
            currentState.update();
        }

        if (nextState != null) {
            if (currentState != null) {
                currentState.destroy();
            }
            nextState.create();
            currentState = nextState;
            nextState = null;
        }
	}

	override public function draw(): Void {
		super.draw();

        if (currentState != null && nextState == null) {
            currentState.draw();
        }
	}

    #if !FLX_NO_DEBUG
	override public function drawDebug(): Void	{
		super.drawDebug();

        if (currentState != null && nextState == null) {
            currentState.drawDebug();
        }
	}
    #end
}
#end
