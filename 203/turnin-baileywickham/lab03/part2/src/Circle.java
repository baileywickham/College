public class Circle {
    private final Point center;
    private final double radius;

    public Circle (Point center, double radius) {
        this.center = center;
        this.radius = radius;
    }
    public double getRadius() {
        return radius;
    }
    public Point getCenter () {
        return center;
    }
    public double perimeter() {
        return getRadius() * 2 * Math.PI;
    }

}
