import flixel.FlxG;
import flixel.util.FlxPoint;
import flixel.text.FlxText;
import flixel.group.FlxGroup;

class Button extends Sprite {
    private var label: String;
    public var text: FlxText;
    private var onClickCallback: Button->Void;
    private var mouseOverCallback: Button->Void;

    public function new(?callback: Button->Void, ?overCallback: Button-> Void,
                        X: Float = 0, Y: Float = 0,
                        _background: String = "", _label: String = "",
                        color: Int = 0xffffff, size: Int = 30) {
        super(X, Y, _background);

        onClickCallback = callback;
        mouseOverCallback = overCallback;
        label = _label;
        setAnchor(width / 2, height / 2);

        text = new FlxText(X, Y, cast(width, Int), label, size);
        text.color = color;
        text.x -= getAnchor().x;
        text.y -= text.height / 2 ;
        text.alignment = "center";
    }

    override public function setPosition(X: Float = 0, Y: Float = 0): Void {
        super.setPosition(X, Y);
        if (text != null) {
            text.x = X;
            text.y = Y;
        }
    }

    override public function setX(X: Float): Float {
        text.x = X;
        return super.setX(X);
    }

    override public function setY(Y: Float): Float {
        text.y = Y;
        return super.setY(Y);
    }

    override public function kill(): Void {
        super.kill();
        text.kill();
    }

    override public function revive(): Void {
        super.revive();
        text.revive();
    }

    override public function update(): Void {
        super.update();

        #if !mobile
        if (FlxG.mouse.justReleased) {
            if (overlapsPoint(FlxG.mouse)) {
                onClickCallback(this);
            }
        } else if (overlapsPoint(FlxG.mouse)) {
            mouseOverCallback(this);
        }
        #end

        #if android
        for (touch in FlxG.touches.list) {
            if (touch.justPressed) {
                if (overlapsPoint(touch)) {
                    onClickCallback(this);
                }
            }
        }
        #end
    }
}
