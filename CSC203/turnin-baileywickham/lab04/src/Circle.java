import java.awt.Color;

class Circle implements Shape {
    private Color color;
    private double radius;
    // center must not be private: translate
    private Point center;

    public Circle(double radius, Point center, Color color) {
        this.radius = radius;
        this.center = center;
        this.color = color;
    }
    public double getRadius() {
        return this.radius;
    }
    public void setRadius(double r) {
        this.radius = r;
    }
    public Point getCenter() {
        return this.center;
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
        return (this.radius * this.radius ) * Math.PI ;
    }

    @Override
    public double getPerimeter() {
        return 2 * Math.PI * this.radius;
    }

    @Override
    public void translate(double x, double y) {
        this.center = new Point(this.center.x + x, this.center.y + y);
    }
}
