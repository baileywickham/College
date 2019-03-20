import java.awt.Color;
public interface Shape {
    // Must instantiate color, default black
    Color getColor();
    void setColor(Color color);
    double getArea();
    double getPerimeter();
    void translate(double x, double y);
}
