
import java.awt.Color;
import java.awt.Graphics;

/**
 * A circle in 2D space that knows how to draw itself and calculate its area.
 */


public class Circle implements Shape {

    private Point center;
    private float radius;
    private Color color;

    public Circle(Point center, float radius, Color color) {
        this.center = center;
        this.radius = radius;
        this.color = color;
    }

    @Override
    public float getArea() {
        return (float) (Math.PI * radius * radius);
    }

    @Override
    public void paint(Graphics g) {
        g.setColor(color);
        int width = Math.round(2 * radius);
        int height = Math.round(2 * radius);
        int x = (int) Math.round(center.getX() - radius);
        int y = (int) Math.round(center.getY() - radius);
        g.fillOval(x, y, width, height);
    }
}

