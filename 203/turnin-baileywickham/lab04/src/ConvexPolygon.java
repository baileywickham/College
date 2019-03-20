import java.awt.*;

public class ConvexPolygon implements Shape {
    private Color color;
    private Point[] points;
    public ConvexPolygon(Point[] points, Color color) {
        this.points = points;
        this.color = color;
    }

    public Point getVertex(int i) {
        return points[i];
    }
    public int getNumVertices() {
        return points.length;
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
        double p = 0;
        double q = 0;
        for (int i = 0; i < points.length; i++) {
            p += points[i].x * points[(i+1) % points.length].y;
            q += points[i].y * points[(i+1) % points.length].x;
        }
        return .5 * (p - q);

    }

    @Override
    public double getPerimeter() {
        double p = 0;
        for (int i = 1; i < this.points.length; i++) {
            // yikes
            p += getDistance(points[i - 1], points[i]);
        }
        // again, yikes
        p += getDistance(this.points[this.points.length-1], points[0]);
        return p;
    }

    @Override
    public void translate(double x, double y) {
        for (int i = 0; i < points.length; i++) {
            points[i] = new Point(points[i].x +x, points[i].y +y);
        }
    }

    private double getDistance(Point p1, Point p2) {
        double x1 = p1.x;
        double x2 = p2.x;
        double y1 = p1.y;
        double y2 = p2.y;

        return Math.sqrt((y2 - y1) * (y2 - y1) + (x2 - x1) * (x2 - x1));

    }
}
