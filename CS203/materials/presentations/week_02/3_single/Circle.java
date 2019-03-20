
import java.awt.Color;
import java.awt.Graphics;
import java.awt.Rectangle;

/**
 * A circle in 2D space that knows how to draw itself and calculate its area.
 */


public class Circle {

    private Point center;
    private float radius;
    private Color color;

    public Circle(Point center, float radius, Color color) {
        this.center = center;
        this.radius = radius;
        this.color = color;
    }

    public float getArea() {
        return (float) (Math.PI * radius * radius);
    }

    public Rectangle getBounds() {
        Rectangle result = new Rectangle();
        result.width = Math.round(2 * radius);
        result.height = Math.round(2 * radius);
        result.x = (int) Math.round(center.getX() - radius);
        result.y = (int) Math.round(center.getY() - radius);
        return result;
    }

    public Color getColor() {
        return color;
    }
}

