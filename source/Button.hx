import flixel.FlxG;
import flixel.util.FlxPoint;
import flixel.text.FlxText;
import flixel.group.FlxGroup;

class Button extends FlxGroup {
    private var label: String;
    private var text: FlxText;
    private var background: Sprite;
    private var onClickCallback: Void->Void;

    public function new(?callback: Void->Void, X: Float = 0, Y: Float = 0,
                        _background: String = "", _label: String = "",
                        color: Int = 0xffffff, size: Int = 30) {
        super();

        onClickCallback = callback;
        label = _label;
        background = new Sprite(X, Y, _background);
        background.setAnchor(background.width / 2, background.height / 2);

        text = new FlxText(X, Y, cast(background.width, Int), label, size);
        text.color = color;
        text.x -= background.getAnchor().x;
        text.y -= text.height / 2 ;
        text.alignment = "center";

        add(background);
        add(text);
    }

    public function overlapsPoint(point: FlxPoint): Bool {
        return background.overlapsPoint(point);
    }

    public function setPosition(X: Float = 0, Y: Float = 0): Void {
        text.x = X;
        text.y = Y;
        background.setPosition(X, Y);
    }

    public function getPosition(): FlxPoint {
        return background.getPosition();
    }

    public function setX(X: Float): Float {
        text.x = X;
        return background.setX(X);
    }

    public function getX(): Float {
        return background.getX();
    }

    public function setY(Y: Float): Float {
        text.y = Y;
        return background.setY(Y);
    }

    public function getY(): Float {
        return background.getY();
    }

    override public function update(): Void {
        super.update();

        #if !mobile
        if (FlxG.mouse.justReleased) {
            if (overlapsPoint(FlxG.mouse)) {
                onClickCallback();
            }
        }
        #end

        #if android
        for (touch in FlxG.touches.list) {
            if (touch.justPressed) {
                if (overlapsPoint(touch)) {
                    onClickCallback();
                }
            }
        }
        #end
    }
}
