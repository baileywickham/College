import jdk.nashorn.api.tree.NewTree;

import java.awt.*;

public class Triangle implements Shape {
    private Point v1;
    private Point v2;
    private Point v3;
    private Color color;

    public Triangle(Point v1, Point v2, Point v3, Color color) {
        this.v1 = v1;
        this.v2 = v2;
        this.v3 = v3;
        this.color = color;
    }
    public Point getVertexA() {
        return this.v1;
    }
    public Point getVertexB() {
        return this.v2;
    }
    public Point getVertexC() {
        return this.v3;
    }

    @Override
    public Color getColor() {
        return this.color;
    }

    @Override
    public void setColor(Color color) {
        this.color = color;
    }

    @Override
    public double getArea() {
        return .5 * ((v1.x * (v2.y- v3.y)) + (v2.x * (v3.y - v1.y)) + (v3.x * (v1.x - v2.y)));
    }

    @Override
    public double getPerimeter() {
        double l1 = Math.sqrt(Math.pow(v1.x - v2.x,2) + Math.pow(v1.y - v2.y,2));
        double l2 = Math.sqrt(Math.pow(v1.x - v3.x,2) + Math.pow(v1.y - v3.y,2));
        double l3 = Math.sqrt(Math.pow(v3.x - v2.x,2) + Math.pow(v3.y - v2.y,2));
        return l1 + l2 + l3;
    }

    @Override
    public void translate(double x, double y) {
        this.v1 = new Point(v1.x + x, v1.y + y);
        this.v2 = new Point(v2.x + x, v2.y +y);
        this.v3 = new Point(v3.x + x, v3.y + y);
    }
}
