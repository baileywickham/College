import java.awt.Color;

public class Rectangle implements Shape {
    private Color color;
    private double width;
    private double height;
    private Point topleft;

    public Rectangle(double width, double height, Point topleft, Color color) {
     this.width = width;
     this.height = height;
     this.topleft = topleft;
     this.color = color;
    }
    public double getWidth() {
        return this.width;
    }
    public void setWidth(double x) {
        this.width = x;
    }
    public double getHeight() {
        return this.height;
    }
    public void setHeight(double h) {
        this.height = h;
    }
    public Point getTopLeft() {
        return this.topleft;
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
        return  this.width * this.height;
    }

    @Override
    public double getPerimeter() {
        return 4 * this.height * this.width;
    }

    @Override
    public void translate(double x, double y) {
        this.topleft = new Point(this.topleft.x +x, this.topleft.y+y);
    }
}
