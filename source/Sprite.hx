import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxPoint;

class Sprite extends FlxSprite {
    private var anchor: FlxPoint;

    public function new(X: Float = 0, Y: Float = 0, ?image: Dynamic,
                        animated: Bool = false, reversible: Bool = false,
                        frameWidth: Int = 0, frameHeight: Int = 0,
                        anchorX: Float = 0, anchorY: Float = 0) {
        super(X, Y);

        var imagesPath: String = "assets/images/high_res/";
        if (FlxG.width < 900) {
            imagesPath = "assets/images/low_res/";
            frameWidth = Math.floor(frameWidth / 2);
            frameHeight = Math.floor(frameHeight / 2);
        }

        //loadGraphic(image, animated, reversible, width, height)
        loadGraphic(imagesPath + image, animated, reversible, frameWidth,
                    frameHeight);

        anchor = new FlxPoint(anchorX, anchorY);
        setPosition(X, Y);
    }

    override public function setPosition(X: Float = 0, Y: Float = 0): Void {
        x = X - anchor.x;
        y = Y - anchor.y;
    }

    public function getPosition(): FlxPoint {
        return new FlxPoint(x + anchor.x, y + anchor.y);
    }

    public function setX(X: Float): Float {
        return (x = X - anchor.x);
    }

    public function getX(): Float {
        return x + anchor.x;
    }

    public function setY(Y: Float): Float {
        return (y = Y - anchor.y);
    }

    public function getY(): Float {
        return y + anchor.y;
    }

    public function setAnchor(X: Float = 0, Y: Float = 0): Void {
        anchor = new FlxPoint(X, Y);
        setPosition(x, y);
    }

    public function getAnchor(): FlxPoint {
        return anchor;
    }
}
