
import java.awt.*;

/**
 * A square in 2D space that knows how to draw itself and calculate its area.
 */


public class Square implements Shape {

    private Point upperLeft;
    private Point lowerRight;
    private Color color;

    public Square(Point upperLeft, Point lowerRight, Color color) {
        this.upperLeft = upperLeft;
        this.lowerRight = lowerRight;
        this.color = color;
    }

    private float getWidth() {
        return lowerRight.getX() - upperLeft.getX();
    }

    private float getHeight() {
        return lowerRight.getY() - upperLeft.getY();
            // Remember, in compuer graphics, 0,0 is the upper-left hand corner of the screen
    }

    @Override
    public float getArea() {
        return getWidth() * getHeight();
    }

    @Override
    public void visit(Visitor v) {
        v.visitSquare(this);
    }

    public Rectangle getBounds() {
        return new Rectangle((int) Math.round(upperLeft.getX()), (int) Math.round(upperLeft.getY()),
                (int) Math.round(getWidth()), (int) Math.round(getHeight()));
    }

    public Color getColor() {
        return color;
    }
}

