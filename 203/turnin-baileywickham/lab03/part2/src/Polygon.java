import java.util.List;

public class Polygon {
    private final List<Point> points;

    public Polygon(List<Point> points) {
        this.points = points;
    }

    public List<Point> getPoints() {
        return points;
    }

    public double perimeter() {
        double p = 0;
        for (int i = 1; i < this.getPoints().size(); i++) {
            // yikes
            p += getDistance(this.getPoints().get(i - 1), this.getPoints().get(i));
        }
        // again, yikes
        p += getDistance(this.getPoints().get(this.getPoints().size() - 1), this.getPoints().get(0));
        return p;
    }

    private double getDistance(Point p1, Point p2) {
        double x1 = p1.getX();
        double x2 = p2.getX();
        double y1 = p1.getY();
        double y2 = p2.getY();

        return Math.sqrt((y2 - y1) * (y2 - y1) + (x2 - x1) * (x2 - x1));

    }
}
