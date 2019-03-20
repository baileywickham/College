import java.awt.*;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class WorkSpace {
    private List<Shape> shapes = new ArrayList<>();

    public void add(Shape shape) {
        shapes.add(shape);
    }
    public Shape get(int index) {
        return shapes.get(index);
    }
    public int size() {
        return shapes.size();
    }
    // thank god for functional programming
    public List<Circle> getCircles() {
        return shapes.stream().filter(s -> s instanceof Circle).map(Circle.class::cast).collect(Collectors.toList());
    }
    public List<Rectangle> getRectangles() {
        return shapes.stream().filter(s -> s instanceof Rectangle).map(Rectangle.class::cast).collect(Collectors.toList());
    }
    public List<Triangle> getTriangles() {
        return shapes.stream().filter(s -> s instanceof Triangle).map(Triangle.class::cast).collect(Collectors.toList());
    }
    public List<ConvexPolygon> getConvexPolygons() {
        return shapes.stream().filter(s -> s instanceof ConvexPolygon).map(ConvexPolygon.class::cast).collect(Collectors.toList());
    }
    public List<Shape> getShapesByColor(Color color) {
        return shapes.stream().filter(s -> s.getColor() == color).collect(Collectors.toList());
    }
    double getAreaOfAllShapes() {
        double p = 0;
        for (Shape s : shapes) {
            p += s.getArea();
        }
        return p;
    }
    double getPerimeterOfAllShapes() {
        double p = 0;
        for (Shape s : shapes) {
            p += s.getPerimeter();
        }
        return p;
    }
    
}
